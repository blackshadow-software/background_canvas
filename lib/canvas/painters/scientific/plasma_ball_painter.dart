import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class PlasmaBallPainter extends AnimatedCanvasPainter {
  PlasmaBallPainter({
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
    final plasmaRadius = math.min(size.width, size.height) * 0.3 * intensity;
    
    // Draw plasma core
    final coreGradient = RadialGradient(
      center: Alignment.center,
      colors: [
        colors[0].withValues(alpha: 0.9 * opacity),
        colors[1 % colors.length].withValues(alpha: 0.3 * opacity),
      ],
    );
    
    final corePaint = Paint()
      ..shader = coreGradient.createShader(Rect.fromCircle(center: center, radius: plasmaRadius))
      ..style = PaintingStyle.fill;
    
    if (enableGlow) {
      corePaint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
    }
    
    canvas.drawCircle(center, plasmaRadius, corePaint);
    
    // Draw plasma bolts
    final boltCount = 8 + colors.length;
    for (int bolt = 0; bolt < boltCount; bolt++) {
      final boltTime = time + bolt * 0.3;
      final boltAngle = (bolt / boltCount) * 2 * math.pi + boltTime * 0.2;
      final boltLength = plasmaRadius * (0.8 + math.sin(boltTime * 3) * 0.4);
      
      _drawPlasmaBolt(canvas, center, boltAngle, boltLength, bolt, boltTime);
    }
  }
  
  void _drawPlasmaBolt(Canvas canvas, Offset center, double angle, double length, int boltIndex, double time) {
    final colorIndex = boltIndex % colors.length;
    final segments = 8;
    final path = Path();
    
    path.moveTo(center.dx, center.dy);
    
    for (int segment = 1; segment <= segments; segment++) {
      final segmentProgress = segment / segments;
      final baseX = center.dx + length * segmentProgress * math.cos(angle);
      final baseY = center.dy + length * segmentProgress * math.sin(angle);
      
      // Add randomness to create bolt effect
      final randomness = math.sin(time * 5 + segment + boltIndex) * 15 * intensity;
      final perpAngle = angle + math.pi / 2;
      final x = baseX + randomness * math.cos(perpAngle);
      final y = baseY + randomness * math.sin(perpAngle);
      
      path.lineTo(x, y);
    }
    
    final boltPaint = Paint()
      ..color = colors[colorIndex].withValues(alpha: 0.8 * opacity)
      ..strokeWidth = (3 + math.sin(time * 4) * 2) * intensity
      ..style = PaintingStyle.stroke;
    
    if (enableGlow) {
      boltPaint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius * 0.5);
    }
    
    canvas.drawPath(path, boltPaint);
  }
}