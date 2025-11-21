# Testing Guide for Flutter Weather App

This document describes how to test the Flutter Weather application.

## Prerequisites

- Flutter SDK (>=3.0.0) installed
- Linux system with GeoClue2 service running
- D-Bus system service active

## Running the Application

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Run on Linux

```bash
flutter run -d linux
```

### 3. Build for Release

```bash
flutter build linux --release
```

The compiled application will be in `build/linux/x64/release/bundle/`.

## Manual Testing Checklist

### Location Services (GeoClue2)

- [ ] Application requests location permission on first run
- [ ] Location is successfully retrieved via D-Bus
- [ ] Fallback to default location (San Francisco) if GeoClue2 fails
- [ ] Location coordinates are displayed in the weather card

### Weather API Integration

- [ ] Weather data is fetched from Open-Meteo API
- [ ] Current temperature is displayed correctly
- [ ] Wind speed is shown in km/h
- [ ] Weather icon matches the current conditions
- [ ] Weather description is accurate
- [ ] Last update time is shown in local timezone

### UI/UX Features

- [ ] Loading state shows circular progress indicator
- [ ] Error state displays helpful error message with retry button
- [ ] Weather card has appropriate gradient based on conditions
- [ ] Fade-in animation works smoothly
- [ ] Refresh button updates weather data
- [ ] UI is responsive and scales properly

### Error Handling

- [ ] Graceful fallback when GeoClue2 is unavailable
- [ ] Network error handling for API failures
- [ ] User-friendly error messages
- [ ] Retry functionality works correctly

## Automated Testing

### Run Unit Tests

```bash
flutter test
```

### Run Widget Tests

```bash
flutter test test/widget_test.dart
```

### Code Analysis

```bash
flutter analyze
```

## Testing Without GeoClue2

If GeoClue2 is not available on your system, the app will automatically fall back to a default location (San Francisco: 37.7749°N, 122.4194°W) to fetch weather data.

## Testing API Endpoints

You can manually test the Open-Meteo API:

```bash
curl "https://api.open-meteo.com/v1/forecast?latitude=37.7749&longitude=-122.4194&current_weather=true"
```

## Known Test Scenarios

1. **Sunny Weather**: Clear sky (weather code 0)
2. **Rainy Weather**: Rain (weather code 61-65)
3. **Snowy Weather**: Snow (weather code 71-75)
4. **Stormy Weather**: Thunderstorm (weather code 95+)
5. **Cloudy Weather**: Partly cloudy (weather code 1-3)

## Performance Testing

- [ ] App starts within 3 seconds
- [ ] Weather data loads within 5 seconds
- [ ] UI animations are smooth (60 FPS)
- [ ] Memory usage is reasonable (<100 MB)
- [ ] No memory leaks after multiple refresh cycles

## Platform-Specific Testing

### Linux

- [ ] GTK window displays correctly
- [ ] Header bar shows application title
- [ ] Window can be resized
- [ ] Application closes properly

## Debugging

### Enable Debug Logs

The app uses `debugPrint` for logging. Run with debug mode to see logs:

```bash
flutter run -d linux --debug
```

### Check GeoClue2 Status

```bash
systemctl status geoclue.service
```

### Monitor D-Bus Communication

```bash
dbus-monitor --system
```

## Troubleshooting

### Issue: Location not working

**Solution**: Ensure GeoClue2 is installed and running:
```bash
sudo apt-get install geoclue-2.0
sudo systemctl start geoclue.service
```

### Issue: Network errors

**Solution**: Check internet connectivity and firewall settings.

### Issue: Build fails

**Solution**: Ensure all dependencies are installed:
```bash
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev
```

## Test Coverage Goals

- Unit tests: >80% coverage
- Widget tests: Key user flows covered
- Integration tests: End-to-end scenarios

## Continuous Integration

For CI/CD pipelines, you can use:

```bash
# Analyze code
flutter analyze

# Run tests
flutter test --coverage

# Build application
flutter build linux --release
```

## Future Test Considerations

- Hourly forecast display tests
- Daily forecast display tests
- Multiple location management tests
- Settings and preferences tests
- Offline mode tests
