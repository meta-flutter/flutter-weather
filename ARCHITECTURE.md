# Architecture Documentation

## Overview

The Flutter Weather app follows a clean architecture pattern with clear separation of concerns. The application is structured into services, models, widgets, and screens.

## Project Structure

```
flutter_weather/
├── lib/
│   ├── main.dart                    # Application entry point
│   ├── models/
│   │   └── weather_data.dart        # Data models
│   ├── services/
│   │   ├── geoclue_service.dart     # Location service via D-Bus
│   │   └── weather_service.dart     # Weather API service
│   ├── screens/
│   │   └── home_screen.dart         # Main application screen
│   └── widgets/
│       └── weather_display.dart     # Reusable weather UI components
├── test/
│   └── widget_test.dart             # Widget tests
├── linux/                           # Linux platform-specific code
├── pubspec.yaml                     # Dependencies
└── analysis_options.yaml            # Linting rules
```

## Layers

### 1. Services Layer

#### GeoClueService (`services/geoclue_service.dart`)

Responsible for fetching device location using GeoClue2 via D-Bus.

**Key Features:**
- Initializes D-Bus connection to system bus
- Communicates with GeoClue2 Manager
- Creates client with appropriate accuracy settings
- Retrieves latitude, longitude, and accuracy
- Provides graceful cleanup on disposal

**D-Bus Communication:**
```
System Bus → GeoClue2 Manager → Client → Location
```

**Methods:**
- `initialize()`: Sets up D-Bus connection and GeoClue2 client
- `getCurrentLocation()`: Returns `LocationData` with coordinates
- `dispose()`: Cleans up resources

#### WeatherService (`services/weather_service.dart`)

Handles HTTP communication with the Open-Meteo API.

**Key Features:**
- Constructs API URLs with query parameters
- Fetches current weather data
- Supports detailed weather with hourly/daily forecasts
- Error handling for network issues

**API Endpoint:**
```
https://api.open-meteo.com/v1/forecast
  ?latitude={lat}
  &longitude={lon}
  &current_weather=true
```

**Methods:**
- `getCurrentWeather(lat, lon)`: Returns `WeatherData`
- `getDetailedWeather(lat, lon)`: Returns extended forecast data

### 2. Models Layer

#### WeatherData (`models/weather_data.dart`)

Immutable data class representing weather information.

**Properties:**
- `temperature`: Temperature in Celsius
- `windSpeed`: Wind speed in km/h
- `precipitation`: Precipitation amount in mm
- `weatherCode`: WMO weather code
- `time`: Timestamp of weather data
- `latitude`: Location latitude
- `longitude`: Location longitude

**Computed Properties:**
- `weatherDescription`: Human-readable weather description
- `weatherIcon`: Emoji icon for weather condition

**Weather Code Mapping:**
- 0: Clear sky ☀️
- 1-3: Partly cloudy ⛅
- 45-48: Fog 🌫️
- 51-55: Drizzle 🌦️
- 61-65: Rain 🌧️
- 71-75: Snow ❄️
- 95+: Thunderstorm ⛈️

#### LocationData

Simple data class for location information.

**Properties:**
- `latitude`: Latitude coordinate
- `longitude`: Longitude coordinate
- `accuracy`: Optional accuracy in meters

### 3. Screens Layer

#### HomeScreen (`screens/home_screen.dart`)

Main application screen managing weather display logic.

**State Management:**
- Uses `StatefulWidget` for local state
- Manages loading, error, and data states
- Implements animation controller for smooth transitions

**Key Features:**
- Automatic weather loading on initialization
- Manual refresh via refresh button
- Graceful error handling with retry
- Fade-in animation for weather display

**Lifecycle:**
1. `initState()`: Initialize animations, load weather
2. `_loadWeatherData()`: Fetch location and weather
3. `_buildWeatherContent()`: Render appropriate state
4. `dispose()`: Clean up resources

### 4. Widgets Layer

#### WeatherDisplay (`widgets/weather_display.dart`)

Reusable widget for displaying weather information.

**Components:**
- Weather icon (emoji)
- Temperature (large, prominent)
- Weather description
- Wind speed detail
- Precipitation detail
- Last update time
- Location coordinates

**Styling:**
- Dynamic gradient backgrounds based on weather
- iOS Weather-inspired design
- Clean, minimal interface
- Proper spacing and typography

**Gradient Mapping:**
- Clear: Blue gradient (sunny)
- Rain: Dark gray gradient
- Snow: Light blue gradient
- Thunderstorm: Dark gradient
- Default: Medium blue gradient

#### WeatherLoadingWidget

Shows loading state with spinner and message.

#### WeatherErrorWidget

Displays error state with message and retry button.

### 5. Main Application

#### main.dart

Application entry point and root widget.

**Features:**
- Material 3 design system
- Google Fonts (Inter) for typography
- Custom color scheme
- Transparent scaffold background

