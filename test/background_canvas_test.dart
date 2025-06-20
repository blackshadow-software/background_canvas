import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:background_canvas/background_canvas.dart';

void main() {
  group('BackgroundCanvas Tests', () {
    testWidgets('BackgroundCanvasWidget can be created', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BackgroundCanvasWidget(
          colors: const [Colors.blue, Colors.purple],
          type: BackgroundCanvasType.fluidWaves,
          animated: false,
        ),
      ));

      expect(find.byType(BackgroundCanvasWidget), findsOneWidget);
    });

    testWidgets('All BackgroundCanvasType values work', (WidgetTester tester) async {
      for (final type in BackgroundCanvasType.values) {
        await tester.pumpWidget(MaterialApp(
          home: BackgroundCanvasWidget(
            colors: const [Colors.red, Colors.green],
            type: type,
            animated: false,
          ),
        ));
        await tester.pump();
        expect(find.byType(BackgroundCanvasWidget), findsOneWidget);
      }
    });

    testWidgets('Animation and customization works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BackgroundCanvasWidget(
          colors: const [Colors.orange, Colors.yellow],
          type: BackgroundCanvasType.organicBlobs,
          animated: true,
          intensity: 1.5,
          speed: 2.0,
          opacity: 0.8,
          enableGlow: true,
          glowRadius: 15.0,
        ),
      ));

      expect(find.byType(BackgroundCanvasWidget), findsOneWidget);
      await tester.pump();
    });

    test('Color schemes are accessible', () {
      expect(BackgroundCanvasColorSchemes.oceanBlue, isNotEmpty);
      expect(BackgroundCanvasColorSchemes.sunsetGradient, isNotEmpty);
      expect(BackgroundCanvasColorSchemes.allPresets, isNotEmpty);
    });

    test('Color generation functions work', () {
      final complementary = BackgroundCanvasColorSchemes.complementaryScheme(Colors.blue);
      expect(complementary, isNotEmpty);
      expect(complementary.length, greaterThan(1));

      final analogous = BackgroundCanvasColorSchemes.analogousScheme(Colors.red, variations: 3);
      expect(analogous.length, equals(4)); // base + 3 variations

      final monochromatic = BackgroundCanvasColorSchemes.monochromaticScheme(Colors.green);
      expect(monochromatic, isNotEmpty);
    });
  });
}
