import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class FractalTreePainter extends AnimatedCanvasPainter {
  FractalTreePainter({
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
    final startX = size.width / 2;
    final startY = size.height;
    final trunkLength = 100 * intensity;
    final windEffect = math.sin(time) * 0.1;
    
    _drawBranch(
      canvas,
      Offset(startX, startY),
      -math.pi / 2 + windEffect, // Start pointing up with wind
      trunkLength,
      8, // depth
      0, // current depth
      time,
    );
  }
  
  void _drawBranch(Canvas canvas, Offset start, double angle, double length, int maxDepth, int currentDepth, double time) {
    if (currentDepth >= maxDepth || length < 2) return;
    
    final colorIndex = (currentDepth * colors.length / maxDepth).floor().clamp(0, colors.length - 1);
    final windSway = math.sin(time + currentDepth * 0.5) * 0.05;
    final adjustedAngle = angle + windSway;
    
    final endX = start.dx + length * math.cos(adjustedAngle);
    final endY = start.dy + length * math.sin(adjustedAngle);
    final end = Offset(endX, endY);
    
    final strokeWidth = ((maxDepth - currentDepth) * 2 * intensity).clamp(1.0, 20.0);
    final branchAlpha = (1.0 - currentDepth / maxDepth) * opacity;
    
    final paint = Paint()
      ..color = colors[colorIndex].withValues(alpha: branchAlpha)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    
    if (enableGlow) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius * (1 - currentDepth / maxDepth));
    }
    
    canvas.drawLine(start, end, paint);
    
    if (currentDepth < maxDepth - 1) {
      // Draw left branch
      _drawBranch(
        canvas,
        end,
        adjustedAngle - 0.4 - math.sin(time * 2 + currentDepth) * 0.2,
        length * 0.7,
        maxDepth,
        currentDepth + 1,
        time,
      );
      
      // Draw right branch
      _drawBranch(
        canvas,
        end,
        adjustedAngle + 0.4 + math.cos(time * 1.5 + currentDepth) * 0.2,
        length * 0.7,
        maxDepth,
        currentDepth + 1,
        time,
      );
    } else {
      // Draw leaves at the end
      final leafPaint = createPaint(
        colors[(colorIndex + 1) % colors.length].withValues(alpha: 0.8 * opacity),
        withGlow: enableGlow,
      );
      final leafSize = 3 * intensity;
      canvas.drawCircle(end, leafSize, leafPaint);
    }
  }
}