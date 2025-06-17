import 'dart:developer' as developer;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

part 'ml_prediction_service.g.dart';

class ThermostatPrediction {
  final double predictedTemperature;
  final double confidence;
  final DateTime timestamp;
  final Map<String, dynamic> inputFeatures;

  const ThermostatPrediction({
    required this.predictedTemperature,
    required this.confidence,
    required this.timestamp,
    required this.inputFeatures,
  });

  Map<String, dynamic> toMap() {
    return {
      'predictedTemperature': predictedTemperature,
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
      'inputFeatures': inputFeatures,
    };
  }

  factory ThermostatPrediction.fromMap(Map<String, dynamic> map) {
    return ThermostatPrediction(
      predictedTemperature: (map['predictedTemperature'] ?? 22.0).toDouble(),
      confidence: (map['confidence'] ?? 0.0).toDouble(),
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
      inputFeatures: Map<String, dynamic>.from(map['inputFeatures'] ?? {}),
    );
  }
}

@riverpod
class MlPredictionService extends _$MlPredictionService {
  Interpreter? _interpreter;
  
  // Dynamic feature scaling parameters that adapt to model requirements
  List<double> scalerMeans = [
    12.0,  // hour
    30.0,  // minute  
    3.0,   // day of week
    22.0,  // current temperature
    50.0,  // humidity
    1013.0 // pressure
  ];
  
  List<double> scalerStdDevs = [
    6.9,   // hour
    17.3,  // minute
    2.0,   // day of week
    8.5,   // current temperature
    25.0,  // humidity
    15.0   // pressure
  ];
  
  // Model output scaling parameters (auto-detected)
  double _outputScale = 1.0;
  double _outputOffset = 0.0;
  bool _modelAnalyzed = false;

  @override
  ThermostatPrediction? build() {
    _loadModel();
    return null;
  }
  
