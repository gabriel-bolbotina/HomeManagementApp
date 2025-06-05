import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/weather_service.dart';
import '../services/thermostat_service.dart';
import '../providers/climate_control_provider.dart';

class ClimateControlCard extends ConsumerWidget {
  const ClimateControlCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(currentWeatherProvider);
    final thermostatSettings = ref.watch(thermostatSettingsProvider);
    final isClimateActive = ref.watch(isClimateControlActiveProvider);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/climate_control');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.thermostat,
                        color: _getThermostatColor(thermostatSettings),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Climate Control',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (isClimateActive)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'AUTO',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Indoor Target',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${thermostatSettings.targetTemperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  if (weather != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Outside',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${weather.temperature.toStringAsFixed(1)}°C',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    _getModeIcon(thermostatSettings.mode),
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    thermostatSettings.mode.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (weather != null) ...[
                    Icon(
                      Icons.water_drop,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${weather.humidity.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
              if (weather != null && isClimateActive) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getRecommendationColor(weather.thermostatRecommendation).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getRecommendationIcon(weather.thermostatRecommendation),
                        size: 14,
                        color: _getRecommendationColor(weather.thermostatRecommendation),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _getRecommendationText(weather.thermostatRecommendation),
                          style: TextStyle(
                            fontSize: 11,
                            color: _getRecommendationColor(weather.thermostatRecommendation),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getThermostatColor(ThermostatSettings settings) {
    if (!settings.isOn) return Colors.grey;
    
    switch (settings.mode) {
      case ThermostatMode.heat:
        return Colors.red;
      case ThermostatMode.cool:
        return Colors.blue;
      case ThermostatMode.auto:
        return Colors.green;
      case ThermostatMode.off:
        return Colors.grey;
    }
  }

  IconData _getModeIcon(ThermostatMode mode) {
    switch (mode) {
      case ThermostatMode.heat:
        return Icons.whatshot;
      case ThermostatMode.cool:
        return Icons.ac_unit;
      case ThermostatMode.auto:
        return Icons.settings_suggest;
      case ThermostatMode.off:
        return Icons.power_off;
    }
  }

  Color _getRecommendationColor(ThermostatRecommendation recommendation) {
    switch (recommendation) {
      case ThermostatRecommendation.cool:
        return Colors.blue;
      case ThermostatRecommendation.heat:
        return Colors.red;
      case ThermostatRecommendation.maintain:
        return Colors.green;
    }
  }

  IconData _getRecommendationIcon(ThermostatRecommendation recommendation) {
    switch (recommendation) {
      case ThermostatRecommendation.cool:
        return Icons.keyboard_arrow_down;
      case ThermostatRecommendation.heat:
        return Icons.keyboard_arrow_up;
      case ThermostatRecommendation.maintain:
        return Icons.check;
    }
  }

  String _getRecommendationText(ThermostatRecommendation recommendation) {
    switch (recommendation) {
      case ThermostatRecommendation.cool:
        return 'Cooling recommended';
      case ThermostatRecommendation.heat:
        return 'Heating recommended';
      case ThermostatRecommendation.maintain:
        return 'Temperature optimal';
    }
  }
}