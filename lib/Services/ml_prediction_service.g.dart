// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ml_prediction_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentThermostatPredictionHash() =>
    r'ef2e0978a1f415eaad198bad83552555e2ad666a';

/// See also [currentThermostatPrediction].
@ProviderFor(currentThermostatPrediction)
final currentThermostatPredictionProvider =
    AutoDisposeProvider<ThermostatPrediction?>.internal(
  currentThermostatPrediction,
  name: r'currentThermostatPredictionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentThermostatPredictionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentThermostatPredictionRef
    = AutoDisposeProviderRef<ThermostatPrediction?>;
String _$isMlPredictionAvailableHash() =>
    r'f2e94d3bdc7f16518c1501e9ce6f19c583d57c19';

/// See also [isMlPredictionAvailable].
@ProviderFor(isMlPredictionAvailable)
final isMlPredictionAvailableProvider = AutoDisposeProvider<bool>.internal(
  isMlPredictionAvailable,
  name: r'isMlPredictionAvailableProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isMlPredictionAvailableHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsMlPredictionAvailableRef = AutoDisposeProviderRef<bool>;
String _$mlModelInfoHash() => r'2e509b8c6f3c234e2fc0054fe564c183332cba3c';

/// See also [mlModelInfo].
@ProviderFor(mlModelInfo)
final mlModelInfoProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
  mlModelInfo,
  name: r'mlModelInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mlModelInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MlModelInfoRef = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$testModelPredictionHash() =>
    r'3d952844628fa0444be3252b3bd9976ee4773743';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [testModelPrediction].
@ProviderFor(testModelPrediction)
const testModelPredictionProvider = TestModelPredictionFamily();

/// See also [testModelPrediction].
class TestModelPredictionFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [testModelPrediction].
  const TestModelPredictionFamily();

  /// See also [testModelPrediction].
  TestModelPredictionProvider call({
    required double hour,
    required double minute,
    required double dayOfWeek,
    required double currentTemp,
    required double humidity,
    required double pressure,
  }) {
    return TestModelPredictionProvider(
      hour: hour,
      minute: minute,
      dayOfWeek: dayOfWeek,
      currentTemp: currentTemp,
      humidity: humidity,
      pressure: pressure,
    );
  }

  @override
  TestModelPredictionProvider getProviderOverride(
    covariant TestModelPredictionProvider provider,
  ) {
    return call(
      hour: provider.hour,
      minute: provider.minute,
      dayOfWeek: provider.dayOfWeek,
      currentTemp: provider.currentTemp,
      humidity: provider.humidity,
      pressure: provider.pressure,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'testModelPredictionProvider';
}

/// See also [testModelPrediction].
class TestModelPredictionProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [testModelPrediction].
  TestModelPredictionProvider({
    required double hour,
    required double minute,
    required double dayOfWeek,
    required double currentTemp,
    required double humidity,
    required double pressure,
  }) : this._internal(
          (ref) => testModelPrediction(
            ref as TestModelPredictionRef,
            hour: hour,
            minute: minute,
            dayOfWeek: dayOfWeek,
            currentTemp: currentTemp,
            humidity: humidity,
            pressure: pressure,
          ),
          from: testModelPredictionProvider,
          name: r'testModelPredictionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$testModelPredictionHash,
          dependencies: TestModelPredictionFamily._dependencies,
          allTransitiveDependencies:
              TestModelPredictionFamily._allTransitiveDependencies,
          hour: hour,
          minute: minute,
          dayOfWeek: dayOfWeek,
          currentTemp: currentTemp,
          humidity: humidity,
          pressure: pressure,
        );

  TestModelPredictionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.hour,
    required this.minute,
    required this.dayOfWeek,
    required this.currentTemp,
    required this.humidity,
    required this.pressure,
  }) : super.internal();

  final double hour;
  final double minute;
  final double dayOfWeek;
  final double currentTemp;
  final double humidity;
  final double pressure;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(TestModelPredictionRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TestModelPredictionProvider._internal(
        (ref) => create(ref as TestModelPredictionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        hour: hour,
        minute: minute,
        dayOfWeek: dayOfWeek,
        currentTemp: currentTemp,
        humidity: humidity,
        pressure: pressure,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _TestModelPredictionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TestModelPredictionProvider &&
        other.hour == hour &&
        other.minute == minute &&
        other.dayOfWeek == dayOfWeek &&
        other.currentTemp == currentTemp &&
        other.humidity == humidity &&
        other.pressure == pressure;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, hour.hashCode);
    hash = _SystemHash.combine(hash, minute.hashCode);
    hash = _SystemHash.combine(hash, dayOfWeek.hashCode);
    hash = _SystemHash.combine(hash, currentTemp.hashCode);
    hash = _SystemHash.combine(hash, humidity.hashCode);
    hash = _SystemHash.combine(hash, pressure.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TestModelPredictionRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `hour` of this provider.
  double get hour;

  /// The parameter `minute` of this provider.
  double get minute;

  /// The parameter `dayOfWeek` of this provider.
  double get dayOfWeek;

  /// The parameter `currentTemp` of this provider.
  double get currentTemp;

  /// The parameter `humidity` of this provider.
  double get humidity;

  /// The parameter `pressure` of this provider.
  double get pressure;
}

class _TestModelPredictionProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with TestModelPredictionRef {
  _TestModelPredictionProviderElement(super.provider);

  @override
  double get hour => (origin as TestModelPredictionProvider).hour;
  @override
  double get minute => (origin as TestModelPredictionProvider).minute;
  @override
  double get dayOfWeek => (origin as TestModelPredictionProvider).dayOfWeek;
  @override
  double get currentTemp => (origin as TestModelPredictionProvider).currentTemp;
  @override
  double get humidity => (origin as TestModelPredictionProvider).humidity;
  @override
  double get pressure => (origin as TestModelPredictionProvider).pressure;
}

String _$mlPredictionServiceHash() =>
    r'0824f38b55585da9b3fd36f2abfeca2233dfb446';

/// See also [MlPredictionService].
@ProviderFor(MlPredictionService)
final mlPredictionServiceProvider = AutoDisposeNotifierProvider<
    MlPredictionService, ThermostatPrediction?>.internal(
  MlPredictionService.new,
  name: r'mlPredictionServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mlPredictionServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MlPredictionService = AutoDisposeNotifier<ThermostatPrediction?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
