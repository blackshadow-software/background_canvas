import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

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