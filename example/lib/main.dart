import 'package:flutter/material.dart';
import 'package:background_canvas/background_canvas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Background Canvas Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const BackgroundCanvasDemo(),
    );
  }
}

class BackgroundCanvasDemo extends StatefulWidget {
  const BackgroundCanvasDemo({super.key});

  @override
  State<BackgroundCanvasDemo> createState() => _BackgroundCanvasDemoState();
}

class _BackgroundCanvasDemoState extends State<BackgroundCanvasDemo> {
  BackgroundCanvasType currentType = BackgroundCanvasType.fluidWaves;
  List<Color> currentColors = BackgroundCanvasColorSchemes.oceanBlue;
  double intensity = 1.0;
  double speed = 1.0;
  double opacity = 1.0;
  bool animated = true;
  bool enableGlow = false;
  double glowRadius = 10.0;

  final List<Map<String, dynamic>> presets = [
    {
      'name': 'Ocean Waves',
      'type': BackgroundCanvasType.fluidWaves,
      'colors': BackgroundCanvasColorSchemes.oceanBlue,
    },
    {
      'name': 'Sunset Layers',
      'type': BackgroundCanvasType.layeredCurves,
      'colors': BackgroundCanvasColorSchemes.sunsetGradient,
    },
    {
      'name': 'Organic Blobs',
      'type': BackgroundCanvasType.organicBlobs,
      'colors': BackgroundCanvasColorSchemes.forestGreen,
    },
    {
      'name': 'Geometric Shapes',
      'type': BackgroundCanvasType.geometricShapes,
      'colors': BackgroundCanvasColorSchemes.neonMint,
    },
    {
      'name': 'Particle Field',
      'type': BackgroundCanvasType.particleField,
      'colors': BackgroundCanvasColorSchemes.retroWave,
    },
    {
      'name': 'Abstract Flow',
      'type': BackgroundCanvasType.abstractFlow,
      'colors': BackgroundCanvasColorSchemes.purpleDream,
    },
    {
      'name': 'Dark Matter',
      'type': BackgroundCanvasType.layeredCurves,
      'colors': BackgroundCanvasColorSchemes.darkMatter,
    },
    {
      'name': 'Cosmic Fusion',
      'type': BackgroundCanvasType.organicBlobs,
      'colors': BackgroundCanvasColorSchemes.cosmicFusion,
    },
    {
      'name': 'Spiral Galaxy',
      'type': BackgroundCanvasType.spiralGalaxy,
      'colors': BackgroundCanvasColorSchemes.darkMatter,
    },
    {
      'name': 'Liquid Metal',
      'type': BackgroundCanvasType.liquidMetal,
      'colors': BackgroundCanvasColorSchemes.synthWave,
    },
    {
      'name': 'Noise Field',
      'type': BackgroundCanvasType.noiseField,
      'colors': BackgroundCanvasColorSchemes.neonMint,
    },
    {
      'name': 'Fractal Tree',
      'type': BackgroundCanvasType.fractalTree,
      'colors': BackgroundCanvasColorSchemes.forestGreen,
    },
    {
      'name': 'Neural Network',
      'type': BackgroundCanvasType.neuralNetwork,
      'colors': BackgroundCanvasColorSchemes.synthWave,
    },
    {
      'name': 'Crystal Formation',
      'type': BackgroundCanvasType.crystalFormation,
      'colors': BackgroundCanvasColorSchemes.cosmicFusion,
    },
    {
      'name': 'Plasma Ball',
      'type': BackgroundCanvasType.plasmaBall,
      'colors': BackgroundCanvasColorSchemes.fireAndIce,
    },
    {
      'name': 'Quantum Field',
      'type': BackgroundCanvasType.quantumField,
      'colors': BackgroundCanvasColorSchemes.purpleDream,
    },
    {
      'name': 'Digital Rain',
      'type': BackgroundCanvasType.digitalRain,
      'colors': BackgroundCanvasColorSchemes.neonMint,
    },
    {
      'name': 'Cosmic Web',
      'type': BackgroundCanvasType.cosmicWeb,
      'colors': BackgroundCanvasColorSchemes.darkMatter,
    },
    {
      'name': 'Molecular Structure',
      'type': BackgroundCanvasType.molecularStructure,
      'colors': BackgroundCanvasColorSchemes.oceanBlue,
    },
    {
      'name': 'Wave Interference',
      'type': BackgroundCanvasType.waveInterference,
      'colors': BackgroundCanvasColorSchemes.sunsetGradient,
    },
    // New unique canvas designs
    {
      'name': 'Fireworks',
      'type': BackgroundCanvasType.fireworks,
      'colors': BackgroundCanvasColorSchemes.fireAndIce,
    },
    {
      'name': 'Aurora',
      'type': BackgroundCanvasType.aurora,
      'colors': BackgroundCanvasColorSchemes.cosmicFusion,
    },
    {
      'name': 'Honeycomb',
      'type': BackgroundCanvasType.honeycomb,
      'colors': BackgroundCanvasColorSchemes.neonMint,
    },
    {
      'name': 'Mandala',
      'type': BackgroundCanvasType.mandala,
      'colors': BackgroundCanvasColorSchemes.purpleDream,
    },
    {
      'name': 'DNA Helix',
      'type': BackgroundCanvasType.dnaHelix,
      'colors': BackgroundCanvasColorSchemes.synthWave,
    },
    {
      'name': 'Lava Lamp',
      'type': BackgroundCanvasType.lavaLamp,
      'colors': BackgroundCanvasColorSchemes.retroWave,
    },
    {
      'name': 'Electric Field',
      'type': BackgroundCanvasType.electricField,
      'colors': BackgroundCanvasColorSchemes.neonMint,
    },
    {
      'name': 'Magnetic Field',
      'type': BackgroundCanvasType.magneticField,
      'colors': BackgroundCanvasColorSchemes.darkMatter,
    },
    {
      'name': 'Ripple Effect',
      'type': BackgroundCanvasType.rippleEffect,
      'colors': BackgroundCanvasColorSchemes.oceanBlue,
    },
    {
      'name': 'Kaleidoscope',
      'type': BackgroundCanvasType.kaleidoscope,
      'colors': BackgroundCanvasColorSchemes.cosmicFusion,
    },
    {
      'name': 'Particle Explosion',
      'type': BackgroundCanvasType.particleExplosion,
      'colors': BackgroundCanvasColorSchemes.fireAndIce,
    },
    {
      'name': 'Orbital Dance',
      'type': BackgroundCanvasType.orbitalDance,
      'colors': BackgroundCanvasColorSchemes.purpleDream,
    },
    // Image-inspired canvases
    {
      'name': 'Radial Burst',
      'type': BackgroundCanvasType.radialBurst,
      'colors': BackgroundCanvasColorSchemes.neonMint,
    },
    {
      'name': 'Flowing Layers',
      'type': BackgroundCanvasType.flowingLayers,
      'colors': BackgroundCanvasColorSchemes.oceanBlue,
    },
    {
      'name': 'Radial Sunset',
      'type': BackgroundCanvasType.radialSunset,
      'colors': BackgroundCanvasColorSchemes.sunsetGradient,
    },
    {
      'name': 'Rainbow Flow',
      'type': BackgroundCanvasType.rainbowFlow,
      'colors': BackgroundCanvasColorSchemes.cosmicFusion,
    },
    {
      'name': 'Angular Waves',
      'type': BackgroundCanvasType.angularWaves,
      'colors': BackgroundCanvasColorSchemes.retroWave,
    },
    {
      'name': 'Smooth Gradients',
      'type': BackgroundCanvasType.smoothGradients,
      'colors': BackgroundCanvasColorSchemes.purpleDream,
    },
    {
      'name': 'Prism Effect',
      'type': BackgroundCanvasType.prismEffect,
      'colors': BackgroundCanvasColorSchemes.fireAndIce,
    },
    {
      'name': 'Liquid Flow',
      'type': BackgroundCanvasType.liquidFlow,
      'colors': BackgroundCanvasColorSchemes.oceanBlue,
    },
    {
      'name': 'Energy Field',
      'type': BackgroundCanvasType.energyField,
      'colors': BackgroundCanvasColorSchemes.synthWave,
    },
    {
      'name': 'Dimensional Rift',
      'type': BackgroundCanvasType.dimensionalRift,
      'colors': BackgroundCanvasColorSchemes.darkMatter,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundCanvasWidget(
        colors: currentColors,
        type: currentType,
        animated: animated,
        intensity: intensity,
        speed: speed,
        opacity: opacity,
        enableGlow: enableGlow,
        glowRadius: glowRadius,
        animationDuration: const Duration(seconds: 4),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Background Canvas Demo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 3,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Choose a preset:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: presets.map((preset) {
                        return ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentType = preset['type'];
                              currentColors = List<Color>.from(preset['colors']);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: currentType == preset['type']
                                ? Colors.white.withValues(alpha: 0.9)
                                : Colors.white.withValues(alpha: 0.2),
                            foregroundColor: currentType == preset['type']
                                ? Colors.black
                                : Colors.white,
                            elevation: currentType == preset['type'] ? 4 : 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(preset['name']),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Intensity: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: intensity,
                            min: 0.1,
                            max: 2.0,
                            divisions: 19,
                            label: intensity.toStringAsFixed(1),
                            onChanged: (value) {
                              setState(() {
                                intensity = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Speed: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: speed,
                            min: 0.1,
                            max: 3.0,
                            divisions: 29,
                            label: speed.toStringAsFixed(1),
                            onChanged: (value) {
                              setState(() {
                                speed = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Opacity: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: opacity,
                            min: 0.1,
                            max: 1.0,
                            divisions: 9,
                            label: opacity.toStringAsFixed(1),
                            onChanged: (value) {
                              setState(() {
                                opacity = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Animated: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Switch(
                          value: animated,
                          onChanged: (value) {
                            setState(() {
                              animated = value;
                            });
                          },
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          'Glow: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Switch(
                          value: enableGlow,
                          onChanged: (value) {
                            setState(() {
                              enableGlow = value;
                            });
                          },
                        ),
                      ],
                    ),
                    if (enableGlow)
                      Row(
                        children: [
                          const Text(
                            'Glow Radius: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: glowRadius,
                              min: 1.0,
                              max: 30.0,
                              divisions: 29,
                              label: glowRadius.toStringAsFixed(0),
                              onChanged: (value) {
                                setState(() {
                                  glowRadius = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Current Colors:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: _addRandomColor,
                                  icon: const Icon(Icons.add),
                                  tooltip: 'Add Random Color',
                                  iconSize: 20,
                                ),
                                IconButton(
                                  onPressed: _removeLastColor,
                                  icon: const Icon(Icons.remove),
                                  tooltip: 'Remove Last Color',
                                  iconSize: 20,
                                ),
                                IconButton(
                                  onPressed: _shuffleColors,
                                  icon: const Icon(Icons.shuffle),
                                  tooltip: 'Shuffle Colors',
                                  iconSize: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: currentColors.asMap().entries.map((entry) {
                            final index = entry.key;
                            final color = entry.value;
                            return GestureDetector(
                              onTap: () => _editColor(index),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Pattern Type:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentType.toString().split('.').last,
                          style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addRandomColor() {
    setState(() {
      final random = DateTime.now().millisecondsSinceEpoch;
      currentColors.add(Color((random * 0x1000000).toInt()).withValues(alpha: 1.0));
    });
  }

  void _removeLastColor() {
    if (currentColors.length > 1) {
      setState(() {
        currentColors.removeLast();
      });
    }
  }

  void _shuffleColors() {
    setState(() {
      currentColors.shuffle();
    });
  }

  void _editColor(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Color'),
        content: SizedBox(
          width: 300,
          height: 400,
          child: Column(
            children: [
              _buildColorPicker(currentColors[index], (color) {
                setState(() {
                  currentColors[index] = color;
                });
              }),
              const SizedBox(height: 20),
              const Text('Or choose a preset color:'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  Colors.red,
                  Colors.blue,
                  Colors.green,
                  Colors.purple,
                  Colors.orange,
                  Colors.pink,
                  Colors.cyan,
                  Colors.amber,
                  Colors.indigo,
                  Colors.teal,
                ].map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentColors[index] = color;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker(Color currentColor, Function(Color) onColorChanged) {
    final red = (currentColor.r * 255.0).round();
    final green = (currentColor.g * 255.0).round();
    final blue = (currentColor.b * 255.0).round();
    final alpha = (currentColor.a * 255.0).round();
    
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: currentColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey, width: 2),
          ),
        ),
        const SizedBox(height: 10),
        const Text('Red'),
        Slider(
          value: red.toDouble(),
          max: 255,
          divisions: 255,
          onChanged: (value) {
            onColorChanged(Color.fromARGB(
              alpha,
              value.toInt(),
              green,
              blue,
            ));
          },
        ),
        const Text('Green'),
        Slider(
          value: green.toDouble(),
          max: 255,
          divisions: 255,
          onChanged: (value) {
            onColorChanged(Color.fromARGB(
              alpha,
              red,
              value.toInt(),
              blue,
            ));
          },
        ),
        const Text('Blue'),
        Slider(
          value: blue.toDouble(),
          max: 255,
          divisions: 255,
          onChanged: (value) {
            onColorChanged(Color.fromARGB(
              alpha,
              red,
              green,
              value.toInt(),
            ));
          },
        ),
      ],
    );
  }
}
