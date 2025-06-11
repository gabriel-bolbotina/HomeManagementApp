import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'thermostat_service.g.dart';

enum ThermostatMode {
  heat,
  cool,
  auto,
  off,
}

enum ThermostatStatus {
  heating,
  cooling,
  idle,
}

class ThermostatSettings {
  final bool isOn;
  final double targetTemperature;
  final ThermostatMode mode;
  final bool autoMode;
  final DateTime lastUpdate;

  const ThermostatSettings({
    required this.isOn,
    required this.targetTemperature,
    required this.mode,
    required this.autoMode,
    required this.lastUpdate,
  });

  ThermostatSettings copyWith({
    bool? isOn,
    double? targetTemperature,
    ThermostatMode? mode,
    bool? autoMode,
    DateTime? lastUpdate,
  }) {
    return ThermostatSettings(
      isOn: isOn ?? this.isOn,
      targetTemperature: targetTemperature ?? this.targetTemperature,
      mode: mode ?? this.mode,
      autoMode: autoMode ?? this.autoMode,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isOn': isOn,
      'targetTemperature': targetTemperature,
      'mode': mode.name,
      'autoMode': autoMode,
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }

  factory ThermostatSettings.fromMap(Map<String, dynamic> map) {
    return ThermostatSettings(
      isOn: map['isOn'] ?? false,
      targetTemperature: (map['targetTemperature'] ?? 22.0).toDouble(),
      mode: ThermostatMode.values.firstWhere(
        (e) => e.name == map['mode'],
        orElse: () => ThermostatMode.auto,
      ),
      autoMode: map['autoMode'] ?? false,
      lastUpdate: DateTime.tryParse(map['lastUpdate'] ?? '') ?? DateTime.now(),
    );
  }
}

class ThermostatState {
  final ThermostatSettings settings;
  final ThermostatStatus status;
  final bool isConnected;
  final double? currentTemperature;
  final String? lastError;

  const ThermostatState({
    required this.settings,
    required this.status,
    required this.isConnected,
    this.currentTemperature,
    this.lastError,
  });

  ThermostatState copyWith({
    ThermostatSettings? settings,
    ThermostatStatus? status,
    bool? isConnected,
    double? currentTemperature,
    String? lastError,
  }) {
    return ThermostatState(
      settings: settings ?? this.settings,
      status: status ?? this.status,
      isConnected: isConnected ?? this.isConnected,
      currentTemperature: currentTemperature ?? this.currentTemperature,
      lastError: lastError ?? this.lastError,
    );
  }
}

@riverpod
class ThermostatService extends _$ThermostatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  ThermostatState build() {
    // Load initial settings
    _loadSettings();
    
    return ThermostatState(
      settings: ThermostatSettings(
        isOn: false,
        targetTemperature: 22.0,
        mode: ThermostatMode.auto,
        autoMode: false,
        lastUpdate: DateTime.now(),
      ),
      status: ThermostatStatus.idle,
      isConnected: true, // Simulated connection
    );
  }

  Future<void> _loadSettings() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('devices')
          .doc('thermostat')
          .get();

