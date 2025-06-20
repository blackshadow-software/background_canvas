import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'base_painter.dart';

class SpiralGalaxyPainter extends AnimatedCanvasPainter {
  SpiralGalaxyPainter({
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
    final spiralCount = colors.length;
    
    for (int spiral = 0; spiral < spiralCount; spiral++) {
      final spiralOffset = (spiral / spiralCount) * 2 * math.pi;
      final colorIndex = spiral % colors.length;
      
      final path = Path();
      bool firstPoint = true;
      
      for (double t = 0; t <= 10; t += 0.1) {
        final angle = t + time * 0.2 + spiralOffset;
        final radius = t * 15 * intensity;
        final x = center.dx + radius * math.cos(angle);
        final y = center.dy + radius * math.sin(angle);
        
        if (firstPoint) {
          path.moveTo(x, y);
          firstPoint = false;
        } else {
          path.lineTo(x, y);
        }
      }
      
      final paint = Paint()
        ..color = colors[colorIndex].withValues(alpha: 0.7 * opacity)
        ..strokeWidth = (8 - spiral * 1.5) * intensity
        ..style = PaintingStyle.stroke;
      
      if (enableGlow) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
      }
      
      canvas.drawPath(path, paint);
      
      // Draw stars along the spiral
      for (double t = 0; t <= 10; t += 0.5) {
        final angle = t + time * 0.2 + spiralOffset;
        final radius = t * 15 * intensity;
        final x = center.dx + radius * math.cos(angle);
        final y = center.dy + radius * math.sin(angle);
        
        final starPaint = createPaint(
          colors[colorIndex].withValues(alpha: 0.8 * opacity),
          withGlow: enableGlow,
        );
        
        final starSize = (2 + t * 0.3) * intensity;
        canvas.drawCircle(Offset(x, y), starSize, starPaint);
      }
    }
    
    // Draw central bulge
    final bulgePaint = createPaint(
      colors[0].withValues(alpha: 0.9 * opacity),
      withGlow: enableGlow,
    );
    canvas.drawCircle(center, 20 * intensity, bulgePaint);
  }
}

class LiquidMetalPainter extends AnimatedCanvasPainter {
  LiquidMetalPainter({
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
    final dropCount = 6 + colors.length;
    
    for (int i = 0; i < dropCount; i++) {
      final dropTime = time + i * 0.6;
      final x = (i * 157.3) % size.width;
      final y = ((i * 97.1) % size.height) + math.sin(dropTime) * 50 * intensity;
      final dropSize = (30 + i * 10) * intensity;
      final colorIndex = i % colors.length;
      
      // Create metallic effect with multiple layers
      for (int layer = 0; layer < 3; layer++) {
        final layerSize = dropSize * (1 - layer * 0.15);
        final layerAlpha = (0.8 - layer * 0.2) * opacity;
        
        final gradient = RadialGradient(
          center: Alignment.topLeft,
          radius: 1.0,
          colors: [
            colors[colorIndex].withValues(alpha: layerAlpha),
            colors[colorIndex].withValues(alpha: layerAlpha * 0.3),
          ],
        );
        
        final paint = Paint()
          ..shader = gradient.createShader(Rect.fromCircle(center: Offset(x, y), radius: layerSize))
          ..style = PaintingStyle.fill;
        
        if (enableGlow && layer == 0) {
          paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
        }
        
        canvas.drawCircle(Offset(x, y), layerSize, paint);
      }
      
      // Add highlights
      final highlightPaint = createPaint(
        Colors.white.withValues(alpha: 0.6 * opacity),
        withGlow: false,
      );
      canvas.drawCircle(Offset(x - dropSize * 0.3, y - dropSize * 0.3), dropSize * 0.2, highlightPaint);
    }
  }
}

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