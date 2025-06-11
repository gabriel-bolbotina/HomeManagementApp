import 'dart:developer' as developer;
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'weather_service.g.dart';

class WeatherData {
  final String cityName;
  final double temperature;
  final double humidity;
  final String description;
  final String iconCode;
  final double feelsLike;
  final double windSpeed;
  final int pressure;
  final DateTime timestamp;
  final double latitude;
  final double longitude;

  const WeatherData({
    required this.cityName,
    required this.temperature,
    required this.humidity,
    required this.description,
    required this.iconCode,
    required this.feelsLike,
    required this.windSpeed,
    required this.pressure,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
  });

  factory WeatherData.fromWeather(Weather weather) {
    return WeatherData(
      cityName: weather.areaName ?? 'Unknown',
      temperature: weather.temperature?.celsius ?? 0.0,
      humidity: weather.humidity ?? 0.0,
      description: weather.weatherDescription ?? 'No description',
      iconCode: weather.weatherIcon ?? '01d',
      feelsLike: weather.tempFeelsLike?.celsius ?? 0.0,
      windSpeed: weather.windSpeed ?? 0.0,
      pressure: weather.pressure?.toInt() ?? 0,
      timestamp: weather.date ?? DateTime.now(),
      latitude: weather.latitude ?? 0.0,
      longitude: weather.longitude ?? 0.0,
    );
  }

  // Helper methods for thermostat logic
  bool get isHot => temperature > 26.0; // Above 26°C is hot
  bool get isCold => temperature < 18.0; // Below 18°C is cold
  bool get isComfortable => temperature >= 18.0 && temperature <= 26.0;

  ThermostatRecommendation get thermostatRecommendation {
    if (isHot) {
      return ThermostatRecommendation.cool;
    } else if (isCold) {
      return ThermostatRecommendation.heat;
    } else {
      return ThermostatRecommendation.maintain;
    }
  }

  @override
  String toString() {
    return 'WeatherData(city: $cityName, temp: ${temperature.toStringAsFixed(1)}°C, feels: ${feelsLike.toStringAsFixed(1)}°C, humidity: ${humidity.toStringAsFixed(0)}%)';
  }
}

enum ThermostatRecommendation {
  cool,
  heat,
  maintain,
}

class WeatherException implements Exception {
  final String message;
  final String? code;

  const WeatherException(this.message, [this.code]);

  @override
  String toString() =>
      'WeatherException: $message${code != null ? ' (Code: $code)' : ''}';
}

@riverpod
class WeatherService extends _$WeatherService {
  static const String _apiKey =
      '9fdeee871ea196b8ceaa97f4b44cd6dc'; // You'll need to get this from OpenWeatherMap
  late WeatherFactory _weatherFactory;

  @override
  AsyncValue<WeatherData?> build() {
    _weatherFactory = WeatherFactory(_apiKey);
    return const AsyncValue.data(null);
  }

  Future<void> getCurrentWeather() async {
    state = const AsyncValue.loading();

    try {
      developer.log('Getting current weather', name: 'WeatherService');

      // Get current location
      final position = await _getCurrentLocation();
      developer.log('Location: ${position.latitude}, ${position.longitude}',
          name: 'WeatherService');

      // Get weather data
      final weather = await _weatherFactory.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      final weatherData = WeatherData.fromWeather(weather);
      developer.log('Weather data: $weatherData', name: 'WeatherService');

      state = AsyncValue.data(weatherData);
    } catch (e, stackTrace) {
      developer.log('Error getting weather',
          name: 'WeatherService',
          error: e,
          stackTrace: stackTrace,
          level: 1000);

      if (e is LocationServiceDisabledException) {
        state = AsyncValue.error(
          const WeatherException(
              'Location services are disabled', 'LOCATION_DISABLED'),
          stackTrace,
        );
      } else if (e is PermissionDeniedException) {
        state = AsyncValue.error(
          const WeatherException(
              'Location permission denied', 'PERMISSION_DENIED'),
          stackTrace,
        );
      } else {
        state = AsyncValue.error(
          WeatherException('Failed to get weather: ${e.toString()}'),
          stackTrace,
        );
      }
    }
  }

  Future<WeatherData> getWeatherByCity(String cityName) async {
    try {
      developer.log('Getting weather for city: $cityName',
          name: 'WeatherService');

      final weather = await _weatherFactory.currentWeatherByCityName(cityName);
      final weatherData = WeatherData.fromWeather(weather);

      developer.log('Weather data for $cityName: $weatherData',
          name: 'WeatherService');
      return weatherData;
    } catch (e) {
      developer.log('Error getting weather for city $cityName',
          name: 'WeatherService', error: e, level: 1000);
      throw WeatherException(
          'Failed to get weather for $cityName: ${e.toString()}');
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceDisabledException();
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw PermissionDeniedException('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw PermissionDeniedException('Location permission permanently denied');
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
      timeLimit: const Duration(seconds: 10),
    );
  }

  void refreshWeather() {
    getCurrentWeather();
  }
}

// Convenience providers
@riverpod
WeatherData? currentWeather(Ref ref) {
  final weatherState = ref.watch(weatherServiceProvider);
  return weatherState.asData?.value;
}

@riverpod
bool isWeatherLoading(Ref ref) {
  final weatherState = ref.watch(weatherServiceProvider);
  return weatherState.isLoading;
}

@riverpod
String? weatherError(Ref ref) {
  final weatherState = ref.watch(weatherServiceProvider);
  return weatherState.hasError ? weatherState.error.toString() : null;
}

@riverpod
ThermostatRecommendation? thermostatRecommendation(Ref ref) {
  final weather = ref.watch(currentWeatherProvider);
  return weather?.thermostatRecommendation;
}
