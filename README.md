# Flutter Weather App

A modern Flutter weather application that uses the Open-Meteo API for weather data and GeoClue2 for location services on Linux.

## Features

- 🌍 **Location Services**: Uses GeoClue2 via D-Bus for accurate location detection on Linux
- 🌤️ **Real-time Weather**: Fetches current weather data from Open-Meteo API
- 📊 **Detailed Information**: Displays temperature, wind speed, precipitation, and last update time
- 🎨 **Modern UI**: iOS Weather-inspired design with elegant animations and responsive layouts
- 🌈 **Dynamic Theming**: Weather-based gradient backgrounds that change with conditions

## Architecture

### Services
- **GeoClueService** (`lib/services/geoclue_service.dart`): Handles location fetching via D-Bus
- **WeatherService** (`lib/services/weather_service.dart`): Manages Open-Meteo API calls

### Models
- **WeatherData** (`lib/models/weather_data.dart`): Data models for weather and location

### UI Components
- **HomeScreen** (`lib/screens/home_screen.dart`): Main application screen with weather display logic
- **WeatherDisplay** (`lib/widgets/weather_display.dart`): Reusable weather UI components

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Linux system with GeoClue2 installed
- D-Bus system service

### Installation

1. Clone the repository:
```bash
git clone https://github.com/meta-flutter/flutter-weather.git
cd flutter-weather
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run -d linux
```

## API Usage

The app uses the Open-Meteo API which is free and doesn't require an API key:
```
https://api.open-meteo.com/v1/forecast?latitude=LAT&longitude=LON&current_weather=true
```

## Permissions

On Linux, the app requires permission to access GeoClue2 for location services. This is handled automatically through D-Bus.

## Future Enhancements

- Hourly and daily forecast panels
- Multiple location support
- Weather alerts and notifications
- Customizable units (Celsius/Fahrenheit)
- Offline support with cached data

## License

This project is open source and available under the MIT License.