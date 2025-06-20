import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'base_painter.dart';

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