## Data Flow

```
User Action (Refresh)
    ↓
HomeScreen._loadWeatherData()
    ↓
GeoClueService.getCurrentLocation()
    ↓ (D-Bus)
GeoClue2 System Service
    ↓
LocationData
    ↓
WeatherService.getCurrentWeather()
    ↓ (HTTP)
Open-Meteo API
    ↓
JSON Response
    ↓
WeatherData.fromJson()
    ↓
setState() → UI Update
    ↓
WeatherDisplay renders
```

## Error Handling Strategy

### Location Errors
- GeoClue2 unavailable → Fall back to default location
- Permission denied → Show error with explanation
- Network timeout → Show error with retry

### Weather API Errors
- HTTP error → Display status code
- Network failure → User-friendly message
- JSON parsing error → Technical error details

### UI States
1. **Loading**: Shows progress indicator
2. **Success**: Displays weather data
3. **Error**: Shows error message with retry

## Animation System

Uses Flutter's animation framework:
- `AnimationController`: Manages animation lifecycle
- `CurvedAnimation`: Easing function (ease-in)
- `FadeTransition`: Smooth fade-in effect
- Duration: 800ms

## Dependencies

### Core Dependencies
- `flutter`: Flutter SDK
- `http`: ^1.1.0 - HTTP client
- `dbus`: ^0.7.10 - D-Bus client for GeoClue2
- `provider`: ^6.1.1 - State management (prepared for future use)
- `intl`: ^0.18.1 - Internationalization and date formatting
- `google_fonts`: ^6.1.0 - Custom fonts

### Dev Dependencies
- `flutter_test`: Testing framework
- `flutter_lints`: Linting rules

## Security Considerations

1. **API Keys**: Open-Meteo doesn't require API keys
2. **Location Privacy**: Uses GeoClue2 system service with proper permissions
3. **HTTPS**: All API calls use secure HTTPS
4. **Input Validation**: API responses are validated before parsing

## Performance Optimizations

1. **Lazy Loading**: Services initialize only when needed
2. **Efficient Rendering**: Uses `const` constructors where possible
3. **Resource Cleanup**: Proper disposal of services and controllers
4. **Caching**: Can be extended to cache weather data

## Extensibility Points

### Adding Hourly Forecasts
1. Extend `WeatherService.getDetailedWeather()`
2. Create `HourlyForecastWidget`
3. Parse hourly data from API response
4. Display in scrollable list

### Adding Daily Forecasts
1. Create `DailyForecast` model
2. Parse daily data from API
3. Create `DailyForecastCard` widget
4. Add to home screen

### Multiple Locations
1. Create `LocationManager` service
2. Store locations in local storage
3. Add location selection UI
4. Support switching between locations

### Offline Support
1. Add local database (sqflite)
2. Cache weather data
3. Implement cache invalidation strategy
4. Show cached data when offline

## Testing Strategy

### Unit Tests
- Service logic (GeoClue, Weather API)
- Model parsing and conversion
- Error handling

### Widget Tests
- UI component rendering
- User interactions
- State transitions

### Integration Tests
- End-to-end user flows
- Real API calls (with mocking)
- Platform-specific features

## Build and Deployment

### Debug Build
```bash
flutter run -d linux
```

### Release Build
```bash
flutter build linux --release
```

### Output
```
build/linux/x64/release/bundle/
├── flutter_weather (executable)
├── lib/
│   └── libflutter_linux_gtk.so
└── data/
    └── flutter_assets/
```

## Platform Support

Currently supports:
- **Linux**: Primary platform with GeoClue2 integration
- **Future**: Could extend to Android/iOS with platform-specific location APIs

## Linting and Code Quality

Uses `flutter_lints` with additional rules:
- `prefer_const_constructors`
- `prefer_const_literals_to_create_immutables`
- `avoid_print`
- `prefer_final_fields`
- `prefer_single_quotes`

## Troubleshooting

### Common Issues

1. **GeoClue2 not found**
   - Install: `sudo apt-get install geoclue-2.0`
   - Start: `sudo systemctl start geoclue.service`

2. **Build failures**
   - Install GTK: `sudo apt-get install libgtk-3-dev`
   - Install build tools: `sudo apt-get install clang cmake ninja-build`

3. **API timeouts**
   - Check internet connection
   - Verify firewall settings
   - Use fallback location

## Future Improvements

1. **Caching**: Implement local caching for offline support
2. **Notifications**: Weather alerts and updates
3. **Widgets**: Home screen widgets for quick weather check
4. **Customization**: User preferences for units, themes
5. **Extended Forecasts**: Hourly and weekly forecasts
6. **Multiple Locations**: Support for multiple saved locations
7. **Weather Maps**: Visual weather maps and radar
8. **Accessibility**: Enhanced screen reader support
