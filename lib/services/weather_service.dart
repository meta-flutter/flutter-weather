import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';

/// Service for fetching weather data from Open-Meteo API
class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  /// Fetch current weather for given coordinates
  Future<WeatherData> getCurrentWeather(double latitude, double longitude) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current_weather': 'true',
        'temperature_unit': 'celsius',
        'windspeed_unit': 'kmh',
      },
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherData.fromJson(json);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch weather: $e');
    }
  }

  /// Fetch weather with hourly and daily forecast data
  /// This can be extended later for more detailed views
  Future<Map<String, dynamic>> getDetailedWeather(
    double latitude,
    double longitude,
  ) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current_weather': 'true',
        'hourly': 'temperature_2m,precipitation,windspeed_10m',
        'daily': 'temperature_2m_max,temperature_2m_min,precipitation_sum',
        'temperature_unit': 'celsius',
        'windspeed_unit': 'kmh',
        'timezone': 'auto',
      },
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load detailed weather: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch detailed weather: $e');
    }
  }
}
