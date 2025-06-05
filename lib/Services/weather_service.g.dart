// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentWeatherHash() => r'265182d1d543c17c8bec3a7431057f471321f0fc';

/// See also [currentWeather].
@ProviderFor(currentWeather)
final currentWeatherProvider = AutoDisposeProvider<WeatherData?>.internal(
  currentWeather,
  name: r'currentWeatherProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentWeatherHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentWeatherRef = AutoDisposeProviderRef<WeatherData?>;
String _$isWeatherLoadingHash() => r'f3cff5967b49a1a9e343864597fdf02412bcdb5b';

/// See also [isWeatherLoading].
@ProviderFor(isWeatherLoading)
final isWeatherLoadingProvider = AutoDisposeProvider<bool>.internal(
  isWeatherLoading,
  name: r'isWeatherLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isWeatherLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsWeatherLoadingRef = AutoDisposeProviderRef<bool>;
String _$weatherErrorHash() => r'33ac1a0200635a0c7d10d6f1c37985529ae51c08';

/// See also [weatherError].
@ProviderFor(weatherError)
final weatherErrorProvider = AutoDisposeProvider<String?>.internal(
  weatherError,
  name: r'weatherErrorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$weatherErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeatherErrorRef = AutoDisposeProviderRef<String?>;
String _$thermostatRecommendationHash() =>
    r'afd5a02f3194885a011e44f24a565551b8ae8da8';

/// See also [thermostatRecommendation].
@ProviderFor(thermostatRecommendation)
final thermostatRecommendationProvider =
    AutoDisposeProvider<ThermostatRecommendation?>.internal(
  thermostatRecommendation,
  name: r'thermostatRecommendationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$thermostatRecommendationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ThermostatRecommendationRef
    = AutoDisposeProviderRef<ThermostatRecommendation?>;
String _$weatherServiceHash() => r'31862d343e40a6f965d6fd1d966ed82d015c24ae';

/// See also [WeatherService].
@ProviderFor(WeatherService)
final weatherServiceProvider = AutoDisposeNotifierProvider<WeatherService,
    AsyncValue<WeatherData?>>.internal(
  WeatherService.new,
  name: r'weatherServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weatherServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WeatherService = AutoDisposeNotifier<AsyncValue<WeatherData?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