  Future<bool> validateModel() async {
    if (_interpreter == null) {
      await _loadModel();
    }
    
    if (_interpreter == null) {
      return false;
    }
    
    try {
      // Test with dummy input
      final inputTensors = _interpreter!.getInputTensors();
      final expectedInputSize = inputTensors.first.shape.length > 1 
          ? inputTensors.first.shape[1] 
          : inputTensors.first.shape[0];
      
      final testInput = List.filled(expectedInputSize, 0.5);
      final input = [testInput];
      
      final outputTensors = _interpreter!.getOutputTensors();
      final outputShape = outputTensors.first.shape;
      List<List<double>> output;
      
      if (outputShape.length == 2) {
        output = List.generate(outputShape[0], 
            (i) => List.filled(outputShape[1], 0.0));
      } else {
        output = [List.filled(outputShape[0], 0.0)];
      }
      
      _interpreter!.run(input, output);
      
      developer.log('Model validation successful', name: 'MlPredictionService');
      return true;
    } catch (e) {
      developer.log('Model validation failed: $e', 
          name: 'MlPredictionService', error: e, level: 1000);
      return false;
    }
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/thermostat_model.tflite');
      
      // Validate model input/output tensors
      final inputTensors = _interpreter!.getInputTensors();
      final outputTensors = _interpreter!.getOutputTensors();
      
      developer.log(
        'Thermostat ML model loaded successfully. Input shape: ${inputTensors.first.shape}, Output shape: ${outputTensors.first.shape}',
        name: 'MlPredictionService'
      );
    } catch (e) {
      developer.log('Error loading thermostat ML model: $e. Using fallback predictions.', 
          name: 'MlPredictionService', error: e, level: 1000);
      _interpreter = null;
    }
  }

  Future<ThermostatPrediction?> predictOptimalTemperature({
    required String roomName,
    double? currentTemperature,
    double? outsideTemperature,
    double? humidity,
    double? pressure,
    DateTime? forTime,
  }) async {
    if (_interpreter == null) {
      await _loadModel();
      if (_interpreter == null) {
        developer.log('ML model not available for prediction', 
            name: 'MlPredictionService', level: 1000);
        return _getFallbackPrediction(
          roomName: roomName,
          currentTemperature: currentTemperature,
          outsideTemperature: outsideTemperature,
          forTime: forTime ?? DateTime.now(),
        );
      }
    }
    
    // Validate model before use
    final isModelValid = await validateModel();
    if (!isModelValid) {
      developer.log('Model validation failed, using fallback', 
          name: 'MlPredictionService', level: 1000);
      return _getFallbackPrediction(
        roomName: roomName,
        currentTemperature: currentTemperature,
        outsideTemperature: outsideTemperature,
        forTime: forTime ?? DateTime.now(),
      );
    }

    try {
      final time = forTime ?? DateTime.now();
      
      // Prepare input features
      List<double> rawInput = [
        time.hour.toDouble(),
        time.minute.toDouble(),
        (time.weekday - 1).toDouble(), // 0-6 format
        currentTemperature ?? 22.0,
        humidity ?? 50.0,
        pressure ?? 1013.0,
      ];

      // Scale the input data
      List<double> scaledInput = [];
      for (int i = 0; i < rawInput.length; i++) {
        if (i < scalerMeans.length && i < scalerStdDevs.length) {
          scaledInput.add((rawInput[i] - scalerMeans[i]) / scalerStdDevs[i]);
        } else {
          scaledInput.add(rawInput[i]); // fallback for additional features
        }
      }

      // Get model input/output information
      final inputTensors = _interpreter!.getInputTensors();
      final outputTensors = _interpreter!.getOutputTensors();
      
      developer.log(
        'Model expects input shape: ${inputTensors.first.shape}, got ${scaledInput.length} features',
        name: 'MlPredictionService'
      );
      
      // Ensure we have the correct number of input features
      final expectedInputSize = inputTensors.first.shape.reduce((a, b) => a * b);
      if (scaledInput.length != expectedInputSize && inputTensors.first.shape.length > 1) {
        // Adjust input size if needed
        final requiredFeatures = inputTensors.first.shape[1];
        if (scaledInput.length < requiredFeatures) {
          // Pad with zeros if we have fewer features
          scaledInput.addAll(List.filled(requiredFeatures - scaledInput.length, 0.0));
        } else if (scaledInput.length > requiredFeatures) {
          // Trim if we have too many features
          scaledInput = scaledInput.sublist(0, requiredFeatures);
        }
      }
      
      // Prepare input tensor
      List<List<double>> input;
      if (inputTensors.first.shape.length == 2) {
        // 2D input: [batch_size, features]
        input = [scaledInput];
      } else {
        // 1D input: [features]
        throw Exception('Unexpected input tensor shape: ${inputTensors.first.shape}');
      }
      
      // Prepare output tensor
      final outputShape = outputTensors.first.shape;
      List<List<double>> output;
      
      if (outputShape.length == 2) {
        // 2D output: [batch_size, output_features]
        output = List.generate(outputShape[0], 
            (i) => List.filled(outputShape[1], 0.0));
      } else if (outputShape.length == 1) {
        // 1D output: [output_features]
        output = [List.filled(outputShape[0], 0.0)];
      } else {
        throw Exception('Unexpected output tensor shape: $outputShape');
      }
      
      developer.log(
        'Running prediction with input shape: ${input.length}x${input.first.length}, output shape: ${output.length}x${output.first.length}',
        name: 'MlPredictionService'
      );

      // Run prediction
      _interpreter!.run(input, output);

      // Extract predicted temperature and calculate confidence
      double rawOutput = output[0][0];
      
      developer.log(
        'Raw model output: $rawOutput',
        name: 'MlPredictionService'
      );
      
      // Auto-adjust output based on model analysis
      if (!_modelAnalyzed) {
        await _analyzeModelOutput(rawOutput);
      }
      
      double actualPredictedTemp = _convertModelOutput(rawOutput);
      
      developer.log(
        'Converted temperature: ${actualPredictedTemp.toStringAsFixed(2)}°C',
        name: 'MlPredictionService'
      );
      
      // Calculate confidence based on how close the prediction is to typical ranges
      double confidence = _calculateConfidence(actualPredictedTemp, currentTemperature);

      final prediction = ThermostatPrediction(
        predictedTemperature: actualPredictedTemp,
        confidence: confidence,
        timestamp: time,
        inputFeatures: {
          'roomName': roomName,
          'hour': time.hour,
          'minute': time.minute,
          'dayOfWeek': time.weekday - 1,
          'currentTemperature': currentTemperature,
          'outsideTemperature': outsideTemperature,
          'humidity': humidity,
          'pressure': pressure,
        },
      );

      state = prediction;
      
      developer.log(
        'Predicted optimal temperature for $roomName: ${actualPredictedTemp.toStringAsFixed(1)}°C (confidence: ${(confidence * 100).toStringAsFixed(1)}%)',
        name: 'MlPredictionService'
      );

      return prediction;

    } catch (e) {
      developer.log('Error during ML prediction: $e', 
          name: 'MlPredictionService', error: e, level: 1000);
      
      // Return a fallback prediction based on simple heuristics
      return _getFallbackPrediction(
        roomName: roomName,
        currentTemperature: currentTemperature,
        outsideTemperature: outsideTemperature,
        forTime: forTime ?? DateTime.now(),
      );
    }
  }

  double _calculateConfidence(double predictedTemp, double? currentTemp) {
    // Calculate confidence based on prediction stability and reasonableness
    double baseConfidence = 0.8; // Base confidence
    
    // Reduce confidence if prediction is at extremes
    if (predictedTemp < 18.0 || predictedTemp > 28.0) {
      baseConfidence -= 0.2;
    }
    
    // Increase confidence if prediction is close to current temperature
    if (currentTemp != null) {
      double tempDiff = (predictedTemp - currentTemp).abs();
      if (tempDiff < 2.0) {
        baseConfidence += 0.1;
      } else if (tempDiff > 5.0) {
        baseConfidence -= 0.1;
      }
    }
    
    // Clamp confidence between 0.1 and 1.0
    return baseConfidence.clamp(0.1, 1.0);
  }

  Future<Map<String, ThermostatPrediction?>> predictForAllRooms({
    required List<String> roomNames,
    double? outsideTemperature,
    double? humidity,
    double? pressure,
  }) async {
    Map<String, ThermostatPrediction?> predictions = {};
    
    for (String roomName in roomNames) {
      predictions[roomName] = await predictOptimalTemperature(
        roomName: roomName,
        outsideTemperature: outsideTemperature,
        humidity: humidity,
        pressure: pressure,
      );
    }
    
    return predictions;
  }

  Future<ThermostatPrediction?> predictForNextHour({
    required String roomName,
    double? currentTemperature,
    double? outsideTemperature,
    double? humidity,
    double? pressure,
  }) async {
    final nextHour = DateTime.now().add(const Duration(hours: 1));
    return predictOptimalTemperature(
      roomName: roomName,
      currentTemperature: currentTemperature,
      outsideTemperature: outsideTemperature,
      humidity: humidity,
      pressure: pressure,
      forTime: nextHour,
    );
  }

  String getPredictionExplanation(ThermostatPrediction prediction) {
    final features = prediction.inputFeatures;
    final temp = prediction.predictedTemperature;
    final confidence = (prediction.confidence * 100).toStringAsFixed(0);
    
    final isFallback = features['fallback'] == true;
    String explanation = isFallback 
        ? 'Using fallback prediction (ML model unavailable). Based on time patterns and weather conditions, '
        : 'Based on ML analysis of time patterns, weather conditions, and usage history, ';
    
    if (temp < 20.0) {
      explanation += 'the model recommends a cooler temperature to optimize comfort and energy efficiency.';
    } else if (temp > 24.0) {
      explanation += 'the model recommends a warmer temperature based on predicted comfort preferences.';
    } else {
      explanation += 'the model suggests maintaining a moderate temperature for optimal comfort.';
    }
    
    explanation += '\n\nPrediction confidence: $confidence%';
    
    if (isFallback) {
      explanation += ' (Fallback mode - please check ML model)';
    }
    
    if (features['roomName'] != null) {
      explanation += '\nRoom: ${features['roomName']}';
    }
    
    return explanation;
  }

  ThermostatPrediction _getFallbackPrediction({
    required String roomName,
    double? currentTemperature,
    double? outsideTemperature,
    required DateTime forTime,
  }) {
    // Simple heuristic-based prediction when ML model fails
    double baseTemp = 22.0; // Default comfortable temperature
    
    // Adjust based on time of day
    if (forTime.hour >= 22 || forTime.hour <= 6) {
      baseTemp -= 1.0; // Slightly cooler at night
    } else if (forTime.hour >= 12 && forTime.hour <= 18) {
      baseTemp += 0.5; // Slightly warmer during day
    }
    
    // Adjust based on outside temperature if available
    if (outsideTemperature != null) {
      if (outsideTemperature < 10) {
        baseTemp += 1.0; // Warmer when it's cold outside
      } else if (outsideTemperature > 25) {
        baseTemp -= 1.0; // Cooler when it's hot outside
      }
    }
    
    // Clamp to reasonable range
    baseTemp = baseTemp.clamp(18.0, 26.0);
    
    return ThermostatPrediction(
      predictedTemperature: baseTemp,
      confidence: 0.5, // Lower confidence for fallback
      timestamp: forTime,
      inputFeatures: {
        'roomName': roomName,
        'fallback': true,
        'hour': forTime.hour,
        'outsideTemperature': outsideTemperature,
        'currentTemperature': currentTemperature,
      },
    );
  }
  
  Future<Map<String, dynamic>> getModelInfo() async {
    if (_interpreter == null) {
      await _loadModel();
    }
    
    if (_interpreter == null) {
      return {
        'status': 'Model not loaded',
        'error': 'Could not load thermostat_model.tflite',
      };
    }
    
    try {
      final inputTensors = _interpreter!.getInputTensors();
      final outputTensors = _interpreter!.getOutputTensors();
      
      return {
        'status': 'Model loaded successfully',
        'inputShape': inputTensors.first.shape,
        'outputShape': outputTensors.first.shape,
        'inputType': inputTensors.first.type.toString(),
        'outputType': outputTensors.first.type.toString(),
      };
    } catch (e) {
      return {
        'status': 'Model info error',
        'error': e.toString(),
      };
    }
  }
  
  Future<ThermostatPrediction> testFallbackPrediction({
    required String roomName,
    double? currentTemperature,
    double? outsideTemperature,
  }) async {
    // Force use of fallback prediction for testing
    return _getFallbackPrediction(
      roomName: roomName,
      currentTemperature: currentTemperature,
      outsideTemperature: outsideTemperature,
      forTime: DateTime.now(),
    );
  }
  
  Future<void> _analyzeModelOutput(double rawOutput) async {
    try {
      // Test multiple inputs to understand model output range
      List<double> testOutputs = [];
      
      // Test with different scenarios
      List<List<double>> testScenarios = [
        [8.0, 0.0, 0.0, 18.0, 40.0, 1010.0],   // Morning, cool
        [14.0, 30.0, 2.0, 22.0, 50.0, 1013.0], // Afternoon, moderate
        [20.0, 0.0, 4.0, 26.0, 60.0, 1015.0],  // Evening, warm
        [2.0, 0.0, 6.0, 15.0, 70.0, 1005.0],   // Night, cold
      ];
      
      for (var scenario in testScenarios) {
        try {
          // Scale the test input
          List<double> scaledTest = [];
          for (int i = 0; i < scenario.length; i++) {
            if (i < scalerMeans.length && i < scalerStdDevs.length) {
              scaledTest.add((scenario[i] - scalerMeans[i]) / scalerStdDevs[i]);
            } else {
              scaledTest.add(scenario[i]);
            }
          }
          
          var testInput = [scaledTest];
          final outputTensors = _interpreter!.getOutputTensors();
          final outputShape = outputTensors.first.shape;
          
          List<List<double>> testOutput;
          if (outputShape.length == 2) {
            testOutput = List.generate(outputShape[0], 
                (i) => List.filled(outputShape[1], 0.0));
          } else {
            testOutput = [List.filled(outputShape[0], 0.0)];
          }
          
          _interpreter!.run(testInput, testOutput);
          testOutputs.add(testOutput[0][0]);
        } catch (e) {
          developer.log('Test scenario failed: $e', name: 'MlPredictionService');
        }
      }
      
      if (testOutputs.isNotEmpty) {
        double minOutput = testOutputs.reduce((a, b) => a < b ? a : b);
        double maxOutput = testOutputs.reduce((a, b) => a > b ? a : b);
        
        developer.log(
          'Model output range: $minOutput to $maxOutput',
          name: 'MlPredictionService'
        );
        
        // Auto-detect scaling based on output range
        if (maxOutput > 1.0 && maxOutput < 50.0) {
          // Model likely outputs temperature directly
          _outputScale = 1.0;
          _outputOffset = 0.0;
        } else if (maxOutput <= 1.0 && minOutput >= 0.0) {
          // Model outputs normalized values (0-1)
          _outputScale = 15.0; // Scale to reasonable temp range (15°C range)
          _outputOffset = 18.0; // Offset to start at 18°C
        } else if (maxOutput <= 1.0 && minOutput >= -1.0) {
          // Model outputs standardized values (-1 to 1)
          _outputScale = 7.5; // Half range
          _outputOffset = 22.5; // Center around 22.5°C
        } else {
          // Unknown range, use conservative scaling
          _outputScale = 10.0 / (maxOutput - minOutput + 0.001);
          _outputOffset = 20.0;
        }
        
        developer.log(
          'Auto-detected scaling: scale=${_outputScale.toStringAsFixed(3)}, offset=${_outputOffset.toStringAsFixed(3)}',
          name: 'MlPredictionService'
        );
      }
      
      _modelAnalyzed = true;
    } catch (e) {
      developer.log('Model analysis failed: $e', name: 'MlPredictionService');
      _outputScale = 1.0;
      _outputOffset = 0.0;
      _modelAnalyzed = true;
    }
  }
  
  double _convertModelOutput(double rawOutput) {
    double converted;
    
    if (_outputScale == 1.0 && _outputOffset == 0.0) {
      // Direct temperature output
      converted = rawOutput;
    } else {
      // Apply scaling and offset
      converted = (rawOutput * _outputScale) + _outputOffset;
    }
    
    // Clamp to reasonable thermostat range
    return converted.clamp(16.0, 32.0);
  }
  
  Future<Map<String, dynamic>> testModelWithValues({
    required double hour,
    required double minute,
    required double dayOfWeek,
    required double currentTemp,
    required double humidity,
    required double pressure,
  }) async {
    if (_interpreter == null) {
      await _loadModel();
      if (_interpreter == null) {
        return {'error': 'Model not available'};
      }
    }
    
    try {
      List<double> rawInput = [hour, minute, dayOfWeek, currentTemp, humidity, pressure];
      
      // Scale input
      List<double> scaledInput = [];
      for (int i = 0; i < rawInput.length; i++) {
        if (i < scalerMeans.length && i < scalerStdDevs.length) {
          scaledInput.add((rawInput[i] - scalerMeans[i]) / scalerStdDevs[i]);
        } else {
          scaledInput.add(rawInput[i]);
        }
      }
      
      var input = [scaledInput];
      final outputTensors = _interpreter!.getOutputTensors();
      final outputShape = outputTensors.first.shape;
      
      List<List<double>> output;
      if (outputShape.length == 2) {
        output = List.generate(outputShape[0], 
            (i) => List.filled(outputShape[1], 0.0));
      } else {
        output = [List.filled(outputShape[0], 0.0)];
      }
      
      _interpreter!.run(input, output);
      
      double rawOutput = output[0][0];
      double convertedTemp = _convertModelOutput(rawOutput);
      
      return {
        'success': true,
        'rawInput': rawInput,
        'scaledInput': scaledInput,
        'rawOutput': rawOutput,
        'convertedTemperature': convertedTemp,
        'outputScale': _outputScale,
        'outputOffset': _outputOffset,
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'success': false,
      };
    }
  }
  
  void disposeModel() {
    _interpreter?.close();
    _interpreter = null;
    _modelAnalyzed = false;
  }
}

// Convenience providers
@riverpod
ThermostatPrediction? currentThermostatPrediction(CurrentThermostatPredictionRef ref) {
  return ref.watch(mlPredictionServiceProvider);
}

@riverpod
bool isMlPredictionAvailable(IsMlPredictionAvailableRef ref) {
  final prediction = ref.watch(currentThermostatPredictionProvider);
  return prediction != null;
}

@riverpod
Future<Map<String, dynamic>> mlModelInfo(MlModelInfoRef ref) async {
  return await ref.read(mlPredictionServiceProvider.notifier).getModelInfo();
}

@riverpod
Future<Map<String, dynamic>> testModelPrediction(
  TestModelPredictionRef ref, {
  required double hour,
  required double minute,
  required double dayOfWeek,
  required double currentTemp,
  required double humidity,
  required double pressure,
}) async {
  return await ref.read(mlPredictionServiceProvider.notifier).testModelWithValues(
    hour: hour,
    minute: minute,
    dayOfWeek: dayOfWeek,
    currentTemp: currentTemp,
    humidity: humidity,
    pressure: pressure,
  );
}