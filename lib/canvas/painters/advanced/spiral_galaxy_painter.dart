import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class SpiralGalaxyPainter extends AnimatedCanvasPainter {
  SpiralGalaxyPainter({
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
    final spiralCount = colors.length;
    
    for (int spiral = 0; spiral < spiralCount; spiral++) {
      final spiralOffset = (spiral / spiralCount) * 2 * math.pi;
      final colorIndex = spiral % colors.length;
      
      final path = Path();
      bool firstPoint = true;
      
      for (double t = 0; t <= 10; t += 0.1) {
        final angle = t + time * 0.2 + spiralOffset;
        final radius = t * 15 * intensity;
        final x = center.dx + radius * math.cos(angle);
        final y = center.dy + radius * math.sin(angle);
        
        if (firstPoint) {
          path.moveTo(x, y);
          firstPoint = false;
        } else {
          path.lineTo(x, y);
        }
      }
      
      final paint = Paint()
        ..color = colors[colorIndex].withValues(alpha: 0.7 * opacity)
        ..strokeWidth = (8 - spiral * 1.5) * intensity
        ..style = PaintingStyle.stroke;
      
      if (enableGlow) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
      }
      
      canvas.drawPath(path, paint);
      
      // Draw stars along the spiral
      for (double t = 0; t <= 10; t += 0.5) {
        final angle = t + time * 0.2 + spiralOffset;
        final radius = t * 15 * intensity;
        final x = center.dx + radius * math.cos(angle);
        final y = center.dy + radius * math.sin(angle);
        
        final starPaint = createPaint(
          colors[colorIndex].withValues(alpha: 0.8 * opacity),
          withGlow: enableGlow,
        );
        
        final starSize = (2 + t * 0.3) * intensity;
        canvas.drawCircle(Offset(x, y), starSize, starPaint);
      }
    }
    
    // Draw central bulge
    final bulgePaint = createPaint(
      colors[0].withValues(alpha: 0.9 * opacity),
      withGlow: enableGlow,
    );
    canvas.drawCircle(center, 20 * intensity, bulgePaint);
  }
}