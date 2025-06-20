import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class RadialBurstPainter extends AnimatedCanvasPainter {
  RadialBurstPainter({
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
    final maxRadius = math.max(size.width, size.height) * 0.7;
    
    // Number of rays
    final rayCount = 12 + colors.length * 2;
    
    for (int i = 0; i < rayCount; i++) {
      final angle = (i / rayCount) * 2 * math.pi + time * 0.1;
      final colorIndex = i % colors.length;
      
      // Create ray path
      final path = Path();
      final rayWidth = (10 + i % 8) * intensity;
      final rayLength = maxRadius * (0.8 + math.sin(time + i * 0.5) * 0.2);
      
      // Ray vertices
      final tipX = center.dx + rayLength * math.cos(angle);
      final tipY = center.dy + rayLength * math.sin(angle);
      
      final baseWidth = rayWidth * 0.3;
      final baseLeft = center + Offset(
        baseWidth * math.cos(angle + math.pi / 2),
        baseWidth * math.sin(angle + math.pi / 2),
      );
      final baseRight = center + Offset(
        baseWidth * math.cos(angle - math.pi / 2),
        baseWidth * math.sin(angle - math.pi / 2),
      );
      
      path.moveTo(tipX, tipY);
      path.lineTo(baseLeft.dx, baseLeft.dy);
      path.lineTo(baseRight.dx, baseRight.dy);
      path.close();
      
      // Create gradient for ray
      final gradient = LinearGradient(
        begin: Alignment.center,
        end: Alignment(math.cos(angle), math.sin(angle)),
        colors: [
          colors[colorIndex].withValues(alpha: 0.1 * opacity),
          colors[colorIndex].withValues(alpha: 0.8 * opacity),
          colors[colorIndex].withValues(alpha: 0.3 * opacity),
        ],
        stops: const [0.0, 0.7, 1.0],
      );
      
      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;
      
      if (enableGlow) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
      }
      
      canvas.drawPath(path, paint);
    }
    
    // Draw center glow
    final centerPaint = createPaint(
      colors[0].withValues(alpha: 0.9 * opacity),
      withGlow: enableGlow,
    );
    canvas.drawCircle(center, 20 * intensity, centerPaint);
  }
}