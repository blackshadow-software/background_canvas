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
    paint.color = color.withValues(alpha: color.opacity * opacity);
    
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