import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class FluidWavesPainter extends AnimatedCanvasPainter {
  FluidWavesPainter({
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
    final numWaves = 3 + (colors.length - 1);
    
    for (int i = 0; i < numWaves; i++) {
      final progress = i / numWaves;
      final colorIndex = (i * colors.length / numWaves).floor().clamp(0, colors.length - 1);
      final nextColorIndex = ((i + 1) * colors.length / numWaves).floor().clamp(0, colors.length - 1);
      
      final gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          colors[colorIndex].withValues(alpha: (0.8 - progress * 0.4) * opacity),
          colors[nextColorIndex].withValues(alpha: (0.6 - progress * 0.3) * opacity),
        ],
      );
      
      final paint = createPaint(colors[colorIndex], withGlow: enableGlow);
      paint.shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      
      final path = Path();
      final waveHeight = size.height * (0.3 + progress * 0.4) * intensity;
      final frequency = 2 + i * 0.5;
      final phase = time + i * math.pi / 3;
      
      path.moveTo(0, size.height);
      
      for (double x = 0; x <= size.width; x += 2) {
        final y = size.height - waveHeight + 
                  math.sin((x / size.width) * frequency * math.pi + phase) * 
                  waveHeight * 0.3 * intensity;
        path.lineTo(x, y);
      }
      
      path.lineTo(size.width, size.height);
      path.close();
      
      canvas.drawPath(path, paint);
    }
  }
}