import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../flutter_flow/HomeAppTheme.dart';
import '../flutter_flow/homeAppWidgets.dart';

class DoorPredictionWidget extends StatefulWidget {
  const DoorPredictionWidget({Key? key}) : super(key: key);

  @override
  _DoorPredictionWidgetState createState() => _DoorPredictionWidgetState();
}

class _DoorPredictionWidgetState extends State<DoorPredictionWidget> {
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();

  String _predictionResult = '';
  bool _isLoading = false;
  bool _isLocked = false; // Track door state for UI

  // Replace these with your actual scaler values from Python
  final List<double> scalerMeans = [12.0, 30.0, 3.0]; // Example values
  final List<double> scalerStdDevs = [6.9, 17.3, 2.0]; // Example values

  @override
  void initState() {
    super.initState();
    // Set current time as default
    DateTime now = DateTime.now();
    _hourController.text = now.hour.toString();
    _minuteController.text = now.minute.toString();
    _dayController.text = (now.weekday - 1).toString(); // 0-6 format
  }

  Future<double?> predictDoorAction(int hour, int minute, int dayOfWeek) async {
    try {
      final Interpreter interpreter =
          await Interpreter.fromAsset('assets/models/door_lock_model.tflite');

      // Prepare input data (Hour, Minute, DayOfWeek)
      List<double> rawInput = [
        hour.toDouble(),
        minute.toDouble(),
        dayOfWeek.toDouble()
      ];

      // Manually scale the input data using the pre-calculated means and std_devs
      List<double> scaledInput = [];
      for (int i = 0; i < rawInput.length; i++) {
        scaledInput.add((rawInput[i] - scalerMeans[i]) / scalerStdDevs[i]);
      }

      // TFLite models expect inputs as a 2D array (batch_size, num_features)
      var input = [scaledInput];
      var output = List.filled(1 * 1, 0.0).reshape([1, 1]); // For binary output

      interpreter.run(input, output);
      interpreter.close(); // Close the interpreter when done

      double probability = output[0][0];
      return probability;
    } catch (e) {
      print('Error during TFLite prediction: $e');
      return null;
    }
  }

