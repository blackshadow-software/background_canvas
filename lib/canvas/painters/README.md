# Canvas Painters Organization

This directory contains all canvas painter classes organized into logical categories for better maintainability and modularity.

## Directory Structure

```
painters/
├── base_painter.dart              # Base classes and utilities
├── all_painters.dart              # Main export file
├── README.md                      # This documentation
│
├── basic/                         # Basic patterns
│   ├── index.dart                 # Category exports
│   └── fluid_waves_painter.dart   # Fluid waves implementation
│
├── geometric/                     # Geometric patterns
│   ├── index.dart
│   └── geometric_shapes_painter.dart
│
├── patterns/                      # Abstract patterns
│   ├── index.dart
│   ├── organic_blobs_painter.dart
│   ├── layered_curves_painter.dart
│   ├── abstract_flow_painter.dart
│   └── fractal_tree_painter.dart
│
├── simulations/                   # Physics simulations
│   ├── index.dart
│   └── particle_field_painter.dart
│
├── advanced/                      # Advanced patterns
│   ├── index.dart
│   ├── spiral_galaxy_painter.dart
│   └── noise_field_painter.dart
│
├── effects/                       # Special effects
│   ├── index.dart
│   └── liquid_metal_painter.dart
│
├── scientific/                    # Scientific visualizations
│   ├── index.dart
│   └── neural_network_painter.dart
│
├── molecular/                     # Molecular simulations
│   ├── index.dart
│   └── molecular_structure_painter.dart
│
├── inspired/                      # Image-inspired designs
│   └── index.dart
│
└── [legacy files]                 # For backward compatibility
    ├── basic_painters.dart
    ├── advanced_painters.dart
    ├── scientific_painters.dart
    ├── effects_painters.dart
    └── inspired_painters.dart
```

## Usage

### Import everything:
```dart
import 'package:background_canvas/canvas/painters/all_painters.dart';
```

### Import specific categories:
```dart
import 'package:background_canvas/canvas/painters/basic/index.dart';
import 'package:background_canvas/canvas/painters/scientific/index.dart';
```

### Import individual painters:
```dart
import 'package:background_canvas/canvas/painters/basic/fluid_waves_painter.dart';
import 'package:background_canvas/canvas/painters/molecular/molecular_structure_painter.dart';
```

## Adding New Painters

1. Create the painter file in the appropriate category directory
2. Add the export to the category's `index.dart` file
3. Ensure it extends `AnimatedCanvasPainter` from `base_painter.dart`

## Categories

- **basic/**: Simple, fundamental patterns (waves, flows)
- **geometric/**: Geometric shapes and mathematical patterns
- **patterns/**: Abstract artistic patterns (blobs, curves, fractals)
- **simulations/**: Physics-based simulations (particles, fields)
- **advanced/**: Complex mathematical visualizations (galaxies, noise)
- **effects/**: Special visual effects (metals, lighting)
- **scientific/**: Scientific visualizations (neural networks, quantum)
- **molecular/**: Chemistry and molecular simulations
- **inspired/**: Patterns inspired by images or real-world phenomena