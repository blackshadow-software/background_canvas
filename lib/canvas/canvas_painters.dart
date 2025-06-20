import 'dart:math' as math;
import 'package:flutter/material.dart';

// This file contains all canvas painters organized by categories:
// - Base classes and utilities (lines 5-50)
// - Basic painters (lines 51-500)  
// - Advanced patterns (lines 501-1000)
// - Scientific simulations (lines 1001-1500)
// - Special effects (lines 1501-2000)
// - Image-inspired designs (lines 2001+)

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
    final paint = Paint()..style = PaintingStyle.fill;
    final time = animation.value * 2 * math.pi;
    
    final shapes = List.generate(8 + colors.length, (index) {
      final progress = index / (8 + colors.length);
      final colorIndex = (index * colors.length / (8 + colors.length)).floor().clamp(0, colors.length - 1);
      
      return {
        'color': colors[colorIndex].withValues(alpha: (0.7 - progress * 0.3) * opacity),
        'x': size.width * (0.1 + 0.8 * math.sin(time + index * 0.5)),
        'y': size.height * (0.1 + 0.8 * math.cos(time + index * 0.7)),
        'size': (50 + index * 30) * intensity,
        'rotation': time + index * 0.3,
        'sides': 3 + (index % 5),
      };
    });
    
    for (final shape in shapes) {
      paint.color = shape['color'] as Color;
      canvas.save();
      canvas.translate(shape['x'] as double, shape['y'] as double);
      canvas.rotate(shape['rotation'] as double);
      
      _drawPolygon(
        canvas, 
        paint, 
        shape['sides'] as int, 
        shape['size'] as double
      );
      
      canvas.restore();
    }
  }
  
  void _drawPolygon(Canvas canvas, Paint paint, int sides, double radius) {
    final path = Path();
    final angle = 2 * math.pi / sides;
    
    path.moveTo(radius, 0);
    for (int i = 1; i < sides; i++) {
      final x = radius * math.cos(i * angle);
      final y = radius * math.sin(i * angle);
      path.lineTo(x, y);
    }
    path.close();
    
    canvas.drawPath(path, paint);
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
    final paint = Paint()..style = PaintingStyle.fill;
    final time = animation.value * 2 * math.pi;
    
    final blobs = List.generate(5 + colors.length ~/ 2, (index) {
      final progress = index / (5 + colors.length ~/ 2);
      final colorIndex = (index * colors.length / (5 + colors.length ~/ 2)).floor().clamp(0, colors.length - 1);
      
      return {
        'color': colors[colorIndex].withValues(alpha: (0.6 - progress * 0.2) * opacity),
        'centerX': size.width * (0.2 + 0.6 * math.sin(time * 0.5 + index)),
        'centerY': size.height * (0.2 + 0.6 * math.cos(time * 0.3 + index)),
        'baseRadius': (80 + index * 40) * intensity,
        'phase': index * math.pi / 3,
      };
    });
    
    for (final blob in blobs) {
      paint.color = blob['color'] as Color;
      
      final path = Path();
      final centerX = blob['centerX'] as double;
      final centerY = blob['centerY'] as double;
      final baseRadius = blob['baseRadius'] as double;
      final phase = blob['phase'] as double;
      
      final points = <Offset>[];
      const numPoints = 8;
      
      for (int i = 0; i < numPoints; i++) {
        final angle = (i / numPoints) * 2 * math.pi;
        final radiusVariation = 1 + 0.3 * math.sin(time + phase + angle * 3) * intensity;
        final radius = baseRadius * radiusVariation;
        
        final x = centerX + radius * math.cos(angle);
        final y = centerY + radius * math.sin(angle);
        points.add(Offset(x, y));
      }
      
      if (points.isNotEmpty) {
        path.moveTo(points[0].dx, points[0].dy);
        
        for (int i = 0; i < points.length; i++) {
          final current = points[i];
          final next = points[(i + 1) % points.length];
          final control1 = Offset(
            current.dx + (next.dx - current.dx) * 0.5,
            current.dy,
          );
          final control2 = Offset(
            current.dx + (next.dx - current.dx) * 0.5,
            next.dy,
          );
          
          path.cubicTo(control1.dx, control1.dy, control2.dx, control2.dy, next.dx, next.dy);
        }
        
        path.close();
        canvas.drawPath(path, paint);
      }
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
    final paint = Paint()..style = PaintingStyle.fill;
    final time = animation.value * 2 * math.pi;
    
    for (int layer = 0; layer < colors.length + 2; layer++) {
      final progress = layer / (colors.length + 2);
      final colorIndex = (layer * colors.length / (colors.length + 2)).floor().clamp(0, colors.length - 1);
      
      final gradient = RadialGradient(
        center: Alignment.center,
        radius: 1.2,
        colors: [
          colors[colorIndex].withValues(alpha: (0.8 - progress * 0.4) * opacity),
          colors[colorIndex].withValues(alpha: 0.1 * opacity),
        ],
      );
      
      paint.shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      
      final path = Path();
      final curveHeight = size.height * (0.6 + progress * 0.4);
      final frequency = 1.5 + layer * 0.3;
      final phase = time * (0.5 + layer * 0.2);
      
      path.moveTo(0, size.height);
      
      for (double x = 0; x <= size.width; x += 3) {
        final normalizedX = x / size.width;
        final wave1 = math.sin(normalizedX * frequency * math.pi + phase);
        final wave2 = math.sin(normalizedX * frequency * 2 * math.pi + phase * 1.3);
        final combinedWave = (wave1 + wave2 * 0.5) / 1.5;
        
        final y = size.height - curveHeight + combinedWave * curveHeight * 0.3 * intensity;
        path.lineTo(x, y);
      }
      
      path.lineTo(size.width, size.height);
      path.close();
      
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
    final paint = Paint()..style = PaintingStyle.fill;
    final time = animation.value * 2 * math.pi;
    
    final particleCount = (50 + colors.length * 20) * intensity;
    
    for (int i = 0; i < particleCount; i++) {
      final progress = i / particleCount;
      final colorIndex = (i * colors.length / particleCount).floor().clamp(0, colors.length - 1);
      
      final baseX = (i * 73) % size.width;
      final baseY = (i * 97) % size.height;
      
      final x = baseX + 30 * math.sin(time + i * 0.1) * intensity;
      final y = baseY + 30 * math.cos(time * 0.7 + i * 0.13) * intensity;
      
      final radius = (3 + progress * 8) * intensity;
      final opacityFactor = 0.6 - progress * 0.4;
      
      paint.color = colors[colorIndex].withValues(alpha: opacityFactor * opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
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
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.screen;
    
    final time = animation.value * 2 * math.pi;
    
    for (int flow = 0; flow < colors.length; flow++) {
      final flowProgress = flow / colors.length;
      
      final gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          colors[flow].withValues(alpha: 0.7 * opacity),
          colors[(flow + 1) % colors.length].withValues(alpha: 0.3 * opacity),
        ],
      );
      
      paint.shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      
      final path = Path();
      final flowWidth = size.width * (0.6 + flowProgress * 0.4);
      final flowHeight = size.height * 0.8;
      
      final startX = size.width * flowProgress * 0.3;
      final startY = size.height * 0.1;
      
      path.moveTo(startX, startY);
      
      for (double t = 0; t <= 1; t += 0.02) {
        final x = startX + flowWidth * t + 
                  50 * math.sin(time + t * 4 * math.pi + flow) * intensity;
        final y = startY + flowHeight * t + 
                  30 * math.cos(time * 0.8 + t * 6 * math.pi + flow * 2) * intensity;
        
        if (t == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 20 + flow * 10;
      paint.strokeCap = StrokeCap.round;
      
      canvas.drawPath(path, paint);
    }
  }
}
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
    final maxRadius = math.min(size.width, size.height) * 0.4;
    
    for (int arm = 0; arm < 3; arm++) {
      final armAngle = (arm * 2 * math.pi / 3) + time * 0.1;
      
      for (int i = 0; i < 200; i++) {
        final progress = i / 200.0;
        final radius = maxRadius * progress * intensity;
        final angle = armAngle + progress * 4 * math.pi;
        
        final x = center.dx + radius * math.cos(angle);
        final y = center.dy + radius * math.sin(angle);
        
        final colorIndex = (i * colors.length / 200).floor().clamp(0, colors.length - 1);
        final paint = createPaint(
          colors[colorIndex].withValues(alpha: (1 - progress) * 0.7 * opacity),
          withGlow: enableGlow,
        );
        
        final starSize = (1 - progress) * 4 * intensity;
        canvas.drawCircle(Offset(x, y), starSize, paint);
      }
    }
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
    
    for (int layer = 0; layer < colors.length; layer++) {
      final paint = createPaint(colors[layer], withGlow: enableGlow);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 8 + layer * 4;
      paint.strokeCap = StrokeCap.round;
      
      final path = Path();
      final amplitude = size.height * 0.2 * intensity;
      final frequency = 3 + layer;
      
      for (double x = 0; x <= size.width; x += 2) {
        final layerProgress = layer / colors.length;
        final y = size.height * (0.3 + layerProgress * 0.4) +
                  amplitude * math.sin((x / size.width) * frequency * math.pi + time + layer);
        
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      
      canvas.drawPath(path, paint);
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
    final gridSize = 20;
    final cellWidth = size.width / gridSize;
    final cellHeight = size.height / gridSize;
    
    for (int x = 0; x < gridSize; x++) {
      for (int y = 0; y < gridSize; y++) {
        final centerX = x * cellWidth + cellWidth / 2;
        final centerY = y * cellHeight + cellHeight / 2;
        
        final noise = math.sin(x * 0.5 + time) * math.cos(y * 0.5 + time * 0.7);
        final colorIndex = ((noise + 1) * colors.length / 2).floor().clamp(0, colors.length - 1);
        
        final paint = createPaint(
          colors[colorIndex].withValues(alpha: (noise.abs() * 0.8 + 0.2) * opacity),
          withGlow: enableGlow,
        );
        
        final rectSize = cellWidth * 0.7 * (noise.abs() * intensity + 0.3);
        final rect = Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: rectSize,
          height: rectSize,
        );
        
        canvas.drawRect(rect, paint);
      }
    }
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
    final startPoint = Offset(size.width / 2, size.height);
    
    _drawBranch(
      canvas,
      startPoint,
      -math.pi / 2 + math.sin(time) * 0.1,
      size.height * 0.3 * intensity,
      8,
      0,
    );
  }
  
  void _drawBranch(Canvas canvas, Offset start, double angle, double length, int depth, int colorIndex) {
    if (depth <= 0 || length < 2) return;
    
    final end = Offset(
      start.dx + length * math.cos(angle),
      start.dy + length * math.sin(angle),
    );
    
    final paint = createPaint(
      colors[colorIndex % colors.length].withValues(alpha: (depth / 8.0) * opacity),
      withGlow: enableGlow,
    );
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = depth.toDouble();
    paint.strokeCap = StrokeCap.round;
    
    canvas.drawLine(start, end, paint);
    
    final newLength = length * 0.7;
    final angleVariation = 0.5 + animation.value * 0.2;
    
    _drawBranch(canvas, end, angle - angleVariation, newLength, depth - 1, colorIndex + 1);
    _drawBranch(canvas, end, angle + angleVariation, newLength, depth - 1, colorIndex + 1);
  }
}
class NeuralNetworkPainter extends AnimatedCanvasPainter {
  NeuralNetworkPainter({
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
    
    // Create network nodes
    final nodes = <Offset>[];
    final nodeCount = (20 + colors.length * 5) * intensity;
    
    for (int i = 0; i < nodeCount; i++) {
      final x = (i * 73) % size.width;
      final y = (i * 97) % size.height;
      nodes.add(Offset(x, y));
    }
    
    // Draw connections
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final distance = (nodes[i] - nodes[j]).distance;
        if (distance < 150 * intensity) {
          final connectionStrength = (1 - distance / (150 * intensity));
          final colorIndex = (i * colors.length / nodes.length).floor().clamp(0, colors.length - 1);
          
          final paint = Paint()
            ..color = colors[colorIndex].withValues(alpha: connectionStrength * 0.3 * opacity)
            ..strokeWidth = connectionStrength * 2 * intensity
            ..style = PaintingStyle.stroke;
          
          if (enableGlow) {
            paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius * connectionStrength);
          }
          
          canvas.drawLine(nodes[i], nodes[j], paint);
        }
      }
    }
    
    // Draw nodes
    for (int i = 0; i < nodes.length; i++) {
      final colorIndex = (i * colors.length / nodes.length).floor().clamp(0, colors.length - 1);
      final pulsePhase = math.sin(time + i * 0.1) * 0.5 + 0.5;
      final nodeSize = (3 + pulsePhase * 5) * intensity;
      
      final paint = createPaint(
        colors[colorIndex].withValues(alpha: (0.7 + pulsePhase * 0.3) * opacity),
        withGlow: enableGlow,
      );
      
      canvas.drawCircle(nodes[i], nodeSize, paint);
    }
  }
}

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
    
    for (int ring = 0; ring < 5; ring++) {
      final ringProgress = ring / 5.0;
      final ringRadius = (50 + ring * 80) * intensity;
      final crystals = 6 + ring * 2;
      
      for (int i = 0; i < crystals; i++) {
        final angle = (i / crystals) * 2 * math.pi + time * (0.1 + ringProgress * 0.2);
        final crystalCenter = center + Offset(
          ringRadius * math.cos(angle),
          ringRadius * math.sin(angle),
        );
        
        final colorIndex = ((ring + i) * colors.length / (5 * crystals)).floor().clamp(0, colors.length - 1);
        final growth = math.sin(time * 2 + ring + i) * 0.3 + 0.7;
        
        _drawCrystal(canvas, crystalCenter, (20 + ring * 10) * growth * intensity, 
                    colors[colorIndex].withValues(alpha: (0.8 - ringProgress * 0.3) * opacity), angle);
      }
    }
  }
  
  void _drawCrystal(Canvas canvas, Offset center, double size, Color color, double rotation) {
    final paint = createPaint(color, withGlow: enableGlow);
    
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    
    final path = Path();
    final points = 6;
    
    for (int i = 0; i < points; i++) {
      final angle = (i / points) * 2 * math.pi;
      final radius = i % 2 == 0 ? size : size * 0.5;
      final x = radius * math.cos(angle);
      final y = radius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    
    canvas.drawPath(path, paint);
    canvas.restore();
  }
}

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
    final maxRadius = math.min(size.width, size.height) * 0.4 * intensity;
    
    // Draw plasma bolts
    for (int bolt = 0; bolt < 8 + colors.length; bolt++) {
      final boltAngle = (bolt / (8 + colors.length)) * 2 * math.pi + time * 0.5;
      final colorIndex = (bolt * colors.length / (8 + colors.length)).floor().clamp(0, colors.length - 1);
      
      final path = Path();
      path.moveTo(center.dx, center.dy);
      
      double currentRadius = 0;
      double currentAngle = boltAngle;
      
      while (currentRadius < maxRadius) {
        currentRadius += 10 + math.sin(time * 3 + bolt) * 5;
        currentAngle += (math.sin(time * 2 + currentRadius * 0.1 + bolt) * 0.5) * intensity;
        
        final x = center.dx + currentRadius * math.cos(currentAngle);
        final y = center.dy + currentRadius * math.sin(currentAngle);
        
        path.lineTo(x, y);
      }
      
      final paint = Paint()
        ..color = colors[colorIndex].withValues(alpha: (0.8 - currentRadius / maxRadius * 0.6) * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (5 - currentRadius / maxRadius * 3) * intensity
        ..strokeCap = StrokeCap.round;
      
      if (enableGlow) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
      }
      
      canvas.drawPath(path, paint);
    }
    
    // Draw core
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: colors.map((c) => c.withValues(alpha: 0.9 * opacity)).toList(),
      ).createShader(Rect.fromCircle(center: center, radius: 30 * intensity));
    
    if (enableGlow) {
      corePaint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius * 2);
    }
    
    canvas.drawCircle(center, 30 * intensity, corePaint);
  }
}

