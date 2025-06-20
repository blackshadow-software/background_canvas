import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class LiquidMetalPainter extends AnimatedCanvasPainter {
  LiquidMetalPainter({
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
    final dropCount = 6 + colors.length;
    
    for (int i = 0; i < dropCount; i++) {
      final dropTime = time + i * 0.6;
      final x = (i * 157.3) % size.width;
      final y = ((i * 97.1) % size.height) + math.sin(dropTime) * 50 * intensity;
      final dropSize = (30 + i * 10) * intensity;
      final colorIndex = i % colors.length;
      
      // Create metallic effect with multiple layers
      for (int layer = 0; layer < 3; layer++) {
        final layerSize = dropSize * (1 - layer * 0.15);
        final layerAlpha = (0.8 - layer * 0.2) * opacity;
        
        final gradient = RadialGradient(
          center: Alignment.topLeft,
          radius: 1.0,
          colors: [
            colors[colorIndex].withValues(alpha: layerAlpha),
            colors[colorIndex].withValues(alpha: layerAlpha * 0.3),
          ],
        );
        
        final paint = Paint()
          ..shader = gradient.createShader(Rect.fromCircle(center: Offset(x, y), radius: layerSize))
          ..style = PaintingStyle.fill;
        
        if (enableGlow && layer == 0) {
          paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
        }
        
        canvas.drawCircle(Offset(x, y), layerSize, paint);
      }
      
      // Add highlights
      final highlightPaint = createPaint(
        Colors.white.withValues(alpha: 0.6 * opacity),
        withGlow: false,
      );
      canvas.drawCircle(Offset(x - dropSize * 0.3, y - dropSize * 0.3), dropSize * 0.2, highlightPaint);
    }
  }
}