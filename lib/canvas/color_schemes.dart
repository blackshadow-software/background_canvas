import 'package:flutter/material.dart';

class BackgroundCanvasColorSchemes {
  static const List<Color> oceanBlue = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
    Color(0xFF6B73FF),
  ];

  static const List<Color> sunsetGradient = [
    Color(0xFFFF512F),
    Color(0xFFDD2476),
    Color(0xFFFF8A00),
  ];

  static const List<Color> forestGreen = [
    Color(0xFF8360c3),
    Color(0xFF2ebf91),
    Color(0xFF5D26C1),
  ];

  static const List<Color> neonMint = [
    Color(0xFF11998e),
    Color(0xFF38ef7d),
    Color(0xFF00d2ff),
  ];

  static const List<Color> purpleDream = [
    Color(0xFFf093fb),
    Color(0xFFf5576c),
    Color(0xFF4facfe),
  ];

  static const List<Color> darkMatter = [
    Color(0xFF1e3c72),
    Color(0xFF2a5298),
    Color(0xFF000428),
  ];

  static const List<Color> fireAndIce = [
    Color(0xFFff9966),
    Color(0xFFff5e62),
    Color(0xFF56CCF2),
  ];

  static const List<Color> cosmicFusion = [
    Color(0xFFffecd2),
    Color(0xFFfcb69f),
    Color(0xFFa8edea),
    Color(0xFFfed6e3),
  ];

  static const List<Color> retroWave = [
    Color(0xFFf12711),
    Color(0xFFf5af19),
    Color(0xFF667eea),
  ];

  static const List<Color> synthWave = [
    Color(0xFF8360c3),
    Color(0xFF2ebf91),
    Color(0xFFFF0080),
    Color(0xFF00FFFF),
  ];

  static List<Color> generateRandomScheme({int colorCount = 3}) {
    final List<Color> colors = [];
    for (int i = 0; i < colorCount; i++) {
      colors.add(Color.fromARGB(
        255,
        (i * 100 + 50) % 255,
        (i * 150 + 100) % 255,
        (i * 200 + 150) % 255,
      ));
    }
    return colors;
  }

  static List<Color> complementaryScheme(Color baseColor, {int variations = 2}) {
    final HSVColor hsv = HSVColor.fromColor(baseColor);
    final List<Color> colors = [baseColor];
    
    for (int i = 1; i <= variations; i++) {
      final double hueShift = (360.0 / (variations + 1)) * i;
      final HSVColor shifted = hsv.withHue((hsv.hue + hueShift) % 360);
      colors.add(shifted.toColor());
    }
    
    return colors;
  }

  static List<Color> analogousScheme(Color baseColor, {int variations = 2}) {
    final HSVColor hsv = HSVColor.fromColor(baseColor);
    final List<Color> colors = [baseColor];
    
    for (int i = 1; i <= variations; i++) {
      final double hueShift = 30.0 * i;
      final HSVColor shifted = hsv.withHue((hsv.hue + hueShift) % 360);
      colors.add(shifted.toColor());
    }
    
    return colors;
  }

  static List<Color> monochromaticScheme(Color baseColor, {int variations = 2}) {
    final HSVColor hsv = HSVColor.fromColor(baseColor);
    final List<Color> colors = [baseColor];
    
    for (int i = 1; i <= variations; i++) {
      final double saturationShift = 0.3 * i;
      final double valueShift = 0.2 * i;
      
      final HSVColor shifted = hsv.withSaturation(
        (hsv.saturation - saturationShift).clamp(0.0, 1.0)
      ).withValue(
        (hsv.value + valueShift).clamp(0.0, 1.0)
      );
      
      colors.add(shifted.toColor());
    }
    
    return colors;
  }

  static Map<String, List<Color>> get allPresets => {
    'Ocean Blue': oceanBlue,
    'Sunset Gradient': sunsetGradient,
    'Forest Green': forestGreen,
    'Neon Mint': neonMint,
    'Purple Dream': purpleDream,
    'Dark Matter': darkMatter,
    'Fire and Ice': fireAndIce,
    'Cosmic Fusion': cosmicFusion,
    'Retro Wave': retroWave,
    'Synth Wave': synthWave,
  };
}