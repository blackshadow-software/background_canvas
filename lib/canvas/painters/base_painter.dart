import 'dart:math' as math;
import 'package:flutter/material.dart';

abstract class AnimatedCanvasPainter extends CustomPainter {
  final List<Color> colors;
  final Animation<double> animation;
  final double intensity;
  final double opacity;
  final bool enableGlow;
  final double glowRadius;

  AnimatedCanvasPainter({
    required this.colors,
    required this.animation,
    required this.intensity,
    this.opacity = 1.0,
    this.enableGlow = false,
    this.glowRadius = 10.0,
  }) : super(repaint: animation);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  Paint createPaint(Color color, {bool withGlow = false}) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = color.withValues(alpha: color.a * opacity);
    
    if (enableGlow && withGlow) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
    }
    
    return paint;
  }
}

// Extension to normalize offset vectors
extension OffsetExtension on Offset {
  Offset normalizeOffset() {
    final length = distance;
    if (length == 0) return const Offset(0, 1);
    return Offset(dx / length, dy / length);
  }
}