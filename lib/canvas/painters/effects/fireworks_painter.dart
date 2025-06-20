import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class FireworksPainter extends AnimatedCanvasPainter {
  FireworksPainter({
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
    final fireworkCount = 5 + colors.length;
    
    for (int i = 0; i < fireworkCount; i++) {
      final lifecycle = (time + i * 2) % (2 * math.pi);
      final explosionPhase = math.sin(lifecycle * 0.5);
      
      if (explosionPhase > 0) {
        final centerX = (i * 137.5) % size.width; // Golden ratio distribution
        final centerY = (i * 71.3) % size.height;
        final center = Offset(centerX, centerY);
        
        final particleCount = 20 + (i % 10);
        final radius = explosionPhase * 100 * intensity;
        
        for (int p = 0; p < particleCount; p++) {
          final angle = (p / particleCount) * 2 * math.pi;
          final particleRadius = radius * (0.8 + (p % 3) * 0.1);
          final fade = 1.0 - explosionPhase;
          
          final x = center.dx + particleRadius * math.cos(angle);
          final y = center.dy + particleRadius * math.sin(angle) + explosionPhase * 30; // Gravity effect
          
          final colorIndex = (i + p ~/ 5) % colors.length;
          final paint = createPaint(
            colors[colorIndex].withValues(alpha: fade * opacity),
            withGlow: enableGlow,
          );
          
          final sparkSize = (3 + p % 4) * intensity * fade;
          canvas.drawCircle(Offset(x, y), sparkSize, paint);
        }
      }
    }
  }
}