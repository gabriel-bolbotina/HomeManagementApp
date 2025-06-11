import 'dart:developer' as developer;
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/weather_service.dart';
import '../services/thermostat_service.dart';

part 'climate_control_provider.g.dart';

enum ClimateControlMode {
  manual,
  weatherBased,
  scheduled,
  energySaver,
}

class ClimateControlState {
  final ClimateControlMode mode;
  final bool isActive;
  final String? status;
  final DateTime lastUpdate;
  final Map<String, dynamic> recommendations;

  const ClimateControlState({
    required this.mode,
    required this.isActive,
    this.status,
    required this.lastUpdate,
    this.recommendations = const {},
  });

  ClimateControlState copyWith({
    ClimateControlMode? mode,
    bool? isActive,
    String? status,
    DateTime? lastUpdate,
    Map<String, dynamic>? recommendations,
  }) {
    return ClimateControlState(
      mode: mode ?? this.mode,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      recommendations: recommendations ?? this.recommendations,
    );
  }
}

@riverpod
class ClimateControlNotifier extends _$ClimateControlNotifier {
  Timer? _monitoringTimer;

  @override
  ClimateControlState build() {
    ref.onDispose(() {
      _monitoringTimer?.cancel();
    });

    return ClimateControlState(
      mode: ClimateControlMode.weatherBased,
      isActive: false,
      lastUpdate: DateTime.now(),
    );
  }

  Future<void> enableWeatherBasedControl() async {
    developer.log('Enabling weather-based climate control', name: 'ClimateControl');
    
    state = state.copyWith(
      mode: ClimateControlMode.weatherBased,
      isActive: true,
      status: 'Starting weather-based control...',
      lastUpdate: DateTime.now(),
    );

    // Start monitoring
    _startWeatherMonitoring();
    
    // Initial adjustment
    await _performWeatherBasedAdjustment();
  }

  Future<void> disableWeatherBasedControl() async {
    developer.log('Disabling weather-based climate control', name: 'ClimateControl');
    
    _monitoringTimer?.cancel();
    
    state = state.copyWith(
      mode: ClimateControlMode.manual,
      isActive: false,
      status: 'Weather-based control disabled',
      lastUpdate: DateTime.now(),
    );
  }

  void _startWeatherMonitoring() {
    _monitoringTimer?.cancel();
    
    // Check weather every 30 minutes
    _monitoringTimer = Timer.periodic(const Duration(minutes: 30), (timer) {
      if (state.isActive && state.mode == ClimateControlMode.weatherBased) {
        _performWeatherBasedAdjustment();
      }
    });
    
    developer.log('Started weather monitoring (30-minute intervals)', name: 'ClimateControl');
  }

  Future<void> _performWeatherBasedAdjustment() async {
    try {
      developer.log('Performing weather-based adjustment', name: 'ClimateControl');
      
      // Get current weather
      await ref.read(weatherServiceProvider.notifier).getCurrentWeather();
      final weather = ref.read(currentWeatherProvider);
      
      if (weather == null) {
        state = state.copyWith(
          status: 'Unable to get weather data',
          lastUpdate: DateTime.now(),
        );
        return;
      }

      final thermostatService = ref.read(thermostatServiceProvider.notifier);
      final currentSettings = ref.read(thermostatSettingsProvider);

      // Generate recommendations
      final recommendations = _generateRecommendations(weather, currentSettings);
      
      state = state.copyWith(
        status: 'Weather: ${weather.description}, ${weather.temperature.toStringAsFixed(1)}°C',
        lastUpdate: DateTime.now(),
        recommendations: recommendations,
      );

      // Apply automatic adjustments if enabled
      if (currentSettings.autoMode) {
        await _applyRecommendations(recommendations, thermostatService);
      }

    } catch (e) {
      developer.log('Error in weather-based adjustment', 
          name: 'ClimateControl', error: e, level: 1000);
      
      state = state.copyWith(
        status: 'Error adjusting climate: ${e.toString()}',
        lastUpdate: DateTime.now(),
      );
    }
  }

