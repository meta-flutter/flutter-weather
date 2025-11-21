import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_data.dart';

/// Widget to display current weather information
class WeatherDisplay extends StatelessWidget {
  final WeatherData weather;

  const WeatherDisplay({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('EEEE, MMM d • h:mm a');
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        gradient: _getWeatherGradient(weather.weatherCode),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Weather icon
          Text(
            weather.weatherIcon,
            style: const TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 16),
          
          // Temperature
          Text(
            '${weather.temperature.round()}°',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          
          // Weather description
          Text(
            weather.weatherDescription,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          
          // Divider
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          
          // Weather details grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWeatherDetail(
                icon: Icons.air,
                label: 'Wind Speed',
                value: '${weather.windSpeed.toStringAsFixed(1)} km/h',
              ),
              _buildWeatherDetail(
                icon: Icons.water_drop,
                label: 'Precipitation',
                value: '${weather.precipitation.toStringAsFixed(1)} mm',
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Last update time
          Text(
            'Last updated: ${timeFormat.format(weather.time)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 8),
          
          // Location
          Text(
            'Location: ${weather.latitude.toStringAsFixed(2)}°, ${weather.longitude.toStringAsFixed(2)}°',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  LinearGradient _getWeatherGradient(int weatherCode) {
    // Return different gradients based on weather conditions
    if (weatherCode == 0) {
      // Clear sky - sunny gradient
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF4A90E2),
          Color(0xFF50C9E9),
        ],
      );
    } else if (weatherCode >= 61 && weatherCode <= 82) {
      // Rain - rainy gradient
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF4A5F7F),
          Color(0xFF5B7C99),
        ],
      );
    } else if (weatherCode >= 71 && weatherCode <= 86) {
      // Snow - snowy gradient
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF91A8C2),
          Color(0xFFB8C9DA),
        ],
      );
    } else if (weatherCode >= 95) {
      // Thunderstorm - stormy gradient
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF2C3E50),
          Color(0xFF4A5F7F),
        ],
      );
    } else {
      // Partly cloudy or other - default gradient
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF5B8DB8),
          Color(0xFF7BA3C7),
        ],
      );
    }
  }
}

/// Loading widget with animation
class WeatherLoadingWidget extends StatelessWidget {
  const WeatherLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(64.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5B8DB8),
            Color(0xFF7BA3C7),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
          SizedBox(height: 24),
          Text(
            'Loading weather data...',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

/// Error widget
class WeatherErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;

  const WeatherErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8B5A5A),
            Color(0xFFA47171),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'Unable to load weather',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF8B5A5A),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