  void _makePrediction() async {
    // Validate inputs
    if (_hourController.text.isEmpty ||
        _minuteController.text.isEmpty ||
        _dayController.text.isEmpty) {
      setState(() {
        _predictionResult = 'Please fill in all fields';
      });
      return;
    }

    try {
      int hour = int.parse(_hourController.text);
      int minute = int.parse(_minuteController.text);
      int dayOfWeek = int.parse(_dayController.text);

      // Validate ranges
      if (hour < 0 || hour > 23) {
        setState(() {
          _predictionResult = 'Hour must be between 0-23';
        });
        return;
      }
      if (minute < 0 || minute > 59) {
        setState(() {
          _predictionResult = 'Minute must be between 0-59';
        });
        return;
      }
      if (dayOfWeek < 0 || dayOfWeek > 6) {
        setState(() {
          _predictionResult = 'Day of week must be between 0-6 (0=Monday)';
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _predictionResult = '';
      });

      double? probability = await predictDoorAction(hour, minute, dayOfWeek);

      setState(() {
        _isLoading = false;
        if (probability != null) {
          _isLocked = probability > 0.5;
          String action = _isLocked ? 'Lock' : 'Unlock';
          String dayName = _getDayName(dayOfWeek);
          _predictionResult =
              'Prediction for $dayName at ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}\n'
              'Action: $action\n'
              'Probability: ${(probability * 100).toStringAsFixed(1)}%';
        } else {
          _predictionResult =
              'Failed to make prediction. Check if model file exists.';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _predictionResult = 'Invalid input. Please enter valid numbers.';
      });
    }
  }

  String _getDayName(int dayOfWeek) {
    List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[dayOfWeek];
  }

  void _useCurrentTime() {
    DateTime now = DateTime.now();
    setState(() {
      _hourController.text = now.hour.toString();
      _minuteController.text = now.minute.toString();
      _dayController.text = (now.weekday - 1).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Door Status Indicator (similar to your profile image style)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isLocked ? Colors.red[100] : Colors.green[100],
                border: Border.all(
                  color: _isLocked ? Colors.red : Colors.green,
                  width: 3,
                ),
              ),
              child: Icon(
                _isLocked ? Icons.lock : Icons.lock_open,
                size: 60,
                color: _isLocked ? Colors.red[700] : Colors.green[700],
              ),
            ),
          ),

          // Status Text
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
            child: Text(
              _isLocked ? 'Door Locked' : 'Door Unlocked',
              style: HomeAppTheme.of(context).subtitle1.override(
                    fontFamily: 'Lexend Deca',
                    color: _isLocked ? Colors.red[700] : Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),

          // Input Fields (following your TextFormField style)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
            child: TextFormField(
              controller: _hourController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Hour (0-23)',
                labelStyle: HomeAppTheme.of(context).bodyText2,
                hintText: 'Enter hour',
                hintStyle: HomeAppTheme.of(context).bodyText2,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: HomeAppTheme.of(context).primaryBackground,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: HomeAppTheme.of(context).primaryBackground,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: HomeAppTheme.of(context).secondaryBackground,
                contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                prefixIcon: const Icon(Icons.access_time),
              ),
              style: HomeAppTheme.of(context).bodyText1,
            ),
          ),

          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
            child: TextFormField(
              controller: _minuteController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Minute (0-59)',
                labelStyle: HomeAppTheme.of(context).bodyText2,
                hintText: 'Enter minute',
                hintStyle: HomeAppTheme.of(context).bodyText2,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: HomeAppTheme.of(context).primaryBackground,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: HomeAppTheme.of(context).primaryBackground,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: HomeAppTheme.of(context).secondaryBackground,
                contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                prefixIcon: const Icon(Icons.schedule),
              ),
              style: HomeAppTheme.of(context).bodyText1,
            ),
          ),

          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
            child: TextFormField(
              controller: _dayController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Day of Week (0=Mon, 6=Sun)',
                labelStyle: HomeAppTheme.of(context).bodyText2,
                hintText: 'Enter day (0-6)',
                hintStyle: HomeAppTheme.of(context).bodyText2,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: HomeAppTheme.of(context).primaryBackground,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: HomeAppTheme.of(context).primaryBackground,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: HomeAppTheme.of(context).secondaryBackground,
                contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                prefixIcon: const Icon(Icons.calendar_today),
              ),
              style: HomeAppTheme.of(context).bodyText1,
            ),
          ),

          // Buttons (following your HomeAppButtonWidget style)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
            child: HomeAppButtonWidget(
              onPressed: _useCurrentTime,
              text: 'Use Current Time',
              options: HomeAppButtonOptions(
                width: double.infinity,
                height: 40,
                color: HomeAppTheme.of(context).secondaryBackground,
                textStyle: HomeAppTheme.of(context).bodyText1,
                elevation: 1,
                borderSide: BorderSide(
                  color: HomeAppTheme.of(context).primaryBackground,
                  width: 1,
                ),
                borderRadius: 20,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
            child: HomeAppButtonWidget(
              onPressed: _isLoading ? () {} : _makePrediction,
              text: _isLoading ? 'Predicting...' : 'Predict Door Action',
              options: HomeAppButtonOptions(
                width: double.infinity,
                height: 40,
                color: HomeAppTheme.of(context).primaryBtnText,
                textStyle: HomeAppTheme.of(context).bodyText1,
                elevation: 1,
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
                borderRadius: 20,
              ),
            ),
          ),

          // Prediction Result
          if (_predictionResult.isNotEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: HomeAppTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: HomeAppTheme.of(context).primaryBackground,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prediction Result',
                        style: HomeAppTheme.of(context).subtitle2.override(
                              fontFamily: 'Lexend Deca',
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _predictionResult,
                        style: HomeAppTheme.of(context).bodyText1,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Loading indicator
          if (_isLoading)
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _dayController.dispose();
    super.dispose();
  }
}
