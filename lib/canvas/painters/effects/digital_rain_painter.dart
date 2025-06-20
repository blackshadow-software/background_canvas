import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

class DigitalRainPainter extends AnimatedCanvasPainter {
  DigitalRainPainter({
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
    final columnCount = (size.width / (15 * intensity)).floor();
    
    for (int col = 0; col < columnCount; col++) {
      final x = col * 15 * intensity;
      final columnTime = time + col * 0.1;
      final dropletCount = (size.height / (20 * intensity)).floor();
      
      for (int row = 0; row < dropletCount; row++) {
        final y = (row * 20 * intensity + columnTime * 100) % (size.height + 100);
        final fadeOut = 1.0 - (row / dropletCount) * 0.8;
        
        // Generate random character-like shape
        final charCode = ((col + row + columnTime) * 123.456).floor() % 10;
        final colorIndex = col % colors.length;
        
        final paint = createPaint(
          colors[colorIndex].withValues(alpha: fadeOut * opacity),
          withGlow: enableGlow,
        );
        
        // Draw character
        final charSize = 10 * intensity;
        _drawDigitalChar(canvas, Offset(x, y), charSize, charCode, paint);
      }
    }
  }
  
  void _drawDigitalChar(Canvas canvas, Offset position, double size, int charCode, Paint paint) {
    final path = Path();
    
    // Generate simple digital patterns based on charCode
    switch (charCode % 6) {
      case 0: // Vertical line
        path.moveTo(position.dx, position.dy);
        path.lineTo(position.dx, position.dy + size);
        break;
      case 1: // Horizontal line
        path.moveTo(position.dx, position.dy);
        path.lineTo(position.dx + size, position.dy);
        break;
      case 2: // Cross
        path.moveTo(position.dx, position.dy);
        path.lineTo(position.dx + size, position.dy + size);
        path.moveTo(position.dx + size, position.dy);
        path.lineTo(position.dx, position.dy + size);
        break;
      case 3: // Circle
        canvas.drawCircle(position, size * 0.5, paint);
        return;
      case 4: // Square
        canvas.drawRect(Rect.fromCenter(center: position, width: size, height: size), paint);
        return;
      case 5: // Triangle
        path.moveTo(position.dx, position.dy + size);
        path.lineTo(position.dx + size * 0.5, position.dy);
        path.lineTo(position.dx + size, position.dy + size);
        path.close();
        break;
    }
    
    final strokePaint = Paint()
      ..color = paint.color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    if (paint.maskFilter != null) {
      strokePaint.maskFilter = paint.maskFilter;
    }
    
    canvas.drawPath(path, strokePaint);
  }
}