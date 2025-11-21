import 'package:flutter/material.dart';
import '../models/weather_data.dart';
import '../services/geoclue_service.dart';
import '../services/weather_service.dart';
import '../widgets/weather_display.dart';

/// Home screen that displays weather information
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final GeoClueService _geoClueService = GeoClueService();
  final WeatherService _weatherService = WeatherService();
  
  WeatherData? _weatherData;
  String? _errorMessage;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _loadWeatherData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _geoClueService.dispose();
    super.dispose();
  }

  Future<void> _loadWeatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get location using GeoClue2
      LocationData location;
      try {
        location = await _geoClueService.getCurrentLocation();
      } catch (e) {
        // Fallback to a default location if GeoClue2 fails
        // Using San Francisco as default
        debugPrint('GeoClue2 failed, using default location: $e');
        location = LocationData(latitude: 37.7749, longitude: -122.4194);
      }

      // Fetch weather data
      final weather = await _weatherService.getCurrentWeather(
        location.latitude,
        location.longitude,
      );

      setState(() {
        _weatherData = weather;
        _isLoading = false;
      });

      // Start fade-in animation
      _animationController.forward();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3C72),
              Color(0xFF2A5298),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Weather',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _isLoading ? null : _loadWeatherData,
                      iconSize: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Weather content
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildWeatherContent(),
                      ),
                    ),
                  ),
                ),
                
                // Footer info
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Data from Open-Meteo API',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherContent() {
    if (_isLoading) {
      return const WeatherLoadingWidget();
    } else if (_errorMessage != null) {
      return WeatherErrorWidget(
        error: _errorMessage!,
        onRetry: _loadWeatherData,
      );
    } else if (_weatherData != null) {
      return WeatherDisplay(weather: _weatherData!);
    } else {
      return const WeatherLoadingWidget();
    }
  }
}
