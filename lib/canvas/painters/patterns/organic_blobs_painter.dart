import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class OrganicBlobsPainter extends AnimatedCanvasPainter {
  OrganicBlobsPainter({
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
    final blobCount = 8 + colors.length;
    
    for (int i = 0; i < blobCount; i++) {
      final blobTime = time + i * 0.7;
      final x = (i * 127.3) % size.width;
      final y = (i * 89.1) % size.height;
      final blobSize = (40 + i * 8) * intensity;
      final colorIndex = i % colors.length;
      
      final paint = createPaint(
        colors[colorIndex].withValues(alpha: 0.6 * opacity),
        withGlow: enableGlow,
      );
      
      final path = Path();
      final segments = 8;
      
      for (int s = 0; s < segments; s++) {
        final angle = (s / segments) * 2 * math.pi;
        final distortion = 1.0 + math.sin(blobTime * 2 + s) * 0.4;
        final radius = blobSize * distortion;
        
        final px = x + radius * math.cos(angle);
        final py = y + radius * math.sin(angle);
        
        if (s == 0) {
          path.moveTo(px, py);
        } else {
          path.lineTo(px, py);
        }
      }
      path.close();
      
      canvas.drawPath(path, paint);
    }
  }
}