class QuantumFieldPainter extends AnimatedCanvasPainter {
  QuantumFieldPainter({
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
    final fieldResolution = (20 * intensity).round();
    final cellWidth = size.width / fieldResolution;
    final cellHeight = size.height / fieldResolution;
    
    for (int x = 0; x < fieldResolution; x++) {
      for (int y = 0; y < fieldResolution; y++) {
        final fieldX = x / fieldResolution;
        final fieldY = y / fieldResolution;
        
        // Quantum field calculation using multiple wave functions
        final wave1 = math.sin(fieldX * 8 * math.pi + time);
        final wave2 = math.cos(fieldY * 6 * math.pi + time * 1.3);
        final wave3 = math.sin((fieldX + fieldY) * 10 * math.pi + time * 0.7);
        
        final quantumAmplitude = (wave1 + wave2 + wave3) / 3;
        final probability = quantumAmplitude * quantumAmplitude;
        
        if (probability > 0.3) {
          final colorIndex = ((probability + 1) * colors.length / 2).floor().clamp(0, colors.length - 1);
          final alpha = (probability - 0.3) * 1.4 * opacity;
          
          final paint = createPaint(
            colors[colorIndex].withValues(alpha: alpha),
            withGlow: enableGlow,
          );
          
          final particleSize = probability * 8 * intensity;
          final centerX = x * cellWidth + cellWidth / 2;
          final centerY = y * cellHeight + cellHeight / 2;
          
          canvas.drawCircle(Offset(centerX, centerY), particleSize, paint);
        }
      }
    }
  }
}

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
    final columns = (size.width / 20).round();
    final dropHeight = 15.0;
    
    for (int col = 0; col < columns; col++) {
      final x = col * 20.0;
      final speed = 1 + (col % 3) * 0.5;
      final drops = (size.height / dropHeight * speed).round();
      
      for (int drop = 0; drop < drops; drop++) {
        final progress = ((time * speed + drop * 0.5) % (2 * math.pi)) / (2 * math.pi);
        final y = progress * (size.height + dropHeight * 10) - dropHeight * 5;
        
        if (y > -dropHeight && y < size.height + dropHeight) {
          final colorIndex = ((col + drop) * colors.length / (columns + drops)).floor().clamp(0, colors.length - 1);
          final alpha = math.max(0, 1 - (y / size.height)) * opacity;
          
          final paint = createPaint(
            colors[colorIndex].withValues(alpha: alpha * intensity),
            withGlow: enableGlow,
          );
          
          // Draw digital character (simplified as rectangle)
          final rect = Rect.fromLTWH(x, y, 10 * intensity, dropHeight * intensity);
          canvas.drawRect(rect, paint);
        }
      }
    }
  }
}

