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
    // Either loading indicator or error icon should be present
    final hasLoading = find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
    final hasError = find.byIcon(Icons.error_outline).evaluate().isNotEmpty;
    expect(hasLoading || hasError, isTrue);
  });
}
