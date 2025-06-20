// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:background_canvas/background_canvas.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('BackgroundCanvasWidget test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BackgroundCanvasWidget(
        colors: const [
          Color(0xFF667eea),
          Color(0xFF764ba2),
        ],
        type: BackgroundCanvasType.fluidWaves,
        animated: false,
        child: const Text('Test'),
      ),
    ));

    expect(find.text('Test'), findsOneWidget);
    await tester.pump();
  });

  testWidgets('BackgroundCanvasWidget types test', (WidgetTester tester) async {
    for (final type in BackgroundCanvasType.values) {
      await tester.pumpWidget(MaterialApp(
        home: BackgroundCanvasWidget(
          colors: const [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
          type: type,
          animated: false,
        ),
      ));
      await tester.pump();
    }
  });
}
