import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class GeometricShapesPainter extends AnimatedCanvasPainter {
  GeometricShapesPainter({
    required super.colors,
    required super.animation,
    required super.intensity,
    super.opacity,
    super.enableGlow,
    super.glowRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final time = animation.value * 2 * math.pi;
    final shapeCount = 15 + colors.length * 2;
    
    for (int i = 0; i < shapeCount; i++) {
      final shapeTime = time + i * 0.3;
      final x = (i * 73.5) % size.width;
      final y = ((i * 37.2) % size.height);
      final shapeSize = (20 + i % 30) * intensity;
      final rotation = shapeTime + i * 0.5;
      final colorIndex = i % colors.length;
      
      final paint = createPaint(
        colors[colorIndex].withValues(alpha: 0.7 * opacity),
        withGlow: enableGlow,
      );
      
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      
      switch (i % 4) {
        case 0: // Rectangle
          canvas.drawRect(
            Rect.fromCenter(center: Offset.zero, width: shapeSize, height: shapeSize * 0.7),
            paint,
          );
          break;
        case 1: // Circle
          canvas.drawCircle(Offset.zero, shapeSize * 0.5, paint);
          break;
        case 2: // Triangle
          final path = Path();
          path.moveTo(0, -shapeSize * 0.5);
          path.lineTo(-shapeSize * 0.4, shapeSize * 0.3);
          path.lineTo(shapeSize * 0.4, shapeSize * 0.3);
          path.close();
          canvas.drawPath(path, paint);
          break;
        case 3: // Diamond
          final path = Path();
          path.moveTo(0, -shapeSize * 0.5);
          path.lineTo(shapeSize * 0.3, 0);
          path.lineTo(0, shapeSize * 0.5);
          path.lineTo(-shapeSize * 0.3, 0);
          path.close();
          canvas.drawPath(path, paint);
          break;
      }
      
      canvas.restore();
    }
  }
}