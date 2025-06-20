import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class LayeredCurvesPainter extends AnimatedCanvasPainter {
  LayeredCurvesPainter({
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
    
    for (int layer = 0; layer < colors.length; layer++) {
      final layerTime = time + layer * 0.5;
      final amplitude = (60 + layer * 20) * intensity;
      final frequency = 1.5 + layer * 0.3;
      final verticalOffset = size.height * (0.5 + layer * 0.1);
      
      final path = Path();
      path.moveTo(0, size.height);
      
      for (double x = 0; x <= size.width; x += 3) {
        final y = verticalOffset + 
                  math.sin((x / size.width) * frequency * math.pi + layerTime) * amplitude;
        path.lineTo(x, y);
      }
      
      path.lineTo(size.width, size.height);
      path.close();
      
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors[layer].withValues(alpha: 0.7 * opacity),
          colors[layer].withValues(alpha: 0.2 * opacity),
        ],
      );
      
      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;
      
      if (enableGlow) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
      }
      
      canvas.drawPath(path, paint);
    }
  }
}