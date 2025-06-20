# Background Canvas

A Flutter package for creating dynamic, animated canvas backgrounds with mathematical patterns and customizable color schemes.

## Features

- 🎨 **6 Different Pattern Types**: Fluid waves, geometric shapes, organic blobs, layered curves, particle fields, and abstract flows
- 🌈 **Predefined Color Schemes**: 10+ beautiful preset color combinations
- 🎭 **Custom Color Support**: Create backgrounds with any color palette
- ⚡ **Smooth Animations**: Configurable animation speed and intensity
- 🎛️ **Highly Customizable**: Control intensity, animation, and timing
- 📐 **Mathematical Precision**: Canvas patterns generated using mathematical functions
- 🚀 **Performance Optimized**: Efficient rendering using Flutter's CustomPainter

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  background_canvas: ^1.0.0
```

## Usage

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:background_canvas/background_canvas.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundCanvasWidget(
        colors: BackgroundCanvasColorSchemes.oceanBlue,
        type: BackgroundCanvasType.fluidWaves,
        child: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
```

### Pattern Types

- `BackgroundCanvasType.fluidWaves` - Flowing wave patterns
- `BackgroundCanvasType.geometricShapes` - Animated geometric shapes
- `BackgroundCanvasType.organicBlobs` - Organic blob formations
- `BackgroundCanvasType.layeredCurves` - Layered curve patterns
- `BackgroundCanvasType.particleField` - Particle field animations
- `BackgroundCanvasType.abstractFlow` - Abstract flowing patterns

### Color Schemes

```dart
// Use predefined color schemes
BackgroundCanvasColorSchemes.oceanBlue
BackgroundCanvasColorSchemes.sunsetGradient
BackgroundCanvasColorSchemes.purpleDream
BackgroundCanvasColorSchemes.neonMint

// Or create custom colors
List<Color> customColors = [
  Color(0xFF667eea),
  Color(0xFF764ba2),
  Color(0xFF6B73FF),
];
```

### Advanced Configuration

```dart
BackgroundCanvasWidget(
  colors: BackgroundCanvasColorSchemes.cosmicFusion,
  type: BackgroundCanvasType.organicBlobs,
  animated: true,
  animationDuration: Duration(seconds: 4),
  intensity: 1.5,
  child: YourWidget(),
)
```

### Generate Color Schemes

```dart
// Generate complementary colors
List<Color> complementary = BackgroundCanvasColorSchemes.complementaryScheme(
  Colors.blue, 
  variations: 3
);

// Generate analogous colors
List<Color> analogous = BackgroundCanvasColorSchemes.analogousScheme(
  Colors.red, 
  variations: 2
);

// Generate monochromatic scheme
List<Color> monochromatic = BackgroundCanvasColorSchemes.monochromaticScheme(
  Colors.purple, 
  variations: 3
);
```

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `colors` | `List<Color>` | **Required** | Colors to use for the background pattern |
| `type` | `BackgroundCanvasType` | `fluidWaves` | Type of pattern to render |
| `animated` | `bool` | `true` | Whether to animate the pattern |
| `animationDuration` | `Duration` | `Duration(seconds: 3)` | Duration of one animation cycle |
| `intensity` | `double` | `1.0` | Intensity of the pattern (0.1 - 2.0) |
| `child` | `Widget?` | `null` | Widget to display on top of the background |

## Example App

The package includes a comprehensive example app demonstrating all pattern types and color schemes. Run it with:

```bash
cd example
flutter run
```

## Mathematical Patterns

Each pattern type uses mathematical functions to create dynamic visuals:

- **Fluid Waves**: Sine and cosine functions with varying frequencies
- **Geometric Shapes**: Polygon generation with rotation matrices
- **Organic Blobs**: Bezier curves with harmonic oscillations
- **Layered Curves**: Multiple wave functions with phase shifts
- **Particle Field**: Pseudo-random positioning with smooth interpolation
- **Abstract Flow**: Parametric curves with time-based transformations

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.
