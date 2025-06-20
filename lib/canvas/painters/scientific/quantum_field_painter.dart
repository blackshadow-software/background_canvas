import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

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