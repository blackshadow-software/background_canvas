import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../base_painter.dart';

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