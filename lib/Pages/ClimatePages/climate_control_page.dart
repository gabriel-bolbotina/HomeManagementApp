import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Services/weather_service.dart';
import '../../Services/thermostat_service.dart';
import '../../Services/ml_prediction_service.dart';
import '../../providers/climate_control_provider.dart';
import '../flutter_flow/HomeAppTheme.dart';

class ClimateControlPage extends ConsumerStatefulWidget {
  const ClimateControlPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ClimateControlPage> createState() => _ClimateControlPageState();
}

class _ClimateControlPageState extends ConsumerState<ClimateControlPage>
    with TickerProviderStateMixin {
  late AnimationController _tempAnimationController;
  late Animation<double> _tempAnimation;

  @override
  void initState() {
    super.initState();
    _tempAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _tempAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _tempAnimationController, curve: Curves.easeInOut),
    );
    _tempAnimationController.forward();

    // Load initial weather data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(weatherServiceProvider.notifier).getCurrentWeather();
    });
  }

  @override
  void dispose() {
    _tempAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weather = ref.watch(currentWeatherProvider);
    final isWeatherLoading = ref.watch(isWeatherLoadingProvider);
    final weatherError = ref.watch(weatherErrorProvider);
    final thermostatState = ref.watch(thermostatServiceProvider);
    final climateControlState = ref.watch(climateControlNotifierProvider);
    final recommendations = ref.watch(climateRecommendationsProvider);

    return Scaffold(
      backgroundColor: HomeAppTheme.of(context).primaryBackground,
      appBar: AppBar(
        title: const Text('Climate Control'),
        backgroundColor: HomeAppTheme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.science),
            onPressed: () {
              _showModelTestDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () async {
              final modelInfo = await ref.read(mlModelInfoProvider.future);
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('ML Model Debug Info'),
                    content: SingleChildScrollView(
                      child: Text(
                        modelInfo.entries
                            .map((e) => '${e.key}: ${e.value}')
                            .join('\n'),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(weatherServiceProvider.notifier).refreshWeather();
              ref.read(climateControlNotifierProvider.notifier).manualRefresh();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(weatherServiceProvider.notifier).getCurrentWeather();
          await ref
              .read(climateControlNotifierProvider.notifier)
              .manualRefresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Weather Card
              _buildWeatherCard(weather, isWeatherLoading, weatherError),
              const SizedBox(height: 16),

              // Thermostat Control Card
              _buildThermostatCard(thermostatState),
              const SizedBox(height: 16),

              // ML Prediction Card (only show when auto mode is enabled)
              if (thermostatState.settings.mode == ThermostatMode.auto)
                _buildMlPredictionCard(),
              if (thermostatState.settings.mode == ThermostatMode.auto)
                const SizedBox(height: 16),

              // Climate Control Settings
              _buildClimateControlCard(climateControlState),
              const SizedBox(height: 16),

              // Recommendations Card
              if (recommendations.isNotEmpty) ...[
                _buildRecommendationsCard(recommendations),
                const SizedBox(height: 16),
              ],

              // Quick Actions
              _buildQuickActionsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherCard(
      WeatherData? weather, bool isLoading, String? error) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.wb_sunny, color: Colors.orange, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Current Weather',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (error != null)
              Column(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(weatherServiceProvider.notifier)
                          .getCurrentWeather();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              )
            else if (weather != null)
              _buildWeatherInfo(weather)
            else
              const Text('No weather data available'),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(WeatherData weather) {
    return AnimatedBuilder(
      animation: _tempAnimation,
      builder: (context, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.cityName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      weather.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${(weather.temperature * _tempAnimation.value).toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      'Feels ${weather.feelsLike.toStringAsFixed(1)}°C',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherDetail(
                  Icons.water_drop,
                  'Humidity',
                  '${weather.humidity.toStringAsFixed(0)}%',
                  Colors.blue,
                ),
                _buildWeatherDetail(
                  Icons.air,
                  'Wind',
                  '${weather.windSpeed.toStringAsFixed(1)} m/s',
                  Colors.green,
                ),
                _buildWeatherDetail(
                  Icons.speed,
                  'Pressure',
                  '${weather.pressure} hPa',
                  Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getThermostatRecommendationColor(
                        weather.thermostatRecommendation)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getThermostatRecommendationColor(
                      weather.thermostatRecommendation),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getThermostatRecommendationIcon(
                        weather.thermostatRecommendation),
                    color: _getThermostatRecommendationColor(
                        weather.thermostatRecommendation),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Recommendation: ${_getThermostatRecommendationText(weather.thermostatRecommendation)}',
                      style: TextStyle(
                        color: _getThermostatRecommendationColor(
                            weather.thermostatRecommendation),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeatherDetail(
      IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildThermostatCard(ThermostatState thermostatState) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.thermostat,
                      color: _getThermostatStatusColor(thermostatState.status),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Thermostat',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
                Switch(
                  value: thermostatState.settings.isOn,
                  onChanged: (value) {
                    ref.read(thermostatServiceProvider.notifier).togglePower();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!thermostatState.isConnected)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Thermostat not connected. Check your device.',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              // Temperature Control
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Target Temperature',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            final newTemp =
                                thermostatState.settings.targetTemperature -
                                    0.5;
                            if (newTemp >= 16.0) {
                              ref
                                  .read(thermostatServiceProvider.notifier)
                                  .setTargetTemperature(newTemp);
                            }
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                          iconSize: 32,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${thermostatState.settings.targetTemperature.toStringAsFixed(1)}°C',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: () {
                            final newTemp =
                                thermostatState.settings.targetTemperature +
                                    0.5;
                            if (newTemp <= 30.0) {
                              ref
                                  .read(thermostatServiceProvider.notifier)
                                  .setTargetTemperature(newTemp);
                            }
                          },
                          icon: const Icon(Icons.add_circle_outline),
                          iconSize: 32,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Mode Selection
              Text(
                'Mode',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ThermostatMode.values.map((mode) {
                  final isSelected = thermostatState.settings.mode == mode;
                  return FilterChip(
                    label: Text(mode.name.toUpperCase()),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        ref
                            .read(thermostatServiceProvider.notifier)
                            .setMode(mode);
                      }
                    },
                    selectedColor: HomeAppTheme.of(context)
                        .primaryColor
                        .withValues(alpha: 0.2),
                    checkmarkColor: HomeAppTheme.of(context).primaryColor,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // ML Prediction Button for Auto Mode
              if (thermostatState.settings.mode == ThermostatMode.auto)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final weather = ref.read(currentWeatherProvider);
                      await ref
                          .read(mlPredictionServiceProvider.notifier)
                          .predictOptimalTemperature(
                            roomName: 'Main Thermostat',
                            currentTemperature:
                                thermostatState.currentTemperature,
                            outsideTemperature: weather?.temperature,
                            humidity: weather?.humidity.toDouble(),
                            pressure: weather?.pressure.toDouble(),
                          );

                      // Auto-apply the prediction if confidence is high
                      final prediction =
                          ref.read(currentThermostatPredictionProvider);
                      if (prediction != null && prediction.confidence > 0.7) {
                        await ref
                            .read(thermostatServiceProvider.notifier)
                            .setTargetTemperature(
                                prediction.predictedTemperature);
                      }
                    },
                    icon: const Icon(Icons.psychology, size: 18),
                    label: const Text('Get ML Temperature Prediction'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.withValues(alpha: 0.1),
                      foregroundColor: Colors.purple,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                            color: Colors.purple.withValues(alpha: 0.3)),
                      ),
                    ),
                  ),
                ),
              // Status
              Row(
                children: [
                  Icon(
                    _getThermostatStatusIcon(thermostatState.status),
                    color: _getThermostatStatusColor(thermostatState.status),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Status: ${thermostatState.status.name.toUpperCase()}',
                    style: TextStyle(
                      color: _getThermostatStatusColor(thermostatState.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildClimateControlCard(ClimateControlState climateState) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.smart_toy, color: Colors.green, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Smart Climate Control',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Weather-Based Control'),
              subtitle: const Text('Automatically adjust based on weather'),
              value: climateState.mode == ClimateControlMode.weatherBased &&
                  climateState.isActive,
              onChanged: (value) {
                if (value) {
                  ref
                      .read(climateControlNotifierProvider.notifier)
                      .enableWeatherBasedControl();
                } else {
                  ref
                      .read(climateControlNotifierProvider.notifier)
                      .disableWeatherBasedControl();
                }
              },
            ),
            if (climateState.status != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        climateState.status!,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsCard(Map<String, dynamic> recommendations) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb_outline,
                    color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Recommendations',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (recommendations['reason'] != null)
              _buildRecommendationItem(
                Icons.thermostat,
                'Temperature',
                recommendations['reason'] as String,
                Colors.blue,
              ),
            if (recommendations['humidityAdvice'] != null)
              _buildRecommendationItem(
                Icons.water_drop,
                'Humidity',
                recommendations['humidityAdvice'] as String,
                Colors.cyan,
              ),
            if (recommendations['timeAdvice'] != null)
              _buildRecommendationItem(
                Icons.schedule,
                'Time-based',
                recommendations['timeAdvice'] as String,
                Colors.purple,
              ),
            if (recommendations['efficiency'] != null)
              _buildRecommendationItem(
                Icons.eco,
                'Efficiency',
                recommendations['efficiency'] as String,
                Colors.green,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(
      IconData icon, String title, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildQuickActionButton(
                  'Cool Down',
                  Icons.ac_unit,
                  Colors.blue,
                  () {
                    ref
                        .read(thermostatServiceProvider.notifier)
                        .setTargetTemperature(20.0);
                    ref
                        .read(thermostatServiceProvider.notifier)
                        .setMode(ThermostatMode.cool);
                  },
                ),
                _buildQuickActionButton(
                  'Warm Up',
                  Icons.whatshot,
                  Colors.red,
                  () {
                    ref
                        .read(thermostatServiceProvider.notifier)
                        .setTargetTemperature(25.0);
                    ref
                        .read(thermostatServiceProvider.notifier)
                        .setMode(ThermostatMode.heat);
                  },
                ),
                _buildQuickActionButton(
                  'Auto Mode',
                  Icons.settings_suggest,
                  Colors.green,
                  () {
                    ref
                        .read(thermostatServiceProvider.notifier)
                        .setMode(ThermostatMode.auto);
                    ref
                        .read(thermostatServiceProvider.notifier)
                        .enableAutoMode(true);
                  },
                ),
                _buildQuickActionButton(
                  'Energy Saver',
                  Icons.eco,
                  Colors.orange,
                  () {
                    ref
                        .read(climateControlNotifierProvider.notifier)
                        .setMode(ClimateControlMode.energySaver);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withValues(alpha: 0.3)),
        ),
      ),
    );
  }

  Widget _buildMlPredictionCard() {
    final prediction = ref.watch(currentThermostatPredictionProvider);
    final weather = ref.watch(currentWeatherProvider);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology, color: Colors.purple, size: 24),
                const SizedBox(width: 8),
                Text(
                  'ML Temperature Prediction',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (prediction == null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.auto_awesome,
                        size: 48, color: Colors.purple),
                    const SizedBox(height: 8),
                    const Text(
                      'Auto Mode Active',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Temperature will be predicted using ML model based on:\n• Time patterns\n• Weather conditions\n• Historical preferences\n\nThis temperature is predicted using a ML model.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(mlPredictionServiceProvider.notifier)
                            .predictOptimalTemperature(
                              roomName: 'Main Thermostat',
                              currentTemperature: ref
                                  .read(thermostatServiceProvider)
                                  .currentTemperature,
                              outsideTemperature: weather?.temperature,
                              humidity: weather?.humidity.toDouble(),
                              pressure: weather?.pressure.toDouble(),
                            );
                      },
                      child: const Text('Get Prediction'),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.withValues(alpha: 0.1),
                      Colors.blue.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.purple.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.psychology,
                            color: Colors.purple, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'ML Predicted Temperature',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${prediction.predictedTemperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getConfidenceColor(prediction.confidence),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Confidence: ${(prediction.confidence * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ML Analysis:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.purple,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ref
                                .read(mlPredictionServiceProvider.notifier)
                                .getPredictionExplanation(prediction),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await ref
                                  .read(thermostatServiceProvider.notifier)
                                  .setTargetTemperature(
                                      prediction.predictedTemperature);
                            },
                            icon: const Icon(Icons.check, size: 16),
                            label: const Text('Apply Prediction'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await ref
                                  .read(mlPredictionServiceProvider.notifier)
                                  .predictOptimalTemperature(
                                    roomName: 'Main Thermostat',
                                    currentTemperature: ref
                                        .read(thermostatServiceProvider)
                                        .currentTemperature,
                                    outsideTemperature: weather?.temperature,
                                    humidity: weather?.humidity.toDouble(),
                                    pressure: weather?.pressure.toDouble(),
                                  );
                            },
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('Re-predict'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence > 0.8) return Colors.green;
    if (confidence > 0.6) return Colors.orange;
    return Colors.red;
  }

  Color _getThermostatRecommendationColor(
      ThermostatRecommendation recommendation) {
    switch (recommendation) {
      case ThermostatRecommendation.cool:
        return Colors.blue;
      case ThermostatRecommendation.heat:
        return Colors.red;
      case ThermostatRecommendation.maintain:
        return Colors.green;
    }
  }

  IconData _getThermostatRecommendationIcon(
      ThermostatRecommendation recommendation) {
    switch (recommendation) {
      case ThermostatRecommendation.cool:
        return Icons.ac_unit;
      case ThermostatRecommendation.heat:
        return Icons.whatshot;
      case ThermostatRecommendation.maintain:
        return Icons.check_circle;
    }
  }

  String _getThermostatRecommendationText(
      ThermostatRecommendation recommendation) {
    switch (recommendation) {
      case ThermostatRecommendation.cool:
        return 'Cool the house';
      case ThermostatRecommendation.heat:
        return 'Heat the house';
      case ThermostatRecommendation.maintain:
        return 'Maintain current temperature';
    }
  }

  Color _getThermostatStatusColor(ThermostatStatus status) {
    switch (status) {
      case ThermostatStatus.heating:
        return Colors.red;
      case ThermostatStatus.cooling:
        return Colors.blue;
      case ThermostatStatus.idle:
        return Colors.grey;
    }
  }

  IconData _getThermostatStatusIcon(ThermostatStatus status) {
    switch (status) {
      case ThermostatStatus.heating:
        return Icons.whatshot;
      case ThermostatStatus.cooling:
        return Icons.ac_unit;
      case ThermostatStatus.idle:
        return Icons.pause_circle;
    }
  }
  
  void _showModelTestDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ML Model Tester',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ModelTestWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModelTestWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<ModelTestWidget> createState() => _ModelTestWidgetState();
}

class _ModelTestWidgetState extends ConsumerState<ModelTestWidget> {
  final _hourController = TextEditingController(text: '14');
  final _minuteController = TextEditingController(text: '30');
  final _dayController = TextEditingController(text: '2');
  final _tempController = TextEditingController(text: '22');
  final _humidityController = TextEditingController(text: '50');
  final _pressureController = TextEditingController(text: '1013');
  
  Map<String, dynamic>? _testResult;
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Test Model with Custom Values',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Input fields
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _hourController,
                  decoration: const InputDecoration(
                    labelText: 'Hour (0-23)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _minuteController,
                  decoration: const InputDecoration(
                    labelText: 'Minute (0-59)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _dayController,
                  decoration: const InputDecoration(
                    labelText: 'Day (0-6)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _tempController,
                  decoration: const InputDecoration(
                    labelText: 'Current Temp (°C)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _humidityController,
                  decoration: const InputDecoration(
                    labelText: 'Humidity (%)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _pressureController,
                  decoration: const InputDecoration(
                    labelText: 'Pressure (hPa)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Test buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _testModel,
                  child: _isLoading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Test Model'),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _setCurrentTime,
                child: const Text('Use Current Time'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _runMultipleTests,
                child: const Text('Run Multiple Tests'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Results
          if (_testResult != null) ...[
            const Text(
              'Test Results:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _testResult!['success'] == true 
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                border: Border.all(
                  color: _testResult!['success'] == true 
                      ? Colors.green
                      : Colors.red,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_testResult!['success'] == true) ...[
                    Text(
                      'Predicted Temperature: ${_testResult!['convertedTemperature'].toStringAsFixed(2)}°C',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Raw Model Output: ${_testResult!['rawOutput'].toStringAsFixed(4)}'),
                    Text('Output Scale: ${_testResult!['outputScale'].toStringAsFixed(3)}'),
                    Text('Output Offset: ${_testResult!['outputOffset'].toStringAsFixed(3)}'),
                    const SizedBox(height: 8),
                    Text('Raw Input: ${_testResult!['rawInput']}'),
                    Text('Scaled Input: ${(_testResult!['scaledInput'] as List).map((e) => e.toStringAsFixed(3)).join(', ')}'),
                  ] else ...[
                    Text(
                      'Error: ${_testResult!['error']}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  void _setCurrentTime() {
    final now = DateTime.now();
    setState(() {
      _hourController.text = now.hour.toString();
      _minuteController.text = now.minute.toString();
      _dayController.text = (now.weekday - 1).toString();
    });
  }
  
  Future<void> _testModel() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final service = ref.read(mlPredictionServiceProvider.notifier);
      final result = await service.testModelWithValues(
        hour: double.parse(_hourController.text),
        minute: double.parse(_minuteController.text),
        dayOfWeek: double.parse(_dayController.text),
        currentTemp: double.parse(_tempController.text),
        humidity: double.parse(_humidityController.text),
        pressure: double.parse(_pressureController.text),
      );
      
      setState(() {
        _testResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _testResult = {
          'success': false,
          'error': e.toString(),
        };
        _isLoading = false;
      });
    }
  }
  
  Future<void> _runMultipleTests() async {
    final testCases = [
      {'hour': 8, 'minute': 0, 'day': 0, 'temp': 18, 'humidity': 40, 'pressure': 1010, 'label': 'Monday Morning (Cool)'},
      {'hour': 14, 'minute': 30, 'day': 2, 'temp': 24, 'humidity': 55, 'pressure': 1013, 'label': 'Wednesday Afternoon (Warm)'},
      {'hour': 20, 'minute': 0, 'day': 4, 'temp': 21, 'humidity': 60, 'pressure': 1015, 'label': 'Friday Evening (Moderate)'},
      {'hour': 2, 'minute': 0, 'day': 6, 'temp': 16, 'humidity': 70, 'pressure': 1005, 'label': 'Sunday Night (Cold)'},
    ];
    
    String results = 'Multiple Test Results:\n\n';
    
    for (var testCase in testCases) {
      try {
        final service = ref.read(mlPredictionServiceProvider.notifier);
        final result = await service.testModelWithValues(
          hour: (testCase['hour'] as int).toDouble(),
          minute: (testCase['minute'] as int).toDouble(),
          dayOfWeek: (testCase['day'] as int).toDouble(),
          currentTemp: (testCase['temp'] as int).toDouble(),
          humidity: (testCase['humidity'] as int).toDouble(),
          pressure: (testCase['pressure'] as int).toDouble(),
        );
        
        if (result['success'] == true) {
          results += '${testCase['label']}:\n';
          results += '  Input: ${testCase['temp']}°C -> Predicted: ${result['convertedTemperature'].toStringAsFixed(2)}°C\n';
          results += '  Raw output: ${result['rawOutput'].toStringAsFixed(4)}\n\n';
        } else {
          results += '${testCase['label']}: ERROR - ${result['error']}\n\n';
        }
      } catch (e) {
        results += '${testCase['label']}: EXCEPTION - $e\n\n';
      }
    }
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Multiple Test Results'),
          content: SingleChildScrollView(
            child: Text(results),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }
  
  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _dayController.dispose();
    _tempController.dispose();
    _humidityController.dispose();
    _pressureController.dispose();
    super.dispose();
  }
}
