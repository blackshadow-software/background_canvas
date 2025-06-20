import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class AuroraPainter extends AnimatedCanvasPainter {
  AuroraPainter({
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
      final path = Path();
      // Aurora waves layer calculation
      final amplitude = (20 + layer * 15) * intensity;
      final frequency = 2 + layer * 0.5;
      final verticalShift = size.height * (0.3 + layer * 0.1);
      
      path.moveTo(0, verticalShift);
      
      for (double x = 0; x <= size.width; x += 2) {
        final wave1 = math.sin((x / size.width) * frequency * math.pi + time + layer);
        final wave2 = math.sin((x / size.width) * frequency * 2 * math.pi + time * 1.3 + layer);
        final wave3 = math.sin((x / size.width) * frequency * 0.7 * math.pi + time * 0.8 + layer);
        
        final y = verticalShift + 
                  (wave1 * amplitude * 0.5) + 
                  (wave2 * amplitude * 0.3) + 
                  (wave3 * amplitude * 0.2);
        
        path.lineTo(x, y);
      }
      
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors[layer].withValues(alpha: 0.7 * opacity),
          colors[layer].withValues(alpha: 0.1 * opacity),
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