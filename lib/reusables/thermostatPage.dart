import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeapp/Pages/flutter_flow/HomeAppTheme.dart';
import 'package:homeapp/Services/authentication.dart';
import 'package:homeapp/Services/ml_prediction_service.dart';
import 'dart:math' as math;
import 'package:weather/weather.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ThermostatWidget extends ConsumerStatefulWidget {
  final String? roomName;
  const ThermostatWidget({Key? key, this.roomName}) : super(key: key);

  @override
  ConsumerState<ThermostatWidget> createState() => _ThermostatWidgetState();
}

class _ThermostatWidgetState extends ConsumerState<ThermostatWidget>
    with SingleTickerProviderStateMixin {
  double _currentTemperature = 22.0;
  double _targetTemperature = 22.0;
  bool _isCooling = true;
  bool _isHeating = false;
  bool _isAuto = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // Weather related
  WeatherFactory? _weatherFactory;
  Weather? _weather;
  bool _isLoadingWeather = true;
  String? _weatherError;
  final Authentication _authentication = Authentication();

  // Replace with your OpenWeatherMap API key
  final _apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _weatherFactory = WeatherFactory(_apiKey);
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      setState(() {
        _isLoadingWeather = true;
        _weatherError = null;
      });

      // Get user's address from Firebase
      final userData = await _authentication.getUserData();
      if (userData != null && userData['address'] != null) {
        final address = userData['address'].split(',')[1].trim();
        print(address); // Debugging line to check address

        // Fetch weather by city name
        // You might need to parse the address to get just the city name
        final weather =
            await _weatherFactory?.currentWeatherByCityName(address);

        if (mounted) {
          setState(() {
            _weather = weather;
            _isLoadingWeather = false;
            // Update current temperature based on actual weather
            if (weather?.temperature?.celsius != null) {
              _currentTemperature = weather!.temperature!.celsius!;
            }
          });
        }
      } else {
        // Fallback to a default location if no address is found
        final weather =
            await _weatherFactory?.currentWeatherByCityName("New York");
        if (mounted) {
          setState(() {
            _weather = weather;
            _isLoadingWeather = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _weatherError = "Unable to fetch weather";
          _isLoadingWeather = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateTemperature(double delta) {
    setState(() {
      _targetTemperature = (_targetTemperature + delta).clamp(10.0, 30.0);
    });
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Climate Control",
                style: HomeAppTheme.of(context).subtitle1.override(
                      fontFamily: 'Fira Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: HomeAppTheme.of(context).primaryText,
                    ),
              ),
              // Weather info
              if (!_isLoadingWeather && _weather != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        HomeAppTheme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getWeatherIcon(_weather!.weatherMain),
                        size: 20,
                        color: HomeAppTheme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${_weather!.temperature?.celsius?.toStringAsFixed(0)}°",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: HomeAppTheme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thermostat container
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: HomeAppTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Thermostat Circle
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 220,
                          height: 220,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Background circle with gradient
                              Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.grey.shade200,
                                      Colors.grey.shade300,
                                    ],
                                  ),
                                ),
                              ),
                              // Temperature arc
                              CustomPaint(
                                size: const Size(220, 220),
                                painter: TemperatureArcPainter(
                                  temperature: _targetTemperature,
                                  isCooling: _isCooling,
                                ),
                              ),
                              // Inner white circle
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _isCooling
                                          ? "COOLING"
                                          : _isHeating
                                              ? "HEATING"
                                              : "AUTO",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade600,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _targetTemperature.toStringAsFixed(0),
                                          style: TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.w300,
                                            color: _isCooling
                                                ? Colors.cyan
                                                : Colors.orange,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text(
                                            "°",
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w300,
                                              color: _isCooling
                                                  ? Colors.cyan
                                                  : Colors.orange,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Icon(
                                      _isCooling
                                          ? Icons.ac_unit
                                          : Icons.wb_sunny,
                                      size: 24,
                                      color: _isCooling
                                          ? Colors.cyan
                                          : Colors.orange,
                                    ),
                                  ],
                                ),
                              ),
                              // Temperature control buttons
                              Positioned(
                                top: 10,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.add, size: 20),
                                    onPressed: () => _updateTemperature(1),
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.remove, size: 20),
                                    onPressed: () => _updateTemperature(-1),
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Mode selection buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildModeButton(
                            icon: Icons.ac_unit,
                            label: "Cool",
                            isSelected: _isCooling,
                            onTap: () {
                              setState(() {
                                _isCooling = true;
                                _isHeating = false;
                                _isAuto = false;
                              });
                            },
                          ),
                          _buildModeButton(
                            icon: Icons.wb_sunny,
                            label: "Heat",
                            isSelected: _isHeating,
                            onTap: () {
                              setState(() {
                                _isCooling = false;
                                _isHeating = true;
                                _isAuto = false;
                              });
                            },
                          ),
                          _buildModeButton(
                            icon: Icons.autorenew,
                            label: "Auto",
                            isSelected: _isAuto,
                            onTap: () {
                              setState(() {
                                _isCooling = false;
                                _isHeating = false;
                                _isAuto = true;
                              });
                            },
                          ),
                        ],
                      ),
                      // ML Prediction Section for Auto Mode
                      if (_isAuto) ...[
                        const SizedBox(height: 16),
                        _buildMlPredictionSection(),
                      ],
                      const SizedBox(height: 16),
                      // Current temperature display
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Current Temperature",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              "${_currentTemperature.toStringAsFixed(1)}°",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Weather info container
              if (!_isLoadingWeather && _weather != null)
                Container(
                  width: 120,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: HomeAppTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Outside",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Icon(
                        _getWeatherIcon(_weather!.weatherMain),
                        size: 48,
                        color: HomeAppTheme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${_weather!.temperature?.celsius?.toStringAsFixed(0)}°",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: HomeAppTheme.of(context).primaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _weather!.weatherDescription ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.water_drop,
                              size: 14,
                              color: Colors.blue.shade400,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${_weather!.humidity}%",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _weather!.areaName ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMlPredictionSection() {
    final prediction = ref.watch(currentThermostatPredictionProvider);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 0.1),
            Colors.blue.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.psychology, color: Colors.purple, size: 20),
              const SizedBox(width: 8),
              Text(
                'ML Temperature Prediction',
                style: HomeAppTheme.of(context).subtitle2.override(
                  fontFamily: 'Poppins',
                  color: Colors.purple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (prediction == null) ...[
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.auto_awesome, size: 32, color: Colors.purple),
                      const SizedBox(height: 8),
                      Text(
                        'Auto Mode Active',
                        style: HomeAppTheme.of(context).subtitle2.override(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Temperature will be predicted using ML model',
                        textAlign: TextAlign.center,
                        style: HomeAppTheme.of(context).bodyText2.override(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await ref.read(mlPredictionServiceProvider.notifier).predictOptimalTemperature(
                        roomName: widget.roomName ?? 'Room',
                        currentTemperature: _currentTemperature,
                        outsideTemperature: _weather?.temperature?.celsius,
                        humidity: _weather?.humidity?.toDouble(),
                        pressure: _weather?.pressure?.toDouble(),
                      );
                    },
                    icon: const Icon(Icons.psychology, size: 16),
                    label: const Text('Get ML Prediction'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Predicted Temperature',
                        style: HomeAppTheme.of(context).bodyText2.override(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.purple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${prediction.predictedTemperature.toStringAsFixed(1)}°C',
                        style: HomeAppTheme.of(context).subtitle1.override(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getConfidenceColor(prediction.confidence),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Confidence: ${(prediction.confidence * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'This temperature is predicted using a ML model based on time patterns, weather conditions, and usage history.',
                    textAlign: TextAlign.center,
                    style: HomeAppTheme.of(context).bodyText2.override(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _targetTemperature = prediction.predictedTemperature;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                        ),
                        child: const Text('Apply', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await ref.read(mlPredictionServiceProvider.notifier).predictOptimalTemperature(
                            roomName: widget.roomName ?? 'Room',
                            currentTemperature: _currentTemperature,
                            outsideTemperature: _weather?.temperature?.celsius,
                            humidity: _weather?.humidity?.toDouble(),
                            pressure: _weather?.pressure?.toDouble(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                        ),
                        child: const Text('Refresh', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence > 0.8) return Colors.green;
    if (confidence > 0.6) return Colors.orange;
    return Colors.red;
  }

  IconData _getWeatherIcon(String? weatherMain) {
    switch (weatherMain?.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.grain;
      case 'drizzle':
        return Icons.grain;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
      case 'haze':
        return Icons.blur_on;
      default:
        return Icons.wb_sunny;
    }
  }

  Widget _buildModeButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? HomeAppTheme.of(context).primaryColor
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for the temperature arc
class TemperatureArcPainter extends CustomPainter {
  final double temperature;
  final bool isCooling;

  TemperatureArcPainter({
    required this.temperature,
    required this.isCooling,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw temperature scale marks
    final markPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2;

    for (int i = 0; i < 36; i++) {
      final angle = (i * 10 - 90) * math.pi / 180;
      final start = Offset(
        center.dx + (radius - 15) * math.cos(angle),
        center.dy + (radius - 15) * math.sin(angle),
      );
      final end = Offset(
        center.dx + (radius - 10) * math.cos(angle),
        center.dy + (radius - 10) * math.sin(angle),
      );
      canvas.drawLine(start, end, markPaint);
    }

    // Draw temperature arc
    final arcPaint = Paint()
      ..shader = LinearGradient(
        colors: isCooling
            ? [Colors.blue.shade300, Colors.cyan]
            : [Colors.orange, Colors.red.shade300],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final startAngle = -90 * math.pi / 180;
    final sweepAngle = ((temperature - 10) / 20) * 2 * math.pi * 0.75;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 20),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );

    // Draw temperature indicator dot
    final indicatorAngle = startAngle + sweepAngle;
    final indicatorOffset = Offset(
      center.dx + (radius - 20) * math.cos(indicatorAngle),
      center.dy + (radius - 20) * math.sin(indicatorAngle),
    );

    final indicatorPaint = Paint()
      ..color = isCooling ? Colors.blue : Colors.orange
      ..style = PaintingStyle.fill;

    canvas.drawCircle(indicatorOffset, 6, indicatorPaint);
  }

  @override
  bool shouldRepaint(TemperatureArcPainter oldDelegate) {
    return oldDelegate.temperature != temperature ||
        oldDelegate.isCooling != isCooling;
  }
}
