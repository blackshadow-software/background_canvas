import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'base_painter.dart';

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
    final nodeCount = 20 + colors.length * 3;
    final nodes = <Map<String, dynamic>>[];
    
    // Generate cosmic nodes (galaxies)
    for (int i = 0; i < nodeCount; i++) {
      final angle = (i / nodeCount) * 2 * math.pi + time * 0.05;
      final radius = (50 + i * 20) * intensity;
      final centerX = size.width / 2 + radius * math.cos(angle);
      final centerY = size.height / 2 + radius * math.sin(angle);
      
      nodes.add({
        'position': Offset(centerX, centerY),
        'size': (10 + i % 15) * intensity,
        'colorIndex': i % colors.length,
        'energy': math.sin(time * 2 + i) * 0.5 + 0.5,
      });
    }
    
    // Draw cosmic filaments
    for (int i = 0; i < nodes.length; i++) {
      final node1 = nodes[i];
      final pos1 = node1['position'] as Offset;
      
      for (int j = i + 1; j < nodes.length; j++) {
        final node2 = nodes[j];
        final pos2 = node2['position'] as Offset;
        final distance = (pos1 - pos2).distance;
        
        if (distance < 150 * intensity) {
          final filamentStrength = 1.0 - (distance / (150 * intensity));
          final energy1 = node1['energy'] as double;
          final energy2 = node2['energy'] as double;
          
          // Create curved filament
          final controlPoint = Offset(
            (pos1.dx + pos2.dx) / 2 + math.sin(time + i + j) * 30 * intensity,
            (pos1.dy + pos2.dy) / 2 + math.cos(time + i + j) * 30 * intensity,
          );
          
          final path = Path();
          path.moveTo(pos1.dx, pos1.dy);
          path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, pos2.dx, pos2.dy);
          
          final filamentPaint = Paint()
            ..color = colors[node1['colorIndex']].withValues(alpha: filamentStrength * (energy1 + energy2) / 2 * opacity)
            ..strokeWidth = filamentStrength * 2 * intensity
            ..style = PaintingStyle.stroke;
          
          if (enableGlow) {
            filamentPaint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius * 0.5);
          }
          
          canvas.drawPath(path, filamentPaint);
        }
      }
    }
    
    // Draw cosmic nodes
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