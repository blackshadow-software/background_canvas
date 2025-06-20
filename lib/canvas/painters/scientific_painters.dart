import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'base_painter.dart';

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
    final nodeCount = 30 + colors.length * 5;
    final nodes = <Map<String, dynamic>>[];
    
    // Generate nodes
    for (int i = 0; i < nodeCount; i++) {
      final x = (i * 127.3) % size.width;
      final y = (i * 89.7) % size.height;
      final activity = math.sin(time * 2 + i * 0.3) * 0.5 + 0.5;
      
      nodes.add({
        'position': Offset(x, y),
        'activity': activity,
        'colorIndex': i % colors.length,
      });
    }
    
    // Draw connections
    for (int i = 0; i < nodes.length; i++) {
      final node1 = nodes[i];
      final pos1 = node1['position'] as Offset;
      
      for (int j = i + 1; j < nodes.length; j++) {
        final node2 = nodes[j];
        final pos2 = node2['position'] as Offset;
        final distance = (pos1 - pos2).distance;
        
        if (distance < 100 * intensity) {
          final connectionStrength = 1.0 - (distance / (100 * intensity));
          final activity1 = node1['activity'] as double;
          final activity2 = node2['activity'] as double;
          final signalStrength = connectionStrength * (activity1 + activity2) / 2;
          
          if (signalStrength > 0.3) {
            final paint = Paint()
              ..color = colors[node1['colorIndex']].withValues(alpha: signalStrength * opacity)
              ..strokeWidth = signalStrength * 3 * intensity
              ..style = PaintingStyle.stroke;
            
            canvas.drawLine(pos1, pos2, paint);
          }
        }
      }
    }
    
    // Draw nodes
    for (final node in nodes) {
      final pos = node['position'] as Offset;
      final activity = node['activity'] as double;
      final colorIndex = node['colorIndex'] as int;
      
      final paint = createPaint(
        colors[colorIndex].withValues(alpha: (0.5 + activity * 0.5) * opacity),
        withGlow: enableGlow,
      );
      
      final nodeSize = (5 + activity * 10) * intensity;
      canvas.drawCircle(pos, nodeSize, paint);
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
    final crystalCount = colors.length + 3;
    
    for (int crystal = 0; crystal < crystalCount; crystal++) {
      final crystalTime = time + crystal * 0.7;
      final angle = (crystal / crystalCount) * 2 * math.pi + crystalTime * 0.1;
      final distance = (80 + crystal * 30) * intensity;
      
      final crystalCenter = center + Offset(
        distance * math.cos(angle),
        distance * math.sin(angle),
      );
      
      _drawCrystal(canvas, crystalCenter, crystal, crystalTime);
    }
  }
  
  void _drawCrystal(Canvas canvas, Offset center, int crystalIndex, double time) {
    final sides = 6 + (crystalIndex % 3);
    final crystalSize = (20 + crystalIndex * 8) * intensity;
    final growth = math.sin(time) * 0.3 + 1.0;
    final colorIndex = crystalIndex % colors.length;
    
    // Draw crystal facets
    for (int layer = 0; layer < 3; layer++) {
      final layerSize = crystalSize * growth * (1 - layer * 0.2);
      final layerAlpha = (0.8 - layer * 0.2) * opacity;
      
      final path = Path();
      for (int i = 0; i < sides; i++) {
        final angle = (i / sides) * 2 * math.pi + time * 0.1;
        final x = center.dx + layerSize * math.cos(angle);
        final y = center.dy + layerSize * math.sin(angle);
        
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      
      final gradient = RadialGradient(
        center: Alignment.center,
        colors: [
          colors[colorIndex].withValues(alpha: layerAlpha),
          colors[colorIndex].withValues(alpha: layerAlpha * 0.3),
        ],
      );
      
      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: layerSize))
        ..style = PaintingStyle.fill;
      
      if (enableGlow && layer == 0) {
        paint.maskFilter = MaskFilter.blur(BlurStyle.outer, glowRadius);
      }
      
      canvas.drawPath(path, paint);
    }
    
    // Draw crystal lines
    final linePaint = Paint()
      ..color = colors[colorIndex].withValues(alpha: 0.6 * opacity)
      ..strokeWidth = 1 * intensity
      ..style = PaintingStyle.stroke;
    
    for (int i = 0; i < sides; i++) {
      final angle = (i / sides) * 2 * math.pi + time * 0.1;
      final x = center.dx + crystalSize * growth * math.cos(angle);
      final y = center.dy + crystalSize * growth * math.sin(angle);
      
      canvas.drawLine(center, Offset(x, y), linePaint);
    }
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
    final particleCount = 50 + colors.length * 10;
    
    for (int i = 0; i < particleCount; i++) {
      final particleTime = time + i * 0.1;
      
      // Quantum probability cloud
      final baseX = (i * 73.7) % size.width;
      final baseY = (i * 127.3) % size.height;
      
      // Uncertainty principle - position becomes more uncertain over time
      final uncertainty = math.sin(particleTime * 2) * 50 * intensity;
      final x = baseX + math.sin(particleTime) * uncertainty;
      final y = baseY + math.cos(particleTime * 1.3) * uncertainty;
      
      // Quantum tunneling effect
      final tunnelProbability = math.sin(particleTime * 3) * 0.5 + 0.5;
      
      if (tunnelProbability > 0.3) {
        final colorIndex = i % colors.length;
        
        // Wave-particle duality visualization
        final waveAmplitude = math.sin(particleTime * 4) * 20 * intensity;
        final particleSize = (2 + tunnelProbability * 8) * intensity;
        
        // Draw wave function
        final wavePath = Path();
        for (double t = -math.pi; t <= math.pi; t += 0.2) {
          final waveX = x + t * 20;
          final waveY = y + waveAmplitude * math.sin(t * 3 + particleTime);
          
          if (t == -math.pi) {
            wavePath.moveTo(waveX, waveY);
          } else {
            wavePath.lineTo(waveX, waveY);
          }
        }
        
        final wavePaint = Paint()
          ..color = colors[colorIndex].withValues(alpha: 0.4 * opacity)
          ..strokeWidth = 1 * intensity
          ..style = PaintingStyle.stroke;
        
        canvas.drawPath(wavePath, wavePaint);
        
        // Draw particle
        final particlePaint = createPaint(
          colors[colorIndex].withValues(alpha: tunnelProbability * opacity),
          withGlow: enableGlow,
        );
        
        canvas.drawCircle(Offset(x, y), particleSize, particlePaint);
        
        // Quantum entanglement lines
        if (i < particleCount / 2) {
          final entangledIndex = i + particleCount ~/ 2;
          final entangledX = (entangledIndex * 73.7) % size.width;
          final entangledY = (entangledIndex * 127.3) % size.height;
          
          final entanglementPaint = Paint()
            ..color = colors[colorIndex].withValues(alpha: 0.2 * opacity)
            ..strokeWidth = 0.5 * intensity
            ..style = PaintingStyle.stroke;
          
          canvas.drawLine(Offset(x, y), Offset(entangledX, entangledY), entanglementPaint);
        }
      }
    }
  }
}