      if (doc.exists) {
        final settings = ThermostatSettings.fromMap(doc.data()!);
        state = state.copyWith(settings: settings);
        developer.log('Loaded thermostat settings: ${settings.toMap()}', name: 'ThermostatService');
      }
    } catch (e) {
      developer.log('Error loading thermostat settings', 
          name: 'ThermostatService', error: e, level: 1000);
    }
  }

  Future<void> _saveSettings() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('devices')
          .doc('thermostat')
          .set(state.settings.toMap());

      developer.log('Saved thermostat settings', name: 'ThermostatService');
    } catch (e) {
      developer.log('Error saving thermostat settings', 
          name: 'ThermostatService', error: e, level: 1000);
    }
  }

  Future<void> togglePower() async {
    final newSettings = state.settings.copyWith(
      isOn: !state.settings.isOn,
      lastUpdate: DateTime.now(),
    );
    
    state = state.copyWith(
      settings: newSettings,
      status: newSettings.isOn ? ThermostatStatus.idle : ThermostatStatus.idle,
    );
    
    await _saveSettings();
    developer.log('Toggled thermostat power: ${newSettings.isOn}', name: 'ThermostatService');
  }

  Future<void> setTargetTemperature(double temperature) async {
    if (temperature < 16.0 || temperature > 30.0) {
      developer.log('Invalid temperature: $temperature', name: 'ThermostatService', level: 1000);
      return;
    }

    final newSettings = state.settings.copyWith(
      targetTemperature: temperature,
      lastUpdate: DateTime.now(),
    );
    
    state = state.copyWith(settings: newSettings);
    await _saveSettings();
    await _adjustBasedOnSettings();
    
    developer.log('Set target temperature: $temperature°C', name: 'ThermostatService');
  }

  Future<void> setMode(ThermostatMode mode) async {
    final newSettings = state.settings.copyWith(
      mode: mode,
      lastUpdate: DateTime.now(),
      isOn: mode != ThermostatMode.off,
    );
    
    state = state.copyWith(settings: newSettings);
    await _saveSettings();
    await _adjustBasedOnSettings();
    
    developer.log('Set thermostat mode: ${mode.name}', name: 'ThermostatService');
  }

  Future<void> enableAutoMode(bool enabled) async {
    final newSettings = state.settings.copyWith(
      autoMode: enabled,
      lastUpdate: DateTime.now(),
    );
    
    state = state.copyWith(settings: newSettings);
    await _saveSettings();
    
    developer.log('Auto mode: $enabled', name: 'ThermostatService');
  }

  Future<void> _adjustBasedOnSettings() async {
    if (!state.settings.isOn) {
      state = state.copyWith(status: ThermostatStatus.idle);
      return;
    }

    // Simulate thermostat logic based on mode
    ThermostatStatus newStatus = ThermostatStatus.idle;
    
    switch (state.settings.mode) {
      case ThermostatMode.heat:
        newStatus = ThermostatStatus.heating;
        break;
      case ThermostatMode.cool:
        newStatus = ThermostatStatus.cooling;
        break;
      case ThermostatMode.auto:
        // In auto mode, determine heating/cooling based on current vs target
        final current = state.currentTemperature ?? 22.0;
        if (current < state.settings.targetTemperature - 1.0) {
          newStatus = ThermostatStatus.heating;
        } else if (current > state.settings.targetTemperature + 1.0) {
          newStatus = ThermostatStatus.cooling;
        } else {
          newStatus = ThermostatStatus.idle;
        }
        break;
      case ThermostatMode.off:
        newStatus = ThermostatStatus.idle;
        break;
    }
    
    state = state.copyWith(status: newStatus);
    developer.log('Thermostat status: ${newStatus.name}', name: 'ThermostatService');
  }

  Future<void> setCurrentTemperature(double temperature) async {
    state = state.copyWith(currentTemperature: temperature);
    await _adjustBasedOnSettings();
  }

  // Method for external services to trigger adjustments
  Future<void> performWeatherBasedAdjustment(double targetTemp, ThermostatMode mode) async {
    if (!state.settings.autoMode) {
      developer.log('Auto mode disabled, skipping weather-based adjustment', name: 'ThermostatService');
      return;
    }

    await setTargetTemperature(targetTemp);
    await setMode(mode);
    
    developer.log('Applied weather-based adjustment: ${targetTemp}°C, ${mode.name}', 
        name: 'ThermostatService');
  }
}

// Convenience providers
@riverpod
ThermostatSettings thermostatSettings(Ref ref) {
  return ref.watch(thermostatServiceProvider).settings;
}

@riverpod
ThermostatStatus thermostatStatus(Ref ref) {
  return ref.watch(thermostatServiceProvider).status;
}

@riverpod
bool isThermostatConnected(Ref ref) {
  return ref.watch(thermostatServiceProvider).isConnected;
}