class CosmicWebPainter extends AnimatedCanvasPainter {
  CosmicWebPainter({
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
    
    // Create cosmic nodes (galaxies)
    final nodes = <Map<String, dynamic>>[];
    final nodeCount = (12 + colors.length * 2) * intensity;
    
    for (int i = 0; i < nodeCount; i++) {
      final angle = (i / nodeCount) * 2 * math.pi + time * 0.1;
      final radius = (size.width * 0.4) * (0.3 + (i % 3) * 0.3);
      final x = size.width / 2 + radius * math.cos(angle);
      final y = size.height / 2 + radius * math.sin(angle);
      
      nodes.add({
        'position': Offset(x, y),
        'size': (10 + i % 20) * intensity,
        'colorIndex': (i * colors.length / nodeCount).floor().clamp(0, colors.length - 1),
        'energy': math.sin(time * 2 + i) * 0.5 + 0.5,
      });
    }
    
    // Draw cosmic filaments
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final node1 = nodes[i];
        final node2 = nodes[j];
        final pos1 = node1['position'] as Offset;
        final pos2 = node2['position'] as Offset;
        final distance = (pos1 - pos2).distance;
        
        if (distance < 200 * intensity) {
          final energy = (node1['energy'] + node2['energy']) / 2;
          final filamentStrength = (1 - distance / (200 * intensity)) * energy;
          
          final paint = Paint()
            ..color = colors[node1['colorIndex']].withValues(alpha: filamentStrength * 0.4 * opacity)
            ..strokeWidth = filamentStrength * 3 * intensity
            ..style = PaintingStyle.stroke;
          
          if (enableGlow) {
            paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius * filamentStrength);
          }
          
          canvas.drawLine(pos1, pos2, paint);
        }
      }
    }
    
    // Draw nodes (galaxies)
    for (final node in nodes) {
      final pos = node['position'] as Offset;
      final size = node['size'] as double;
      final colorIndex = node['colorIndex'] as int;
      final energy = node['energy'] as double;
      
      final paint = createPaint(
        colors[colorIndex].withValues(alpha: (0.8 + energy * 0.2) * opacity),
        withGlow: enableGlow,
      );
      
      canvas.drawCircle(pos, size * (0.8 + energy * 0.4), paint);
    }
  }
}

