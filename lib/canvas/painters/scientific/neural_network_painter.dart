import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

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