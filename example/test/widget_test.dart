// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:background_canvas/background_canvas.dart';

import 'package:background_canvas_example/main.dart';

void main() {
  testWidgets('BackgroundCanvas Demo loads', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    
    await tester.pumpWidget(const MyApp());

    expect(find.text('Background Canvas Demo'), findsOneWidget);
    expect(find.text('Choose a preset:'), findsOneWidget);
    expect(find.text('Ocean Waves'), findsOneWidget);
    
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });

  testWidgets('BackgroundCanvasWidget renders without error', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BackgroundCanvasWidget(
        colors: const [
          Color(0xFF667eea),
          Color(0xFF764ba2),
        ],
        type: BackgroundCanvasType.fluidWaves,
        animated: false,
        child: const Text('Test Child'),
      ),
    ));

    expect(find.text('Test Child'), findsOneWidget);
    await tester.pump();
  });

  testWidgets('All BackgroundCanvasType variants work', (WidgetTester tester) async {
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
