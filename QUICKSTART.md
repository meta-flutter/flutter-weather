# Quick Start Guide

Get the Flutter Weather app running in 5 minutes!

## Prerequisites Check

Before you begin, ensure you have:

```bash
# Check Flutter installation
flutter doctor

# Check for Linux desktop support
flutter devices | grep linux
```

## Installation Steps

### 1. Clone and Setup

```bash
# Clone the repository
git clone https://github.com/meta-flutter/flutter-weather.git
cd flutter-weather

# Install dependencies
flutter pub get
```

### 2. Install System Dependencies (Linux)

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y \
  clang \
  cmake \
  ninja-build \
  pkg-config \
  libgtk-3-dev \
  geoclue-2.0

# Fedora
sudo dnf install -y \
  clang \
  cmake \
  ninja-build \
  gtk3-devel \
  geoclue2

# Arch Linux
sudo pacman -S \
  clang \
  cmake \
  ninja \
  gtk3 \
  geoclue2
```

### 3. Verify GeoClue2

```bash
# Check if GeoClue2 is running
systemctl status geoclue.service

# Start if not running
sudo systemctl start geoclue.service

# Enable on boot
sudo systemctl enable geoclue.service
```

### 4. Run the App

```bash
# Debug mode (with hot reload)
flutter run -d linux

# Release mode (optimized)
flutter run -d linux --release
```

## First Run

When you first launch the app:

1. **Loading Screen**: You'll see a loading indicator
2. **Location Request**: GeoClue2 will request location permission (automatic on most systems)
3. **Weather Display**: Weather data will appear with a smooth fade-in animation
4. **Manual Refresh**: Click the ↻ button to refresh weather data

## Common Issues & Solutions

### Issue 1: Flutter Not Found
```bash
# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Or install via snap
sudo snap install flutter --classic
```

### Issue 2: GeoClue2 Not Working
```bash
# Install GeoClue2
sudo apt-get install geoclue-2.0

# The app will fallback to San Francisco coordinates automatically
# You'll still see weather data, just for the default location
```

### Issue 3: Build Errors
```bash
# Clean build
flutter clean
flutter pub get

# Rebuild
flutter run -d linux
```

### Issue 4: Permission Denied
```bash
# Some systems require additional setup for GeoClue2
# Create a desktop file (if not using snap/flatpak)
cat > ~/.local/share/applications/flutter_weather.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Flutter Weather
Exec=/path/to/flutter_weather/build/linux/x64/release/bundle/flutter_weather
Icon=/path/to/icon.png
EOF
```

## Development Workflow

### Hot Reload
Make code changes and press:
- `r` - Hot reload
- `R` - Hot restart
- `q` - Quit
- `h` - Help

### Run Tests
```bash
# All tests
flutter test

# Specific test
flutter test test/widget_test.dart

# With coverage
flutter test --coverage
```

### Code Analysis
```bash
# Analyze code
flutter analyze

# Format code
flutter format lib/

# Check for outdated packages
flutter pub outdated
```

## Build for Distribution

### Debug Build
```bash
flutter build linux --debug
```

### Release Build
```bash
flutter build linux --release

# Output location:
# build/linux/x64/release/bundle/
```

### Install Locally
```bash
# Copy to local bin
cp -r build/linux/x64/release/bundle ~/.local/share/flutter_weather
ln -s ~/.local/share/flutter_weather/flutter_weather ~/.local/bin/flutter_weather

# Run from anywhere
flutter_weather
```

## Architecture Overview

```
┌─────────────────┐
│   HomeScreen    │  ← UI Layer
└────────┬────────┘
         │
    ┌────┴─────┐
    │          │
┌───▼───┐  ┌──▼───────┐
│GeoClue│  │ Weather  │  ← Service Layer
│Service│  │ Service  │
└───┬───┘  └──┬───────┘
    │         │
