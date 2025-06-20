import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class NoiseFieldPainter extends AnimatedCanvasPainter {
  NoiseFieldPainter({
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
    final noiseScale = 20 * intensity;
    final rows = (size.height / noiseScale).ceil();
    final cols = (size.width / noiseScale).ceil();
    
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final x = col * noiseScale;
        final y = row * noiseScale;
        
        // Generate noise value
        final noiseValue = _noise(x * 0.01, y * 0.01, time * 0.5);
        final normalizedNoise = (noiseValue + 1) / 2; // Normalize to 0-1
        
        if (normalizedNoise > 0.3) {
          final colorIndex = ((normalizedNoise * colors.length).floor()).clamp(0, colors.length - 1);
          final alpha = normalizedNoise * opacity;
          
          final paint = createPaint(
            colors[colorIndex].withValues(alpha: alpha),
            withGlow: enableGlow,
          );
          
          final cellSize = noiseScale * normalizedNoise;
          canvas.drawRect(
            Rect.fromLTWH(x, y, cellSize, cellSize),
            paint,
          );
        }
      }
    }
  }
  
  double _noise(double x, double y, double z) {
    // Simple 3D noise function
    final n = math.sin(x * 12.9898 + y * 78.233 + z * 37.719) * 43758.5453;
    return 2.0 * (n - n.floor()) - 1.0;
  }
}