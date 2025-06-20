import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class CrystalFormationPainter extends AnimatedCanvasPainter {
  CrystalFormationPainter({
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
    final crystalCount = colors.length + 3;
    
    for (int crystal = 0; crystal < crystalCount; crystal++) {
      final crystalTime = time + crystal * 0.7;
      final angle = (crystal / crystalCount) * 2 * math.pi + crystalTime * 0.1;
      final distance = (80 + crystal * 30) * intensity;
      
      final crystalCenter = center + Offset(
        distance * math.cos(angle),
        distance * math.sin(angle),
      );
      
      _drawCrystal(canvas, crystalCenter, crystal, crystalTime);
    }
  }
  
  void _drawCrystal(Canvas canvas, Offset center, int crystalIndex, double time) {
    final sides = 6 + (crystalIndex % 3);
    final crystalSize = (20 + crystalIndex * 8) * intensity;
    final growth = math.sin(time) * 0.3 + 1.0;
    final colorIndex = crystalIndex % colors.length;
    
    // Draw crystal facets
    for (int layer = 0; layer < 3; layer++) {
      final layerSize = crystalSize * growth * (1 - layer * 0.2);
      final layerAlpha = (0.8 - layer * 0.2) * opacity;
      
      final path = Path();
      for (int i = 0; i < sides; i++) {
        final angle = (i / sides) * 2 * math.pi + time * 0.1;
        final x = center.dx + layerSize * math.cos(angle);
        final y = center.dy + layerSize * math.sin(angle);
        
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      
      final gradient = RadialGradient(
        center: Alignment.center,
        colors: [
          colors[colorIndex].withValues(alpha: layerAlpha),
          colors[colorIndex].withValues(alpha: layerAlpha * 0.3),
        ],
      );
      
      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: layerSize))
        ..style = PaintingStyle.fill;
      
      if (enableGlow && layer == 0) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
      }
      
      canvas.drawPath(path, paint);
    }
    
    // Draw crystal lines
    final linePaint = Paint()
      ..color = colors[colorIndex].withValues(alpha: 0.6 * opacity)
      ..strokeWidth = 1 * intensity
      ..style = PaintingStyle.stroke;
    
    for (int i = 0; i < sides; i++) {
      final angle = (i / sides) * 2 * math.pi + time * 0.1;
      final x = center.dx + crystalSize * growth * math.cos(angle);
      final y = center.dy + crystalSize * growth * math.sin(angle);
      
      canvas.drawLine(center, Offset(x, y), linePaint);
    }
  }
}