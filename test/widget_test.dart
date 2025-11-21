import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather/main.dart';

void main() {
  testWidgets('Weather app smoke test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const WeatherApp());

    // Verify the app title is present
    expect(find.text('Weather'), findsOneWidget);

    // Verify loading or error state is shown initially
    // Check that either a loading indicator or error icon is present
    final loadingFinder = find.byType(CircularProgressIndicator);
    final errorFinder = find.byIcon(Icons.error_outline);
    
    expect(
      loadingFinder.evaluate().isNotEmpty || errorFinder.evaluate().isNotEmpty,
      isTrue,
      reason: 'Expected either loading indicator or error icon to be present',
    );
  });
}
