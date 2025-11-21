/// Weather data model for Open-Meteo API response
class WeatherData {
  final double temperature;
  final double windSpeed;
  final double precipitation;
  final int weatherCode;
  final DateTime time;
  final double latitude;
  final double longitude;

  WeatherData({
    required this.temperature,
    required this.windSpeed,
    required this.precipitation,
    required this.weatherCode,
    required this.time,
    required this.latitude,
    required this.longitude,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final currentWeather = json['current_weather'] as Map<String, dynamic>;
    
    return WeatherData(
      temperature: (currentWeather['temperature'] as num).toDouble(),
      windSpeed: (currentWeather['windspeed'] as num).toDouble(),
      // Note: Open-Meteo's current_weather endpoint doesn't include precipitation
      // For precipitation data, use the hourly or daily forecast endpoints
      precipitation: 0.0,
      weatherCode: currentWeather['weathercode'] as int,
      time: DateTime.parse(currentWeather['time'] as String),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  /// Get weather description from WMO weather code
  String get weatherDescription {
    switch (weatherCode) {
      case 0:
        return 'Clear sky';
      case 1:
      case 2:
      case 3:
        return 'Partly cloudy';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rain';
      case 71:
      case 73:
      case 75:
        return 'Snow';
      case 77:
        return 'Snow grains';
      case 80:
      case 81:
      case 82:
        return 'Rain showers';
      case 85:
      case 86:
        return 'Snow showers';
      case 95:
        return 'Thunderstorm';
      case 96:
      case 99:
        return 'Thunderstorm with hail';
      default:
        return 'Unknown';
    }
  }

  /// Get weather emoji icon
  String get weatherIcon {
    switch (weatherCode) {
      case 0:
        return '☀️';
      case 1:
      case 2:
      case 3:
        return '⛅';
      case 45:
      case 48:
        return '🌫️';
      case 51:
      case 53:
      case 55:
        return '🌦️';
      case 61:
      case 63:
      case 65:
        return '🌧️';
      case 71:
      case 73:
      case 75:
        return '❄️';
      case 77:
        return '🌨️';
      case 80:
      case 81:
      case 82:
        return '🌦️';
      case 85:
      case 86:
        return '🌨️';
      case 95:
        return '⛈️';
      case 96:
      case 99:
        return '⛈️';
      default:
        return '🌡️';
    }
  }
}

/// Location data model
class LocationData {
  final double latitude;
  final double longitude;
  final double? accuracy;

  LocationData({
    required this.latitude,
    required this.longitude,
    this.accuracy,
  });

  @override
  String toString() {
    return 'LocationData(lat: $latitude, lon: $longitude, accuracy: $accuracy)';
  }
}
