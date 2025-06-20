import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class RadialSunsetPainter extends AnimatedCanvasPainter {
  RadialSunsetPainter({
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
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.max(size.width, size.height) * 0.8;
    
    // Create multiple radial layers
    for (int ring = 0; ring < 8; ring++) {
      final radius = maxRadius * (ring + 1) / 8;
      final pulse = math.sin(time * 0.5 + ring * 0.3) * 0.1 + 1.0;
      final adjustedRadius = radius * pulse * intensity;
      
      final colorIndex = ring % colors.length;
      final nextColorIndex = (ring + 1) % colors.length;
      
      final gradient = RadialGradient(
        center: Alignment.center,
        radius: 0.8,
        colors: [
          colors[colorIndex].withValues(alpha: (0.8 - ring * 0.1) * opacity),
          colors[nextColorIndex].withValues(alpha: (0.4 - ring * 0.05) * opacity),
        ],
      );
      
      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: adjustedRadius))
        ..style = PaintingStyle.fill;
      
      if (enableGlow) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius * (1 - ring * 0.1));
      }
      
      canvas.drawCircle(center, adjustedRadius, paint);
    }
  }
}