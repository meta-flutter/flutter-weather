import 'package:dbus/dbus.dart';
import '../models/weather_data.dart';

/// Service for fetching location using GeoClue2 via D-Bus
class GeoClueService {
  DBusClient? _systemBus;
  DBusRemoteObject? _manager;
  DBusRemoteObject? _client;
  DBusRemoteObject? _location;
  
  bool _isInitialized = false;

  /// Initialize the GeoClue2 service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _systemBus = DBusClient.system();
      
      // Get the GeoClue2 manager
      _manager = DBusRemoteObject(
        _systemBus!,
        name: 'org.freedesktop.GeoClue2',
        path: DBusObjectPath('/org/freedesktop/GeoClue2/Manager'),
      );

      // Create a client
      final result = await _manager!.callMethod(
        'org.freedesktop.GeoClue2.Manager',
        'GetClient',
        [],
        replySignature: DBusSignature('o'),
      );

      final clientPath = result.returnValues[0] as DBusObjectPath;
      
      _client = DBusRemoteObject(
        _systemBus!,
        name: 'org.freedesktop.GeoClue2',
        path: clientPath,
      );

      // Set the desktop ID
      await _client!.setProperty(
        'org.freedesktop.GeoClue2.Client',
        'DesktopId',
        DBusString('flutter_weather'),
      );

      // Set requested accuracy level (exact location)
      await _client!.setProperty(
        'org.freedesktop.GeoClue2.Client',
        'RequestedAccuracyLevel',
        DBusUint32(8), // EXACT accuracy
      );

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize GeoClue2: $e');
    }
  }

  /// Get the current location
  Future<LocationData> getCurrentLocation() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Start the client
      await _client!.callMethod(
        'org.freedesktop.GeoClue2.Client',
        'Start',
        [],
        replySignature: DBusSignature(''),
      );

      // Get the current location
      final locationPath = await _client!.getProperty(
        'org.freedesktop.GeoClue2.Client',
        'Location',
        signature: DBusSignature('o'),
      );

      if (locationPath.value == DBusObjectPath('/')) {
        throw Exception('No location available');
      }

      _location = DBusRemoteObject(
        _systemBus!,
        name: 'org.freedesktop.GeoClue2',
        path: locationPath.value as DBusObjectPath,
      );

      // Get latitude
      final latitude = await _location!.getProperty(
        'org.freedesktop.GeoClue2.Location',
        'Latitude',
        signature: DBusSignature('d'),
      );

      // Get longitude
      final longitude = await _location!.getProperty(
        'org.freedesktop.GeoClue2.Location',
        'Longitude',
        signature: DBusSignature('d'),
      );

      // Get accuracy (optional)
      final accuracy = await _location!.getProperty(
        'org.freedesktop.GeoClue2.Location',
        'Accuracy',
        signature: DBusSignature('d'),
      );

      return LocationData(
        latitude: (latitude.value as DBusDouble).value,
        longitude: (longitude.value as DBusDouble).value,
        accuracy: (accuracy.value as DBusDouble).value,
      );
    } catch (e) {
      // Re-throw the exception - fallback is handled at the caller level
      throw Exception('Failed to get location: $e');
    }
  }

  /// Cleanup resources
  Future<void> dispose() async {
    try {
      if (_client != null && _isInitialized) {
        await _client!.callMethod(
          'org.freedesktop.GeoClue2.Client',
          'Stop',
          [],
          replySignature: DBusSignature(''),
        );
      }
    } catch (e) {
      // Ignore errors during cleanup
    }
    
    await _systemBus?.close();
    _systemBus = null;
    _manager = null;
    _client = null;
    _location = null;
    _isInitialized = false;
  }
}