  Map<String, dynamic> _generateRecommendations(WeatherData weather, ThermostatSettings settings) {
    final recommendations = <String, dynamic>{};
    
    // Temperature recommendations
    if (weather.isHot) {
      recommendations['action'] = 'cool';
      recommendations['targetTemp'] = 22.0;
      recommendations['reason'] = 'Outside temperature is ${weather.temperature.toStringAsFixed(1)}°C - cooling recommended';
      recommendations['mode'] = ThermostatMode.cool;
    } else if (weather.isCold) {
      recommendations['action'] = 'heat';
      recommendations['targetTemp'] = 24.0;
      recommendations['reason'] = 'Outside temperature is ${weather.temperature.toStringAsFixed(1)}°C - heating recommended';
      recommendations['mode'] = ThermostatMode.heat;
    } else {
      recommendations['action'] = 'maintain';
      recommendations['targetTemp'] = 23.0;
      recommendations['reason'] = 'Outside temperature is comfortable (${weather.temperature.toStringAsFixed(1)}°C)';
      recommendations['mode'] = ThermostatMode.auto;
    }

    // Humidity considerations
    if (weather.humidity > 70) {
      recommendations['humidity'] = 'high';
      recommendations['humidityAdvice'] = 'High humidity (${weather.humidity.toStringAsFixed(0)}%) - consider dehumidifying';
    } else if (weather.humidity < 30) {
      recommendations['humidity'] = 'low';
      recommendations['humidityAdvice'] = 'Low humidity (${weather.humidity.toStringAsFixed(0)}%) - consider humidifying';
    }

    // Energy efficiency tips
    if (weather.feelsLike != weather.temperature) {
      final diff = weather.feelsLike - weather.temperature;
      if (diff.abs() > 3) {
        recommendations['feelsLike'] = weather.feelsLike;
        recommendations['efficiency'] = 'Feels like ${weather.feelsLike.toStringAsFixed(1)}°C due to humidity/wind';
      }
    }

    // Time-based recommendations
    final hour = DateTime.now().hour;
    if (hour >= 22 || hour <= 6) {
      recommendations['timeAdvice'] = 'Night time - consider lowering temperature by 2-3°C for better sleep';
      recommendations['nightMode'] = true;
    }

    return recommendations;
  }

  Future<void> _applyRecommendations(Map<String, dynamic> recommendations, ThermostatService thermostatService) async {
    try {
      final targetTemp = recommendations['targetTemp'] as double?;
      final mode = recommendations['mode'] as ThermostatMode?;
      final isNightMode = recommendations['nightMode'] as bool? ?? false;

      if (targetTemp != null) {
        // Adjust for night mode
        final adjustedTemp = isNightMode ? targetTemp - 2.0 : targetTemp;
        await thermostatService.setTargetTemperature(adjustedTemp);
        
        developer.log('Auto-adjusted target temperature to ${adjustedTemp.toStringAsFixed(1)}°C', 
            name: 'ClimateControl');
      }

      if (mode != null) {
        await thermostatService.setMode(mode);
        
        developer.log('Auto-adjusted thermostat mode to ${mode.name}', 
            name: 'ClimateControl');
      }

      // Ensure thermostat is on
      final currentSettings = ref.read(thermostatSettingsProvider);
      if (!currentSettings.isOn) {
        await thermostatService.togglePower();
        developer.log('Auto-turned on thermostat', name: 'ClimateControl');
      }

    } catch (e) {
      developer.log('Error applying recommendations', 
          name: 'ClimateControl', error: e, level: 1000);
    }
  }

  Future<void> manualRefresh() async {
    developer.log('Manual climate control refresh requested', name: 'ClimateControl');
    
    if (state.mode == ClimateControlMode.weatherBased) {
      await _performWeatherBasedAdjustment();
    }
  }

  Future<void> setMode(ClimateControlMode mode) async {
    developer.log('Setting climate control mode to ${mode.name}', name: 'ClimateControl');
    
    state = state.copyWith(
      mode: mode,
      lastUpdate: DateTime.now(),
    );

    switch (mode) {
      case ClimateControlMode.weatherBased:
        await enableWeatherBasedControl();
        break;
      case ClimateControlMode.manual:
        await disableWeatherBasedControl();
        break;
      case ClimateControlMode.energySaver:
        await _enableEnergySaverMode();
        break;
      case ClimateControlMode.scheduled:
        // TODO: Implement scheduled mode
        break;
    }
  }

  Future<void> _enableEnergySaverMode() async {
    developer.log('Enabling energy saver mode', name: 'ClimateControl');
    
    final thermostatService = ref.read(thermostatServiceProvider.notifier);
    
    // Set conservative temperatures
    await thermostatService.setTargetTemperature(20.0); // Lower target for energy saving
    await thermostatService.setMode(ThermostatMode.auto);
    
    state = state.copyWith(
      isActive: true,
      status: 'Energy saver mode active - target 20°C',
      lastUpdate: DateTime.now(),
    );
  }
}

// Convenience providers
@riverpod
bool isClimateControlActive(Ref ref) {
  return ref.watch(climateControlNotifierProvider).isActive;
}

@riverpod
String? climateControlStatus(Ref ref) {
  return ref.watch(climateControlNotifierProvider).status;
}

@riverpod
Map<String, dynamic> climateRecommendations(Ref ref) {
  return ref.watch(climateControlNotifierProvider).recommendations;
}