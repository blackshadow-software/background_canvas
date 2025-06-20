import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class FlowingLayersPainter extends AnimatedCanvasPainter {
  FlowingLayersPainter({
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
    
    for (int layer = 0; layer < colors.length + 2; layer++) {
      final layerTime = time + layer * 0.3;
      final amplitude = (30 + layer * 20) * intensity;
      final frequency = 1.5 + layer * 0.3;
      final verticalOffset = size.height * (0.2 + layer * 0.15);
      
      final path = Path();
      path.moveTo(0, size.height);
      
      // Create flowing wave
      for (double x = 0; x <= size.width; x += 3) {
        final wave1 = math.sin((x / size.width) * frequency * math.pi + layerTime);
        final wave2 = math.sin((x / size.width) * frequency * 2 * math.pi + layerTime * 1.3);
        final wave3 = math.sin((x / size.width) * frequency * 0.7 * math.pi + layerTime * 0.8);
        
        final y = verticalOffset + 
                  (wave1 * amplitude * 0.5) + 
                  (wave2 * amplitude * 0.3) + 
                  (wave3 * amplitude * 0.2);
        
        path.lineTo(x, y);
      }
      
      path.lineTo(size.width, size.height);
      path.close();
      
      // Create depth gradient
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors[layer % colors.length].withValues(alpha: 0.8 * opacity),
          colors[layer % colors.length].withValues(alpha: 0.4 * opacity),
          colors[layer % colors.length].withValues(alpha: 0.1 * opacity),
        ],
      );
      
      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;
      
      if (enableGlow) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius * (1 - layer * 0.1));
      }
      
      canvas.drawPath(path, paint);
    }
  }
}