class MolecularStructurePainter extends AnimatedCanvasPainter {
  MolecularStructurePainter({
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
    
    // Create larger, more complex molecular structures
    final molecules = <Map<String, dynamic>>[];
    final clusters = 3 + (colors.length ~/ 2); // Multiple molecular clusters
    
    for (int cluster = 0; cluster < clusters; cluster++) {
      final clusterCenter = Offset(
        center.dx + math.cos(cluster * 2 * math.pi / clusters + time * 0.2) * size.width * 0.25,
        center.dy + math.sin(cluster * 2 * math.pi / clusters + time * 0.2) * size.height * 0.25,
      );
      
      final moleculeCount = 6 + cluster * 2; // More molecules per cluster
      
      for (int i = 0; i < moleculeCount; i++) {
        final angle = (i / moleculeCount) * 2 * math.pi + time * 0.5 + cluster * math.pi;
        final orbit = (40 + (i % 4) * 30) * intensity; // Larger orbits
        final x = clusterCenter.dx + orbit * math.cos(angle);
        final y = clusterCenter.dy + orbit * math.sin(angle);
        
        molecules.add({
          'position': Offset(x, y),
          'size': (20 + i % 15) * intensity * 1.5, // Larger atoms
          'colorIndex': (cluster * colors.length / clusters).floor().clamp(0, colors.length - 1),
          'vibration': math.sin(time * 3 + i + cluster) * 4 * intensity,
          'cluster': cluster,
          'index': i,
          'atomType': i % 3, // Different atom types (0=large, 1=medium, 2=small)
        });
      }
    }
    
    // Draw inter-cluster bonds (longer range connections)
    for (int i = 0; i < molecules.length; i++) {
      final current = molecules[i];
      for (int j = i + 1; j < molecules.length; j++) {
        final other = molecules[j];
        final pos1 = current['position'] as Offset;
        final pos2 = other['position'] as Offset;
        final distance = (pos1 - pos2).distance;
        
        // Create bonds between nearby molecules from different clusters
        if (current['cluster'] != other['cluster'] && distance < 120 * intensity) {
          final bondStrength = 1.0 - (distance / (120 * intensity));
          
          final paint = Paint()
            ..color = colors[current['colorIndex']].withValues(alpha: bondStrength * 0.4 * opacity)
            ..strokeWidth = 2 * intensity * bondStrength
            ..style = PaintingStyle.stroke;
          
          if (enableGlow) {
            paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius * 0.5);
          }
          
          canvas.drawLine(pos1, pos2, paint);
        }
      }
    }
    
    // Draw intra-cluster bonds (stronger, within same cluster)
    for (int cluster = 0; cluster < clusters; cluster++) {
      final clusterMolecules = molecules.where((m) => m['cluster'] == cluster).toList();
      
      for (int i = 0; i < clusterMolecules.length; i++) {
        final current = clusterMolecules[i];
        final next = clusterMolecules[(i + 1) % clusterMolecules.length];
        
        final pos1 = current['position'] as Offset;
        final pos2 = next['position'] as Offset;
        final vibration1 = current['vibration'] as double;
        final vibration2 = next['vibration'] as double;
        
        final adjustedPos1 = pos1 + Offset(vibration1, vibration1 * 0.5);
        final adjustedPos2 = pos2 + Offset(vibration2, vibration2 * 0.5);
        
        // Double and triple bonds for realism
        final bondType = (i + cluster) % 3;
        final bondCount = bondType == 0 ? 1 : (bondType == 1 ? 2 : 3);
        
        for (int bond = 0; bond < bondCount; bond++) {
          final offset = (bond - (bondCount - 1) / 2) * 3 * intensity;
          final perpendicular = (adjustedPos2 - adjustedPos1).normalizeOffset();
          final bondStart = adjustedPos1 + Offset(-perpendicular.dy * offset, perpendicular.dx * offset);
          final bondEnd = adjustedPos2 + Offset(-perpendicular.dy * offset, perpendicular.dx * offset);
          
          final paint = Paint()
            ..color = colors[current['colorIndex']].withValues(alpha: 0.8 * opacity)
            ..strokeWidth = (4 - bond) * intensity
            ..style = PaintingStyle.stroke;
          
          if (enableGlow) {
            paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
          }
          
          canvas.drawLine(bondStart, bondEnd, paint);
        }
      }
    }
    
    // Draw atoms with realistic joints and edges
    for (final molecule in molecules) {
      final pos = molecule['position'] as Offset;
      final size = molecule['size'] as double;
      final colorIndex = molecule['colorIndex'] as int;
      final vibration = molecule['vibration'] as double;
      final atomType = molecule['atomType'] as int;
      
      final adjustedPos = pos + Offset(vibration, vibration * 0.5);
      
      // Draw atom nucleus
      final nucleusPaint = createPaint(
        colors[colorIndex].withValues(alpha: 0.9 * opacity),
        withGlow: enableGlow,
      );
      
      canvas.drawCircle(adjustedPos, size, nucleusPaint);
      
      // Draw atom edges/shell structure
      final shellPaint = Paint()
        ..color = colors[colorIndex].withValues(alpha: 0.3 * opacity)
        ..strokeWidth = 1.5 * intensity
        ..style = PaintingStyle.stroke;
      
      // Multiple electron shells based on atom type
      final shells = atomType == 0 ? 3 : (atomType == 1 ? 2 : 1);
      for (int shell = 1; shell <= shells; shell++) {
        canvas.drawCircle(adjustedPos, size * (1 + shell * 0.4), shellPaint);
      }
      
      // Draw moving electrons
      for (int electron = 0; electron < shells; electron++) {
        final electronAngle = time * (2 + electron) + (molecule['index'] as int) * math.pi / 4;
        final electronRadius = size * (1.2 + electron * 0.4);
        final electronPos = adjustedPos + Offset(
          electronRadius * math.cos(electronAngle),
          electronRadius * math.sin(electronAngle),
        );
        
        final electronPaint = createPaint(
          colors[(colorIndex + electron + 1) % colors.length].withValues(alpha: 0.8 * opacity),
          withGlow: enableGlow,
        );
        
        canvas.drawCircle(electronPos, 3 * intensity, electronPaint);
      }
      
      // Draw valence indicators (small dots showing bonding sites)
      final valenceCount = (atomType + 1) * 2;
      for (int v = 0; v < valenceCount; v++) {
        final valenceAngle = (v / valenceCount) * 2 * math.pi;
        final valencePos = adjustedPos + Offset(
          size * 1.1 * math.cos(valenceAngle),
          size * 1.1 * math.sin(valenceAngle),
        );
        
        final valencePaint = createPaint(
          colors[colorIndex].withValues(alpha: 0.6 * opacity),
          withGlow: false,
        );
        
        canvas.drawCircle(valencePos, 2 * intensity, valencePaint);
      }
    }
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

class WaveInterferencePainter extends AnimatedCanvasPainter {
  WaveInterferencePainter({
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
    
    // Wave sources
    final sources = <Offset>[
      Offset(size.width * 0.3, size.height * 0.3),
      Offset(size.width * 0.7, size.height * 0.3),
      Offset(size.width * 0.5, size.height * 0.7),
    ];
    
    final resolution = (40 * intensity).round();
    final cellWidth = size.width / resolution;
    final cellHeight = size.height / resolution;
    
    for (int x = 0; x < resolution; x++) {
      for (int y = 0; y < resolution; y++) {
        final point = Offset(x * cellWidth, y * cellHeight);
        double totalAmplitude = 0;
        
        // Calculate interference from all sources
        for (int s = 0; s < sources.length; s++) {
          final distance = (point - sources[s]).distance;
          final waveLength = 40 + s * 20;
          final phase = (distance / waveLength) * 2 * math.pi - time * (2 + s);
          final amplitude = math.exp(-distance / (200 * intensity)) * math.sin(phase);
          totalAmplitude += amplitude;
        }
        
        final normalizedAmplitude = totalAmplitude / sources.length;
        final intensityValue = normalizedAmplitude * normalizedAmplitude;
        
        if (intensityValue > 0.1) {
          final colorIndex = ((normalizedAmplitude + 1) * colors.length / 2).floor().clamp(0, colors.length - 1);
          final alpha = (intensityValue - 0.1) * 1.1 * opacity;
          
          final paint = createPaint(
            colors[colorIndex].withValues(alpha: alpha),
            withGlow: enableGlow,
          );
          
          final rippleSize = intensityValue * 6 * intensity;
          canvas.drawCircle(point, rippleSize, paint);
        }
      }
    }
    
    // Draw wave sources
    for (int s = 0; s < sources.length; s++) {
      final pulsePaint = createPaint(
        colors[s % colors.length].withValues(alpha: 0.8 * opacity),
        withGlow: enableGlow,
      );
      
      final pulseSize = (10 + math.sin(time * 3) * 5) * intensity;
      canvas.drawCircle(sources[s], pulseSize, pulsePaint);
    }
  }
}

// NEW UNIQUE CANVAS DESIGNS

class FireworksPainter extends AnimatedCanvasPainter {
  FireworksPainter({
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
    final fireworkCount = 5 + colors.length;
    
    for (int i = 0; i < fireworkCount; i++) {
      final lifecycle = (time + i * 2) % (2 * math.pi);
      final explosionPhase = math.sin(lifecycle * 0.5);
      
      if (explosionPhase > 0) {
        final centerX = (i * 137.5) % size.width; // Golden ratio distribution
        final centerY = (i * 71.3) % size.height;
        final center = Offset(centerX, centerY);
        
        final particleCount = 20 + (i % 10);
        final radius = explosionPhase * 100 * intensity;
        
        for (int p = 0; p < particleCount; p++) {
          final angle = (p / particleCount) * 2 * math.pi;
          final particleRadius = radius * (0.8 + (p % 3) * 0.1);
          final fade = 1.0 - explosionPhase;
          
          final x = center.dx + particleRadius * math.cos(angle);
          final y = center.dy + particleRadius * math.sin(angle) + explosionPhase * 30; // Gravity effect
          
          final colorIndex = (i + p ~/ 5) % colors.length;
          final paint = createPaint(
            colors[colorIndex].withValues(alpha: fade * opacity),
            withGlow: enableGlow,
          );
          
          final sparkSize = (3 + p % 4) * intensity * fade;
          canvas.drawCircle(Offset(x, y), sparkSize, paint);
        }
      }
    }
  }
}

class AuroraPainter extends AnimatedCanvasPainter {
  AuroraPainter({
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
      final path = Path();
      // Aurora waves layer calculation
      final amplitude = (20 + layer * 15) * intensity;
      final frequency = 2 + layer * 0.5;
      final verticalShift = size.height * (0.3 + layer * 0.1);
      
      path.moveTo(0, verticalShift);
      
      for (double x = 0; x <= size.width; x += 2) {
        final wave1 = math.sin((x / size.width) * frequency * math.pi + time + layer);
        final wave2 = math.sin((x / size.width) * frequency * 2 * math.pi + time * 1.3 + layer);
        final wave3 = math.sin((x / size.width) * frequency * 0.7 * math.pi + time * 0.8 + layer);
        
        final y = verticalShift + 
                  (wave1 * amplitude * 0.5) + 
                  (wave2 * amplitude * 0.3) + 
                  (wave3 * amplitude * 0.2);
        
        path.lineTo(x, y);
      }
      
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors[layer].withValues(alpha: 0.7 * opacity),
          colors[layer].withValues(alpha: 0.1 * opacity),
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

class HoneycombPainter extends AnimatedCanvasPainter {
  HoneycombPainter({
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
    final hexSize = 30 * intensity;
    final hexWidth = hexSize * math.sqrt(3);
    final hexHeight = hexSize * 2;
    
    for (double x = -hexWidth; x < size.width + hexWidth; x += hexWidth * 0.75) {
      for (double y = -hexHeight; y < size.height + hexHeight; y += hexHeight * 0.5) {
        final offsetY = ((x / (hexWidth * 0.75)).round() % 2) * hexHeight * 0.25;
        final center = Offset(x, y + offsetY);
        
        final distance = (center - Offset(size.width / 2, size.height / 2)).distance;
        final normalizedDistance = distance / (size.width * 0.5);
        final pulse = math.sin(time - normalizedDistance * 2) * 0.5 + 0.5;
        
        _drawHexagon(canvas, center, hexSize * (0.8 + pulse * 0.4), 
                     colors[(distance / 50).round() % colors.length], pulse);
      }
    }
  }
  
  void _drawHexagon(Canvas canvas, Offset center, double size, Color color, double pulse) {
    final path = Path();
    
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi) / 3;
      final x = center.dx + size * math.cos(angle);
      final y = center.dy + size * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    
    final paint = createPaint(
      color.withValues(alpha: (0.3 + pulse * 0.4) * opacity),
      withGlow: enableGlow,
    );
    
    canvas.drawPath(path, paint);
    
    // Draw border
    final borderPaint = Paint()
      ..color = color.withValues(alpha: (0.6 + pulse * 0.4) * opacity)
      ..strokeWidth = 2 * intensity
      ..style = PaintingStyle.stroke;
    
    canvas.drawPath(path, borderPaint);
  }
}

class MandalaPainter extends AnimatedCanvasPainter {
  MandalaPainter({
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
    final maxRadius = math.min(size.width, size.height) * 0.4 * intensity;
    
    // Draw concentric circles with patterns
    for (int ring = 1; ring <= 8; ring++) {
      final radius = maxRadius * ring / 8;
      final petals = ring * 6; // More petals for outer rings
      final colorIndex = (ring - 1) % colors.length;
      
      for (int petal = 0; petal < petals; petal++) {
        final angle = (petal / petals) * 2 * math.pi + time * 0.1 * ring;
        final petalSize = (5 + ring * 2) * intensity;
        
        final x = center.dx + radius * math.cos(angle);
        final y = center.dy + radius * math.sin(angle);
        
        // Draw petal shape
        final path = Path();
        final petalCenter = Offset(x, y);
        
        for (int point = 0; point < 8; point++) {
          final petalAngle = (point / 8) * 2 * math.pi + angle;
          final petalRadius = petalSize * (point % 2 == 0 ? 1.0 : 0.6);
          final px = petalCenter.dx + petalRadius * math.cos(petalAngle);
          final py = petalCenter.dy + petalRadius * math.sin(petalAngle);
          
          if (point == 0) {
            path.moveTo(px, py);
          } else {
            path.lineTo(px, py);
          }
        }
        path.close();
        
        final paint = createPaint(
          colors[colorIndex].withValues(alpha: 0.6 * opacity),
          withGlow: enableGlow,
        );
        
        canvas.drawPath(path, paint);
      }
    }
    
    // Draw center
    final centerPaint = createPaint(
      colors[0].withValues(alpha: 0.9 * opacity),
      withGlow: enableGlow,
    );
    canvas.drawCircle(center, 15 * intensity, centerPaint);
  }
}

class DnaHelixPainter extends AnimatedCanvasPainter {
  DnaHelixPainter({
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
    final centerX = size.width / 2;
    final helixHeight = size.height;
    final helixRadius = 60 * intensity;
    final turns = 8;
    
    // Draw two intertwined helixes
    for (int helix = 0; helix < 2; helix++) {
      final helixOffset = helix * math.pi;
      final colorIndex = helix % colors.length;
      
      final path = Path();
      bool firstPoint = true;
      
      for (double y = 0; y <= helixHeight; y += 2) {
        final progress = y / helixHeight;
        final angle = progress * turns * 2 * math.pi + time + helixOffset;
        final x = centerX + helixRadius * math.cos(angle);
        
        if (firstPoint) {
          path.moveTo(x, y);
          firstPoint = false;
        } else {
          path.lineTo(x, y);
        }
      }
      
      // Draw helix backbone
      final backbonePaint = Paint()
        ..color = colors[colorIndex].withValues(alpha: 0.8 * opacity)
        ..strokeWidth = 4 * intensity
        ..style = PaintingStyle.stroke;
      
      if (enableGlow) {
        backbonePaint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
      }
      
      canvas.drawPath(path, backbonePaint);
      
      // Draw base pairs
      for (double y = 0; y <= helixHeight; y += 15) {
        final progress = y / helixHeight;
        final angle = progress * turns * 2 * math.pi + time + helixOffset;
        final x = centerX + helixRadius * math.cos(angle);
        
        // Draw nucleotide
        final nucleotidePaint = createPaint(
          colors[(colorIndex + (y / 15).round()) % colors.length].withValues(alpha: 0.9 * opacity),
          withGlow: enableGlow,
        );
        
        canvas.drawCircle(Offset(x, y), 8 * intensity, nucleotidePaint);
      }
    }
    
    // Draw connecting base pairs
    for (double y = 0; y <= helixHeight; y += 30) {
      final progress = y / helixHeight;
      final angle1 = progress * turns * 2 * math.pi + time;
      final angle2 = progress * turns * 2 * math.pi + time + math.pi;
      
      final x1 = centerX + helixRadius * math.cos(angle1);
      final x2 = centerX + helixRadius * math.cos(angle2);
      
      final connectionPaint = Paint()
        ..color = colors[2 % colors.length].withValues(alpha: 0.6 * opacity)
        ..strokeWidth = 2 * intensity
        ..style = PaintingStyle.stroke;
      
      canvas.drawLine(Offset(x1, y), Offset(x2, y), connectionPaint);
    }
  }
}

class LavaLampPainter extends AnimatedCanvasPainter {
  LavaLampPainter({
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
      final phase = time + i * 0.7;
      final floatSpeed = 0.1 + (i % 3) * 0.05;
      final floatHeight = size.height * 0.8 * math.sin(phase * floatSpeed);
      
      final x = size.width * (0.2 + (i * 0.1) % 0.6);
      final y = size.height * 0.5 + floatHeight * 0.5;
      
      final blobSize = (30 + i * 5 + math.sin(phase * 2) * 10) * intensity;
      final colorIndex = i % colors.length;
      
      // Create blob shape with metaball effect
      final path = Path();
      final segments = 12;
      
      for (int s = 0; s < segments; s++) {
        final angle = (s / segments) * 2 * math.pi;
        final distortion = 1.0 + math.sin(phase * 3 + s) * 0.3;
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
      
      // Create gradient for lava effect
      final gradient = RadialGradient(
        center: Alignment.center,
        colors: [
          colors[colorIndex].withValues(alpha: 0.9 * opacity),
          colors[colorIndex].withValues(alpha: 0.3 * opacity),
        ],
      );
      
      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromCircle(center: Offset(x, y), radius: blobSize))
        ..style = PaintingStyle.fill;
      
      if (enableGlow) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
      }
      
      canvas.drawPath(path, paint);
    }
  }
}

class ElectricFieldPainter extends AnimatedCanvasPainter {
  ElectricFieldPainter({
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
    
    // Electric charges
    final charges = <Map<String, dynamic>>[
      {'pos': Offset(size.width * 0.3, size.height * 0.3), 'charge': 1},
      {'pos': Offset(size.width * 0.7, size.height * 0.3), 'charge': -1},
      {'pos': Offset(size.width * 0.5, size.height * 0.7), 'charge': 1},
    ];
    
    // Draw field lines
    final fieldLines = 20;
    for (int line = 0; line < fieldLines; line++) {
      final startAngle = (line / fieldLines) * 2 * math.pi;
      final startRadius = 50;
      
      for (final charge in charges) {
        if (charge['charge'] > 0) { // Positive charges emit field lines
          final startPos = charge['pos'] as Offset;
          final lineStart = startPos + Offset(
            startRadius * math.cos(startAngle),
            startRadius * math.sin(startAngle),
          );
          
          _drawFieldLine(canvas, size, lineStart, charges, line);
        }
      }
    }
    
    // Draw charges
    for (int i = 0; i < charges.length; i++) {
      final charge = charges[i];
      final pos = charge['pos'] as Offset;
      final isPositive = charge['charge'] > 0;
      final pulse = math.sin(time * 2 + i) * 0.2 + 1.0;
      
      final chargePaint = createPaint(
        colors[isPositive ? i % colors.length : (i + 1) % colors.length]
            .withValues(alpha: 0.9 * opacity),
        withGlow: enableGlow,
      );
      
      canvas.drawCircle(pos, 15 * intensity * pulse, chargePaint);
      
      // Draw charge symbol
      final symbolPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.9 * opacity)
        ..strokeWidth = 3 * intensity
        ..style = PaintingStyle.stroke;
      
      // Draw + or -
      canvas.drawLine(
        pos + const Offset(-8, 0),
        pos + const Offset(8, 0),
        symbolPaint,
      );
      
      if (isPositive) {
        canvas.drawLine(
          pos + const Offset(0, -8),
          pos + const Offset(0, 8),
          symbolPaint,
        );
      }
    }
  }
  
  void _drawFieldLine(Canvas canvas, Size size, Offset start, List<Map<String, dynamic>> charges, int lineIndex) {
    final path = Path();
    path.moveTo(start.dx, start.dy);
    
    Offset currentPos = start;
    final steps = 50;
    
    for (int step = 0; step < steps; step++) {
      Offset fieldVector = const Offset(0, 0);
      
      // Calculate field at current position
      for (final charge in charges) {
        final chargePos = charge['pos'] as Offset;
        final chargeValue = charge['charge'] as int;
        final distance = (currentPos - chargePos).distance;
        
        if (distance > 5) {
          final direction = (currentPos - chargePos) / distance;
          final fieldStrength = chargeValue / (distance * distance) * 10000;
          fieldVector += direction * fieldStrength;
        }
      }
      
      if (fieldVector.distance > 0) {
        fieldVector = fieldVector / fieldVector.distance * 3; // Normalize and scale step
        currentPos += fieldVector;
        path.lineTo(currentPos.dx, currentPos.dy);
      }
      
      // Stop if out of bounds
      if (currentPos.dx < 0 || currentPos.dx > size.width || 
          currentPos.dy < 0 || currentPos.dy > size.height) {
        break;
      }
    }
    
    final linePaint = Paint()
      ..color = colors[lineIndex % colors.length].withValues(alpha: 0.6 * opacity)
      ..strokeWidth = 1.5 * intensity
      ..style = PaintingStyle.stroke;
    
    if (enableGlow) {
      linePaint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius * 0.5);
    }
    
    canvas.drawPath(path, linePaint);
  }
}

class MagneticFieldPainter extends AnimatedCanvasPainter {
  MagneticFieldPainter({
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
    
    // Draw magnetic field lines (circular)
    for (int ring = 1; ring <= 10; ring++) {
      final radius = ring * 25 * intensity;
      final colorIndex = ring % colors.length;
      
      // Draw field line circle
      final fieldPaint = Paint()
        ..color = colors[colorIndex].withValues(alpha: 0.6 * opacity)
        ..strokeWidth = 2 * intensity
        ..style = PaintingStyle.stroke;
      
      if (enableGlow) {
        fieldPaint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius * 0.5);
      }
      
      canvas.drawCircle(center, radius, fieldPaint);
      
      // Draw field direction arrows
      final arrowCount = ring * 4;
      for (int arrow = 0; arrow < arrowCount; arrow++) {
        final angle = (arrow / arrowCount) * 2 * math.pi + time * 0.1;
        final arrowPos = center + Offset(
          radius * math.cos(angle),
          radius * math.sin(angle),
        );
        
        // Draw arrow
        final arrowSize = 8 * intensity;
        final arrowAngle = angle + math.pi / 2; // Tangent to circle
        
        final arrowPaint = Paint()
          ..color = colors[colorIndex].withValues(alpha: 0.8 * opacity)
          ..strokeWidth = 2 * intensity
          ..style = PaintingStyle.stroke;
        
        // Arrow body
        final arrowEnd = arrowPos + Offset(
          arrowSize * math.cos(arrowAngle),
          arrowSize * math.sin(arrowAngle),
        );
        
        canvas.drawLine(arrowPos, arrowEnd, arrowPaint);
        
        // Arrow head
        final headAngle1 = arrowAngle + 2.5;
        final headAngle2 = arrowAngle - 2.5;
        final headSize = arrowSize * 0.4;
        
        canvas.drawLine(
          arrowEnd,
          arrowEnd + Offset(headSize * math.cos(headAngle1), headSize * math.sin(headAngle1)),
          arrowPaint,
        );
        canvas.drawLine(
          arrowEnd,
          arrowEnd + Offset(headSize * math.cos(headAngle2), headSize * math.sin(headAngle2)),
          arrowPaint,
        );
      }
    }
    
    // Draw magnetic dipole
    final dipolePaint = createPaint(
      colors[0].withValues(alpha: 0.9 * opacity),
      withGlow: enableGlow,
    );
    
    canvas.drawCircle(center, 20 * intensity, dipolePaint);
    
    // Draw N and S poles
    final textStyle = TextStyle(
      color: Colors.white.withValues(alpha: 0.9 * opacity),
      fontSize: 14 * intensity,
      fontWeight: FontWeight.bold,
    );
    
    final nPainter = TextPainter(
      text: TextSpan(text: 'N', style: textStyle),
      textDirection: TextDirection.ltr,
    );
    nPainter.layout();
    nPainter.paint(canvas, center + Offset(-nPainter.width / 2, -25 * intensity));
    
    final sPainter = TextPainter(
      text: TextSpan(text: 'S', style: textStyle),
      textDirection: TextDirection.ltr,
    );
    sPainter.layout();
    sPainter.paint(canvas, center + Offset(-sPainter.width / 2, 15 * intensity));
  }
}

class RippleEffectPainter extends AnimatedCanvasPainter {
  RippleEffectPainter({
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
    
    // Multiple ripple sources
    final sources = [
      Offset(size.width * 0.3, size.height * 0.4),
      Offset(size.width * 0.7, size.height * 0.3),
      Offset(size.width * 0.5, size.height * 0.7),
    ];
    
    for (int sourceIndex = 0; sourceIndex < sources.length; sourceIndex++) {
      final source = sources[sourceIndex];
      final sourceTime = time + sourceIndex * math.pi / 2;
      
      // Draw multiple ripples from each source
      for (int ripple = 0; ripple < 8; ripple++) {
        final rippleTime = sourceTime - ripple * 0.5;
        final rippleRadius = (rippleTime * 30 + ripple * 20) * intensity;
        
        if (rippleRadius > 0 && rippleRadius < size.width) {
          final fade = math.exp(-rippleTime * 0.5);
          final colorIndex = (sourceIndex + ripple) % colors.length;
          
          final ripplePaint = Paint()
            ..color = colors[colorIndex].withValues(alpha: fade * 0.6 * opacity)
            ..strokeWidth = (3 + ripple) * intensity * fade
            ..style = PaintingStyle.stroke;
          
          if (enableGlow) {
            ripplePaint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius * fade);
          }
          
          canvas.drawCircle(source, rippleRadius, ripplePaint);
        }
      }
      
      // Draw source
      final sourcePaint = createPaint(
        colors[sourceIndex % colors.length].withValues(alpha: 0.9 * opacity),
        withGlow: enableGlow,
      );
      
      final pulseSize = (8 + math.sin(sourceTime * 4) * 4) * intensity;
      canvas.drawCircle(source, pulseSize, sourcePaint);
    }
  }
}

class KaleidoscopePainter extends AnimatedCanvasPainter {
  KaleidoscopePainter({
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
    final segments = 8; // Number of kaleidoscope segments
    
    canvas.save();
    canvas.translate(center.dx, center.dy);
    
    for (int segment = 0; segment < segments; segment++) {
      canvas.save();
      canvas.rotate((segment * 2 * math.pi) / segments);
      
      // Create triangular clipping path for kaleidoscope segment
      final clipPath = Path();
      clipPath.moveTo(0, 0);
      clipPath.lineTo(size.width * 0.5, 0);
      clipPath.lineTo(size.width * 0.5 * math.cos(math.pi / segments), 
                      size.width * 0.5 * math.sin(math.pi / segments));
      clipPath.close();
      
      canvas.clipPath(clipPath);
      
      // Draw pattern in this segment
      for (int shape = 0; shape < 15; shape++) {
        final shapeTime = time + shape * 0.4 + segment * 0.1;
        final radius = (20 + shape * 15) * intensity;
        final angle = shapeTime + shape;
        
        final x = radius * math.cos(angle) * 0.5;
        final y = radius * math.sin(angle) * 0.5;
        
        final colorIndex = (segment + shape) % colors.length;
        final shapePaint = createPaint(
          colors[colorIndex].withValues(alpha: 0.7 * opacity),
          withGlow: enableGlow,
        );
        
        final shapeSize = (5 + shape % 8) * intensity;
        
        // Draw different shapes
        switch (shape % 4) {
          case 0: // Circle
            canvas.drawCircle(Offset(x, y), shapeSize, shapePaint);
            break;
          case 1: // Square
            canvas.drawRect(
              Rect.fromCenter(center: Offset(x, y), width: shapeSize * 2, height: shapeSize * 2),
              shapePaint,
            );
            break;
          case 2: // Triangle
            final trianglePath = Path();
            trianglePath.moveTo(x, y - shapeSize);
            trianglePath.lineTo(x - shapeSize, y + shapeSize);
            trianglePath.lineTo(x + shapeSize, y + shapeSize);
            trianglePath.close();
            canvas.drawPath(trianglePath, shapePaint);
            break;
          case 3: // Diamond
            final diamondPath = Path();
            diamondPath.moveTo(x, y - shapeSize);
            diamondPath.lineTo(x + shapeSize, y);
            diamondPath.lineTo(x, y + shapeSize);
            diamondPath.lineTo(x - shapeSize, y);
            diamondPath.close();
            canvas.drawPath(diamondPath, shapePaint);
            break;
        }
      }
      
      canvas.restore();
    }
    
    canvas.restore();
    
    // Draw center decoration
    final centerPaint = createPaint(
      colors[0].withValues(alpha: 0.9 * opacity),
      withGlow: enableGlow,
    );
    canvas.drawCircle(center, 10 * intensity, centerPaint);
  }
}

class ParticleExplosionPainter extends AnimatedCanvasPainter {
  ParticleExplosionPainter({
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
    final explosionCount = 3 + colors.length ~/ 2;
    
    for (int explosion = 0; explosion < explosionCount; explosion++) {
      final explosionTime = (time + explosion * 2.5) % (2 * math.pi);
      final explosionProgress = explosionTime / (2 * math.pi);
      
      final centerX = (explosion * 137.5) % size.width;
      final centerY = (explosion * 97.3) % size.height;
      final center = Offset(centerX, centerY);
      
      if (explosionProgress < 0.8) { // Explosion phase
        final particleCount = 100 + explosion * 20;
        
        for (int particle = 0; particle < particleCount; particle++) {
          final particleAngle = (particle / particleCount) * 2 * math.pi + explosion;
          final speed = (1 + (particle % 5) * 0.2) * intensity;
          final distance = explosionProgress * 200 * speed;
          
          final x = center.dx + distance * math.cos(particleAngle);
          final y = center.dy + distance * math.sin(particleAngle) + 
                    explosionProgress * explosionProgress * 50; // Gravity
          
          final fade = 1.0 - explosionProgress;
          final colorIndex = (particle ~/ 10 + explosion) % colors.length;
          
          final particlePaint = createPaint(
            colors[colorIndex].withValues(alpha: fade * 0.8 * opacity),
            withGlow: enableGlow,
          );
          
          final particleSize = (2 + particle % 4) * intensity * fade;
          
          // Different particle shapes
          switch (particle % 3) {
            case 0:
              canvas.drawCircle(Offset(x, y), particleSize, particlePaint);
              break;
            case 1:
              canvas.drawRect(
                Rect.fromCenter(center: Offset(x, y), width: particleSize * 2, height: particleSize * 2),
                particlePaint,
              );
              break;
            case 2:
              final starPath = Path();
              _drawStar(starPath, Offset(x, y), particleSize, 5);
              canvas.drawPath(starPath, particlePaint);
              break;
          }
        }
      }
    }
  }
  
  void _drawStar(Path path, Offset center, double size, int points) {
    final angleStep = math.pi / points;
    path.moveTo(center.dx, center.dy - size);
    
    for (int i = 1; i < points * 2; i++) {
      final angle = i * angleStep - math.pi / 2;
      final radius = (i % 2 == 0) ? size : size * 0.5;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      path.lineTo(x, y);
    }
    path.close();
  }
}

class OrbitalDancePainter extends AnimatedCanvasPainter {
  OrbitalDancePainter({
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
    
    // Central star
    final centralPaint = createPaint(
      colors[0].withValues(alpha: 0.9 * opacity),
      withGlow: enableGlow,
    );
    final centralPulse = (math.sin(time * 4) * 0.2 + 1.0);
    canvas.drawCircle(center, 25 * intensity * centralPulse, centralPaint);
    
    // Orbiting objects with different orbital mechanics
    final orbitCount = colors.length + 2;
    
    for (int orbit = 0; orbit < orbitCount; orbit++) {
      final orbitRadius = (60 + orbit * 40) * intensity;
      final orbitSpeed = 1.0 - orbit * 0.1;
      final eccentricity = orbit * 0.1; // Elliptical orbits
      
      // Main orbital angle
      final mainAngle = time * orbitSpeed + orbit * math.pi / 4;
      
      // Elliptical orbit calculation
      final a = orbitRadius * (1 + eccentricity); // Semi-major axis
      final b = orbitRadius * (1 - eccentricity); // Semi-minor axis
      
      final x = center.dx + a * math.cos(mainAngle);
      final y = center.dy + b * math.sin(mainAngle);
      final planetPos = Offset(x, y);
      
      // Draw orbit path
      final orbitPaint = Paint()
        ..color = colors[orbit % colors.length].withValues(alpha: 0.3 * opacity)
        ..strokeWidth = 1 * intensity
        ..style = PaintingStyle.stroke;
      
      canvas.drawOval(
        Rect.fromCenter(center: center, width: a * 2, height: b * 2),
        orbitPaint,
      );
      
      // Draw planet
      final planetPaint = createPaint(
        colors[orbit % colors.length].withValues(alpha: 0.8 * opacity),
        withGlow: enableGlow,
      );
      
      final planetSize = (8 + orbit * 2) * intensity;
      canvas.drawCircle(planetPos, planetSize, planetPaint);
      
      // Draw moons for some planets
      if (orbit % 2 == 0 && orbit > 0) {
        final moonCount = 1 + orbit ~/ 3;
        for (int moon = 0; moon < moonCount; moon++) {
          final moonAngle = time * (2 + moon) + mainAngle + moon * math.pi;
          final moonRadius = planetSize * (2 + moon);
          
          final moonX = planetPos.dx + moonRadius * math.cos(moonAngle);
          final moonY = planetPos.dy + moonRadius * math.sin(moonAngle);
          
          final moonPaint = createPaint(
            colors[(orbit + moon + 1) % colors.length].withValues(alpha: 0.6 * opacity),
            withGlow: enableGlow,
          );
          
          canvas.drawCircle(Offset(moonX, moonY), 3 * intensity, moonPaint);
        }
      }
      
      // Draw trailing path
      final trailLength = 20;
      for (int trail = 1; trail < trailLength; trail++) {
        final trailAngle = mainAngle - trail * 0.1;
        final trailX = center.dx + a * math.cos(trailAngle);
        final trailY = center.dy + b * math.sin(trailAngle);
        
        final trailFade = 1.0 - (trail / trailLength);
        final trailPaint = createPaint(
          colors[orbit % colors.length].withValues(alpha: trailFade * 0.4 * opacity),
          withGlow: false,
        );
        
        canvas.drawCircle(Offset(trailX, trailY), planetSize * trailFade * 0.5, trailPaint);
      }
    }
  }
}

// NEW IMAGE-INSPIRED CANVAS DESIGNS

class RadialBurstPainter extends AnimatedCanvasPainter {
  RadialBurstPainter({
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
    final maxRadius = math.max(size.width, size.height) * 0.7;
    
    // Number of rays
    final rayCount = 12 + colors.length * 2;
    
    for (int i = 0; i < rayCount; i++) {
      final angle = (i / rayCount) * 2 * math.pi + time * 0.1;
      final colorIndex = i % colors.length;
      
      // Create ray path
      final path = Path();
      final rayWidth = (10 + i % 8) * intensity;
      final rayLength = maxRadius * (0.8 + math.sin(time + i * 0.5) * 0.2);
      
      // Ray vertices
      final tipX = center.dx + rayLength * math.cos(angle);
      final tipY = center.dy + rayLength * math.sin(angle);
      
      final baseWidth = rayWidth * 0.3;
      final baseLeft = center + Offset(
        baseWidth * math.cos(angle + math.pi / 2),
        baseWidth * math.sin(angle + math.pi / 2),
      );
      final baseRight = center + Offset(
        baseWidth * math.cos(angle - math.pi / 2),
        baseWidth * math.sin(angle - math.pi / 2),
      );
      
      path.moveTo(tipX, tipY);
      path.lineTo(baseLeft.dx, baseLeft.dy);
      path.lineTo(baseRight.dx, baseRight.dy);
      path.close();
      
      // Create gradient for ray
      final gradient = LinearGradient(
        begin: Alignment.center,
        end: Alignment(math.cos(angle), math.sin(angle)),
        colors: [
          colors[colorIndex].withValues(alpha: 0.1 * opacity),
          colors[colorIndex].withValues(alpha: 0.8 * opacity),
          colors[colorIndex].withValues(alpha: 0.3 * opacity),
        ],
        stops: const [0.0, 0.7, 1.0],
      );
      
      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;
      
      if (enableGlow) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
      }
      
      canvas.drawPath(path, paint);
    }
    
    // Draw center glow
    final centerPaint = createPaint(
      colors[0].withValues(alpha: 0.9 * opacity),
      withGlow: enableGlow,
    );
    canvas.drawCircle(center, 20 * intensity, centerPaint);
  }
}

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

class RadialSunsetPainter extends AnimatedCanvasPainter {
  RadialSunsetPainter({
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
    final maxRadius = math.max(size.width, size.height) * 0.8;
    
    // Create multiple radial layers
    for (int ring = 0; ring < 8; ring++) {
      final radius = maxRadius * (ring + 1) / 8;
      final pulse = math.sin(time * 0.5 + ring * 0.3) * 0.1 + 1.0;
      final adjustedRadius = radius * pulse * intensity;
      
      final colorIndex = ring % colors.length;
      final nextColorIndex = (ring + 1) % colors.length;
      
      final gradient = RadialGradient(
        center: Alignment.center,
        radius: 0.8,
        colors: [
          colors[colorIndex].withValues(alpha: (0.8 - ring * 0.1) * opacity),
          colors[nextColorIndex].withValues(alpha: (0.4 - ring * 0.05) * opacity),
        ],
      );
      
      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: adjustedRadius))
        ..style = PaintingStyle.fill;
      
      if (enableGlow) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius * (1 - ring * 0.1));
      }
      
      canvas.drawCircle(center, adjustedRadius, paint);
    }
  }
}

class RainbowFlowPainter extends AnimatedCanvasPainter {
  RainbowFlowPainter({
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
    
    // Create flowing rainbow bands
    for (int band = 0; band < colors.length; band++) {
      final bandTime = time + band * 0.5;
      final bandHeight = size.height / colors.length;
      final yOffset = band * bandHeight;
      
      final path = Path();
      path.moveTo(0, yOffset + bandHeight);
      
      // Create curved flow
      for (double x = 0; x <= size.width; x += 2) {
        final wave = math.sin((x / size.width) * 3 * math.pi + bandTime) * 30 * intensity;
        final flow = math.sin((x / size.width) * 1.5 * math.pi + bandTime * 0.7) * 20 * intensity;
        
        final y = yOffset + wave + flow;
        path.lineTo(x, y);
      }
      
      // Close the band
      path.lineTo(size.width, yOffset + bandHeight + 50);
      path.lineTo(0, yOffset + bandHeight + 50);
      path.close();
      
      final gradient = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          colors[band].withValues(alpha: 0.3 * opacity),
          colors[band].withValues(alpha: 0.8 * opacity),
          colors[band].withValues(alpha: 0.3 * opacity),
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

class AngularWavesPainter extends AnimatedCanvasPainter {
  AngularWavesPainter({
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
    
    // Create angular geometric waves
    for (int layer = 0; layer < colors.length; layer++) {
      final layerTime = time + layer * 0.4;
      final path = Path();
      
      final segments = 8 + layer * 2;
      final segmentWidth = size.width / segments;
      final baseHeight = size.height * (0.3 + layer * 0.2);
      
      path.moveTo(0, size.height);
      path.lineTo(0, baseHeight);
      
      for (int segment = 0; segment < segments; segment++) {
        final x = segment * segmentWidth;
        final nextX = (segment + 1) * segmentWidth;
        
        final wave = math.sin(layerTime + segment * 0.8) * 100 * intensity;
        final y = baseHeight + wave;
        
        // Create angular transitions
        if (segment % 2 == 0) {
          path.lineTo(x + segmentWidth * 0.7, y);
          path.lineTo(nextX, y + wave * 0.3);
        } else {
          path.lineTo(x + segmentWidth * 0.3, y);
          path.lineTo(nextX, y - wave * 0.3);
        }
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

class SmoothGradientsPainter extends AnimatedCanvasPainter {
  SmoothGradientsPainter({
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
    
    // Create smooth flowing gradients
    for (int blob = 0; blob < 5; blob++) {
      final blobTime = time + blob * 1.2;
      final centerX = size.width * (0.2 + (blob * 0.15) % 0.6) + 
                     math.sin(blobTime * 0.3) * 100 * intensity;
      final centerY = size.height * (0.3 + (blob * 0.2) % 0.4) + 
                      math.cos(blobTime * 0.25) * 80 * intensity;
      
      final radiusX = (150 + blob * 30 + math.sin(blobTime) * 50) * intensity;
      final radiusY = (120 + blob * 25 + math.cos(blobTime * 1.1) * 40) * intensity;
      
      final gradient = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          colors[blob % colors.length].withValues(alpha: 0.6 * opacity),
          colors[blob % colors.length].withValues(alpha: 0.3 * opacity),
          colors[blob % colors.length].withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.6, 1.0],
      );
      
      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: radiusX * 2,
          height: radiusY * 2,
        ))
        ..style = PaintingStyle.fill;
      
      if (enableGlow) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
      }
      
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: radiusX * 2,
          height: radiusY * 2,
        ),
        paint,
      );
    }
  }
}

class PrismEffectPainter extends AnimatedCanvasPainter {
  PrismEffectPainter({
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
    
    // Create prism light refraction effect
    for (int ray = 0; ray < colors.length * 3; ray++) {
      final rayAngle = (ray / (colors.length * 3)) * 2 * math.pi + time * 0.1;
      final colorIndex = ray % colors.length;
      
      // Light ray properties
      final rayLength = (200 + ray * 20) * intensity;
      final rayWidth = (8 + ray % 6) * intensity;
      final dispersion = math.sin(time + ray * 0.3) * 0.2; // Prism dispersion
      
      final startX = center.dx;
      final startY = center.dy;
      final endX = center.dx + rayLength * math.cos(rayAngle + dispersion);
      final endY = center.dy + rayLength * math.sin(rayAngle + dispersion);
      
      // Create beam path
      final path = Path();
      final perpX = rayWidth * math.cos(rayAngle + math.pi / 2 + dispersion);
      final perpY = rayWidth * math.sin(rayAngle + math.pi / 2 + dispersion);
      
      path.moveTo(startX + perpX, startY + perpY);
      path.lineTo(startX - perpX, startY - perpY);
      path.lineTo(endX - perpX, endY - perpY);
      path.lineTo(endX + perpX, endY + perpY);
      path.close();
      
      final gradient = LinearGradient(
        begin: Alignment.center,
        end: Alignment(math.cos(rayAngle + dispersion), math.sin(rayAngle + dispersion)),
        colors: [
          colors[colorIndex].withValues(alpha: 0.8 * opacity),
          colors[colorIndex].withValues(alpha: 0.1 * opacity),
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
    
    // Draw prism center
    final prismPaint = createPaint(
      Colors.white.withValues(alpha: 0.9 * opacity),
      withGlow: enableGlow,
    );
    canvas.drawCircle(center, 15 * intensity, prismPaint);
  }
}

class LiquidFlowPainter extends AnimatedCanvasPainter {
  LiquidFlowPainter({
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
    
    // Create liquid flow streams
    for (int stream = 0; stream < colors.length; stream++) {
      final streamTime = time + stream * 0.8;
      final path = Path();
      
      final startX = size.width * (stream / colors.length);
      final controlPoints = <Offset>[];
      
      // Generate flowing control points
      for (int point = 0; point <= 10; point++) {
        final progress = point / 10;
        final x = startX + progress * size.width * 0.8 + 
                  math.sin(streamTime + point * 0.5) * 60 * intensity;
        final y = progress * size.height + 
                  math.cos(streamTime * 1.2 + point * 0.3) * 40 * intensity;
        controlPoints.add(Offset(x, y));
      }
      
      // Create smooth curved path
      path.moveTo(controlPoints[0].dx, controlPoints[0].dy);
      
      for (int i = 1; i < controlPoints.length - 1; i++) {
        final current = controlPoints[i];
        final next = controlPoints[i + 1];
        final controlPoint = Offset(
          (current.dx + next.dx) / 2,
          current.dy,
        );
        path.quadraticBezierTo(current.dx, current.dy, controlPoint.dx, controlPoint.dy);
      }
      
      // Add thickness to the stream
      final thickPath = Path();
      final streamWidth = 20 * intensity;
      
      for (int i = 0; i < controlPoints.length; i++) {
        final point = controlPoints[i];
        final thickness = streamWidth * (1 - i / controlPoints.length * 0.5);
        
        if (i == 0) {
          thickPath.addOval(Rect.fromCircle(center: point, radius: thickness));
        } else {
          final prevPoint = controlPoints[i - 1];
          final direction = (point - prevPoint).normalizeOffset();
          final perpendicular = Offset(-direction.dy, direction.dx);
          
          final left = point + perpendicular * thickness;
          final right = point - perpendicular * thickness;
          
          thickPath.addOval(Rect.fromCircle(center: left, radius: thickness * 0.5));
          thickPath.addOval(Rect.fromCircle(center: right, radius: thickness * 0.5));
        }
      }
      
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors[stream].withValues(alpha: 0.8 * opacity),
          colors[stream].withValues(alpha: 0.3 * opacity),
        ],
      );
      
      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;
      
      if (enableGlow) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
      }
      
      canvas.drawPath(thickPath, paint);
    }
  }
}

class EnergyFieldPainter extends AnimatedCanvasPainter {
  EnergyFieldPainter({
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
    
    // Create energy field grid
    final gridSize = 30 * intensity;
    final rows = (size.height / gridSize).ceil();
    final cols = (size.width / gridSize).ceil();
    
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final x = col * gridSize;
        final y = row * gridSize;
        final centerX = x + gridSize / 2;
        final centerY = y + gridSize / 2;
        
        // Calculate energy intensity based on distance and time
        final distanceFromCenter = (Offset(centerX, centerY) - 
                                  Offset(size.width / 2, size.height / 2)).distance;
        final normalizedDistance = distanceFromCenter / (size.width * 0.5);
        
        final energyLevel = math.sin(time * 2 + normalizedDistance * 4) * 0.5 + 0.5;
        final pulseLevel = math.sin(time * 3 + row * 0.5 + col * 0.3) * 0.3 + 0.7;
        
        if (energyLevel > 0.3) {
          final colorIndex = ((row + col + (time * 2).round()) % colors.length);
          final alpha = energyLevel * pulseLevel * opacity;
          
          final paint = createPaint(
            colors[colorIndex].withValues(alpha: alpha),
            withGlow: enableGlow,
          );
          
          final nodeSize = energyLevel * pulseLevel * 8 * intensity;
          canvas.drawCircle(Offset(centerX, centerY), nodeSize, paint);
          
          // Draw connections to nearby nodes
          if (col < cols - 1 && energyLevel > 0.5) {
            final rightX = (col + 1) * gridSize + gridSize / 2;
            final connectionPaint = Paint()
              ..color = colors[colorIndex].withValues(alpha: alpha * 0.5)
              ..strokeWidth = energyLevel * 2 * intensity
              ..style = PaintingStyle.stroke;
            
            canvas.drawLine(
              Offset(centerX, centerY),
              Offset(rightX, centerY),
              connectionPaint,
            );
          }
          
          if (row < rows - 1 && energyLevel > 0.5) {
            final bottomY = (row + 1) * gridSize + gridSize / 2;
            final connectionPaint = Paint()
              ..color = colors[colorIndex].withValues(alpha: alpha * 0.5)
              ..strokeWidth = energyLevel * 2 * intensity
              ..style = PaintingStyle.stroke;
            
            canvas.drawLine(
              Offset(centerX, centerY),
              Offset(centerX, bottomY),
              connectionPaint,
            );
          }
        }
      }
    }
  }
}

class DimensionalRiftPainter extends AnimatedCanvasPainter {
  DimensionalRiftPainter({
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
    
    // Create dimensional rift effect
    final riftPath = Path();
    final riftPoints = <Offset>[];
    
    // Generate rift shape
    for (int i = 0; i < 20; i++) {
      final angle = (i / 20) * 2 * math.pi;
      final distortion = math.sin(time + i * 0.3) * 0.3 + 1.0;
      final radius = (100 + math.sin(time * 2 + i * 0.5) * 50) * intensity * distortion;
      
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      riftPoints.add(Offset(x, y));
    }
    
    // Create smooth rift outline
    riftPath.moveTo(riftPoints[0].dx, riftPoints[0].dy);
    for (int i = 1; i < riftPoints.length; i++) {
      final current = riftPoints[i];
      final next = riftPoints[(i + 1) % riftPoints.length];
      final controlPoint = Offset(
        (current.dx + next.dx) / 2,
        (current.dy + next.dy) / 2,
      );
      riftPath.quadraticBezierTo(current.dx, current.dy, controlPoint.dx, controlPoint.dy);
    }
    riftPath.close();
    
    // Draw rift layers
    for (int layer = 0; layer < 8; layer++) {
      final layerScale = (8 - layer) / 8;
      final layerPath = Path();
      
      for (final point in riftPoints) {
        final scaledPoint = center + (point - center) * layerScale;
        if (layerPath.getBounds().isEmpty) {
          layerPath.moveTo(scaledPoint.dx, scaledPoint.dy);
        } else {
          layerPath.lineTo(scaledPoint.dx, scaledPoint.dy);
        }
      }
      layerPath.close();
      
      final colorIndex = layer % colors.length;
      final gradient = RadialGradient(
        center: Alignment.center,
        radius: layerScale,
        colors: [
          colors[colorIndex].withValues(alpha: (0.8 - layer * 0.1) * opacity),
          colors[colorIndex].withValues(alpha: 0.0),
        ],
      );
      
      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;
      
      if (enableGlow) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius * layerScale);
      }
      
      canvas.drawPath(layerPath, paint);
    }
    
    // Draw dimensional particles
    for (int particle = 0; particle < 30; particle++) {
      final particleAngle = (particle / 30) * 2 * math.pi + time;
      final particleRadius = (80 + particle * 10) * intensity;
      final particleSize = (2 + particle % 4) * intensity;
      
      final particleX = center.dx + particleRadius * math.cos(particleAngle);
      final particleY = center.dy + particleRadius * math.sin(particleAngle);
      
      final colorIndex = particle % colors.length;
      final particlePaint = createPaint(
        colors[colorIndex].withValues(alpha: 0.8 * opacity),
        withGlow: enableGlow,
      );
      
      canvas.drawCircle(Offset(particleX, particleY), particleSize, particlePaint);
    }
  }
}