┌───▼─────────▼────┐
│    API / D-Bus   │  ← External Layer
└──────────────────┘
```

## Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point |
| `lib/screens/home_screen.dart` | Main UI |
| `lib/services/geoclue_service.dart` | Location via GeoClue2 |
| `lib/services/weather_service.dart` | Weather via Open-Meteo |
| `lib/widgets/weather_display.dart` | Weather UI components |
| `lib/models/weather_data.dart` | Data models |

## Customization Quick Tips

### Change Default Location
Edit `lib/screens/home_screen.dart`:
```dart
// Line ~62
location = LocationData(
  latitude: 40.7128,  // New York
  longitude: -74.0060
);
```

### Change Temperature Unit
Edit `lib/services/weather_service.dart`:
```dart
// Line ~16
'temperature_unit': 'fahrenheit',  // Changed from celsius
```

### Change Color Theme
Edit `lib/widgets/weather_display.dart`:
```dart
// Around line ~168 - _getWeatherGradient method
// Modify color values
colors: [
  Color(0xFFYOURCOLOR1),
  Color(0xFFYOURCOLOR2),
],
```

## API Testing

Test the Open-Meteo API directly:

```bash
# Current weather for San Francisco
curl "https://api.open-meteo.com/v1/forecast?latitude=37.7749&longitude=-122.4194&current_weather=true" | jq

# With detailed forecast
curl "https://api.open-meteo.com/v1/forecast?latitude=37.7749&longitude=-122.4194&current_weather=true&hourly=temperature_2m&daily=temperature_2m_max" | jq
```

## Performance Profiling

### Check Performance
```bash
# Run in profile mode
flutter run -d linux --profile

# In app, press 'P' to show performance overlay
```

### Memory Usage
```bash
# Monitor while app is running
flutter run -d linux --profile --trace-systrace

# Or use system tools
top -p $(pgrep flutter_weather)
```

## Debugging

### Enable Verbose Logging
```bash
flutter run -d linux -v
```

### Debug GeoClue2
```bash
# Monitor D-Bus traffic
dbus-monitor --system "interface='org.freedesktop.GeoClue2.Manager'"

# Check GeoClue2 clients
gdbus introspect --system \
  --dest org.freedesktop.GeoClue2 \
  --object-path /org/freedesktop/GeoClue2/Manager
```

### Debug Network
```bash
# Monitor HTTP requests
tcpdump -i any -n 'host api.open-meteo.com'

# Or use Flutter's logging
# Check console output while app runs
```

## Next Steps

1. ✅ **Get it running** - Follow steps above
2. 📚 **Read docs** - Check ARCHITECTURE.md for details
3. 🧪 **Run tests** - Ensure everything works
4. 🎨 **Customize** - Make it your own
5. 🚀 **Extend** - Add hourly/daily forecasts

## Helpful Commands Cheat Sheet

```bash
# Development
flutter run -d linux              # Run app
flutter analyze                   # Check code
flutter test                      # Run tests
flutter format lib/               # Format code

# Building
flutter build linux --release     # Production build
flutter clean                     # Clean build cache

# Debugging
flutter doctor -v                 # Check setup
flutter devices                   # List devices
flutter logs                      # View logs

# Dependencies
flutter pub get                   # Install packages
flutter pub upgrade               # Update packages
flutter pub outdated              # Check updates
```

## Getting Help

- **Documentation**: Check ARCHITECTURE.md and TESTING.md
- **Flutter Docs**: https://docs.flutter.dev
- **Open-Meteo API**: https://open-meteo.com/en/docs
- **GeoClue2**: https://www.freedesktop.org/wiki/Software/GeoClue/

## Success Indicators

You'll know everything is working when:
- ✅ App launches without errors
- ✅ Location is detected (or defaults to San Francisco)
- ✅ Weather data loads and displays
- ✅ Gradient background appears
- ✅ Refresh button updates the data
- ✅ UI is smooth and responsive

Happy coding! 🌤️
