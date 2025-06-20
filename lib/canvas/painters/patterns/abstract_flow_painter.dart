import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class AbstractFlowPainter extends AnimatedCanvasPainter {
  AbstractFlowPainter({
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
    final flowCount = colors.length + 3;
    
    for (int flow = 0; flow < flowCount; flow++) {
      final flowTime = time + flow * 0.8;
      final colorIndex = flow % colors.length;
      
      final path = Path();
      path.moveTo(0, size.height * (0.3 + flow * 0.15));
      
      final controlPoints = <Offset>[];
      for (int point = 0; point <= 10; point++) {
        final x = (point / 10) * size.width;
        final y = size.height * (0.3 + flow * 0.15) + 
                  math.sin(flowTime + point * 0.5) * 80 * intensity +
                  math.cos(flowTime * 1.3 + point * 0.3) * 40 * intensity;
        controlPoints.add(Offset(x, y));
      }
      
      for (int i = 1; i < controlPoints.length; i++) {
        final current = controlPoints[i];
        final previous = controlPoints[i - 1];
        final controlPoint = Offset(
          (current.dx + previous.dx) / 2,
          previous.dy,
        );
        path.quadraticBezierTo(previous.dx, previous.dy, controlPoint.dx, controlPoint.dy);
      }
      
      final gradient = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          colors[colorIndex].withValues(alpha: 0.1 * opacity),
          colors[colorIndex].withValues(alpha: 0.8 * opacity),
          colors[colorIndex].withValues(alpha: 0.1 * opacity),
        ],
      );
      
      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.stroke
        ..strokeWidth = (15 + flow * 5) * intensity;
      
      if (enableGlow) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
      }
      
      canvas.drawPath(path, paint);
    }
  }
}