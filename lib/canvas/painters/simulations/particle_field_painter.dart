import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class ParticleFieldPainter extends AnimatedCanvasPainter {
  ParticleFieldPainter({
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
    final particleCount = 100 + colors.length * 20;
    
    for (int i = 0; i < particleCount; i++) {
      final particleTime = time + i * 0.1;
      final baseX = (i * 47.3) % size.width;
      final baseY = (i * 73.7) % size.height;
      
      final x = baseX + math.sin(particleTime + i * 0.02) * 30 * intensity;
      final y = baseY + math.cos(particleTime * 1.3 + i * 0.03) * 20 * intensity;
      final particleSize = (2 + i % 6) * intensity;
      final colorIndex = i % colors.length;
      
      final paint = createPaint(
        colors[colorIndex].withValues(alpha: 0.8 * opacity),
        withGlow: enableGlow,
      );
      
      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }
  }
}