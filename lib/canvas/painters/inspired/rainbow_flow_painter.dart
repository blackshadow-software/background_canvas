import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class RainbowFlowPainter extends AnimatedCanvasPainter {
  RainbowFlowPainter({
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
    
    // Create flowing rainbow bands
    for (int band = 0; band < colors.length; band++) {
      final bandTime = time + band * 0.5;
      final bandHeight = size.height / colors.length;
      final yOffset = band * bandHeight;
      
      final path = Path();
      path.moveTo(0, yOffset + bandHeight);
      
      // Create curved flow
      for (double x = 0; x <= size.width; x += 2) {
        final wave = math.sin((x / size.width) * 3 * math.pi + bandTime) * 30 * intensity;
        final flow = math.sin((x / size.width) * 1.5 * math.pi + bandTime * 0.7) * 20 * intensity;
        
        final y = yOffset + wave + flow;
        path.lineTo(x, y);
      }
      
      // Close the band
      path.lineTo(size.width, yOffset + bandHeight + 50);
      path.lineTo(0, yOffset + bandHeight + 50);
      path.close();
      
      final gradient = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          colors[band].withValues(alpha: 0.3 * opacity),
          colors[band].withValues(alpha: 0.8 * opacity),
          colors[band].withValues(alpha: 0.3 * opacity),
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