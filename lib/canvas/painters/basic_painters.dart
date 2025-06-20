import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'base_painter.dart';

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

class GeometricShapesPainter extends AnimatedCanvasPainter {
  GeometricShapesPainter({
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
    final shapeCount = 15 + colors.length * 2;
    
    for (int i = 0; i < shapeCount; i++) {
      final shapeTime = time + i * 0.3;
      final x = (i * 73.5) % size.width;
      final y = ((i * 37.2) % size.height);
      final shapeSize = (20 + i % 30) * intensity;
      final rotation = shapeTime + i * 0.5;
      final colorIndex = i % colors.length;
      
      final paint = createPaint(
        colors[colorIndex].withValues(alpha: 0.7 * opacity),
        withGlow: enableGlow,
      );
      
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      
      switch (i % 4) {
        case 0: // Rectangle
          canvas.drawRect(
            Rect.fromCenter(center: Offset.zero, width: shapeSize, height: shapeSize * 0.7),
            paint,
          );
          break;
        case 1: // Circle
          canvas.drawCircle(Offset.zero, shapeSize * 0.5, paint);
          break;
        case 2: // Triangle
          final path = Path();
          path.moveTo(0, -shapeSize * 0.5);
          path.lineTo(-shapeSize * 0.4, shapeSize * 0.3);
          path.lineTo(shapeSize * 0.4, shapeSize * 0.3);
          path.close();
          canvas.drawPath(path, paint);
          break;
        case 3: // Diamond
          final path = Path();
          path.moveTo(0, -shapeSize * 0.5);
          path.lineTo(shapeSize * 0.3, 0);
          path.lineTo(0, shapeSize * 0.5);
          path.lineTo(-shapeSize * 0.3, 0);
          path.close();
          canvas.drawPath(path, paint);
          break;
      }
      
      canvas.restore();
    }
  }
}

class OrganicBlobsPainter extends AnimatedCanvasPainter {
  OrganicBlobsPainter({
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
    final blobCount = 8 + colors.length;
    
    for (int i = 0; i < blobCount; i++) {
      final blobTime = time + i * 0.7;
      final x = (i * 127.3) % size.width;
      final y = (i * 89.1) % size.height;
      final blobSize = (40 + i * 8) * intensity;
      final colorIndex = i % colors.length;
      
      final paint = createPaint(
        colors[colorIndex].withValues(alpha: 0.6 * opacity),
        withGlow: enableGlow,
      );
      
      final path = Path();
      final segments = 8;
      
      for (int s = 0; s < segments; s++) {
        final angle = (s / segments) * 2 * math.pi;
        final distortion = 1.0 + math.sin(blobTime * 2 + s) * 0.4;
        final radius = blobSize * distortion;
        
        final px = x + radius * math.cos(angle);
        final py = y + radius * math.sin(angle);
        
        if (s == 0) {
          path.moveTo(px, py);
        } else {
          path.lineTo(px, py);
        }
      }
      path.close();
      
      canvas.drawPath(path, paint);
    }
  }
}

class LayeredCurvesPainter extends AnimatedCanvasPainter {
  LayeredCurvesPainter({
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
    
    for (int layer = 0; layer < colors.length; layer++) {
      final layerTime = time + layer * 0.5;
      final amplitude = (60 + layer * 20) * intensity;
      final frequency = 1.5 + layer * 0.3;
      final verticalOffset = size.height * (0.5 + layer * 0.1);
      
      final path = Path();
      path.moveTo(0, size.height);
      
      for (double x = 0; x <= size.width; x += 3) {
        final y = verticalOffset + 
                  math.sin((x / size.width) * frequency * math.pi + layerTime) * amplitude;
        path.lineTo(x, y);
      }
      
      path.lineTo(size.width, size.height);
      path.close();
      
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors[layer].withValues(alpha: 0.7 * opacity),
          colors[layer].withValues(alpha: 0.2 * opacity),
        ],
      );
      
      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;
      
      if (enableGlow) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
      }
      
      canvas.drawPath(path, paint);
    }
  }
}

class ParticleFieldPainter extends AnimatedCanvasPainter {
  ParticleFieldPainter({
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
    final particleCount = 100 + colors.length * 20;
    
    for (int i = 0; i < particleCount; i++) {
      final particleTime = time + i * 0.1;
      final baseX = (i * 47.3) % size.width;
      final baseY = (i * 73.7) % size.height;
      
      final x = baseX + math.sin(particleTime + i * 0.02) * 30 * intensity;
      final y = baseY + math.cos(particleTime * 1.3 + i * 0.03) * 20 * intensity;
      final particleSize = (2 + i % 6) * intensity;
      final colorIndex = i % colors.length;
      
      final paint = createPaint(
        colors[colorIndex].withValues(alpha: 0.8 * opacity),
        withGlow: enableGlow,
      );
      
      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }
  }
}

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