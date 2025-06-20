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
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
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
    {'name': 'Ocean Waves', 'type': BackgroundCanvasType.fluidWaves, 'colors': BackgroundCanvasColorSchemes.oceanBlue},
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
    {'name': 'Noise Field', 'type': BackgroundCanvasType.noiseField, 'colors': BackgroundCanvasColorSchemes.neonMint},
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
    {'name': 'Plasma Ball', 'type': BackgroundCanvasType.plasmaBall, 'colors': BackgroundCanvasColorSchemes.fireAndIce},
    {
      'name': 'Quantum Field',
      'type': BackgroundCanvasType.quantumField,
      'colors': BackgroundCanvasColorSchemes.purpleDream,
    },
    {'name': 'Digital Rain', 'type': BackgroundCanvasType.digitalRain, 'colors': BackgroundCanvasColorSchemes.neonMint},
    {'name': 'Cosmic Web', 'type': BackgroundCanvasType.cosmicWeb, 'colors': BackgroundCanvasColorSchemes.darkMatter},
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
    {'name': 'Fireworks', 'type': BackgroundCanvasType.fireworks, 'colors': BackgroundCanvasColorSchemes.fireAndIce},
    {'name': 'Aurora', 'type': BackgroundCanvasType.aurora, 'colors': BackgroundCanvasColorSchemes.cosmicFusion},
    {'name': 'Honeycomb', 'type': BackgroundCanvasType.honeycomb, 'colors': BackgroundCanvasColorSchemes.neonMint},
    {'name': 'Mandala', 'type': BackgroundCanvasType.mandala, 'colors': BackgroundCanvasColorSchemes.purpleDream},
    {'name': 'DNA Helix', 'type': BackgroundCanvasType.dnaHelix, 'colors': BackgroundCanvasColorSchemes.synthWave},
    {'name': 'Lava Lamp', 'type': BackgroundCanvasType.lavaLamp, 'colors': BackgroundCanvasColorSchemes.retroWave},
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
    {'name': 'Radial Burst', 'type': BackgroundCanvasType.radialBurst, 'colors': BackgroundCanvasColorSchemes.neonMint},
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
    {'name': 'Liquid Flow', 'type': BackgroundCanvasType.liquidFlow, 'colors': BackgroundCanvasColorSchemes.oceanBlue},
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
          child: Stack(
            children: [
              // Top: Horizontal Scrollable Presets
              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 4, left: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Presets',
                            style: TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: presets.length,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          itemBuilder: (context, index) {
                            final preset = presets[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    currentType = preset['type'];
                                    currentColors = List<Color>.from(preset['colors']);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: currentType == preset['type']
                                      ? Colors.white.withValues(alpha: 0.9)
                                      : Colors.white.withValues(alpha: 0.15),
                                  foregroundColor: currentType == preset['type'] ? Colors.black : Colors.white,
                                  elevation: currentType == preset['type'] ? 2 : 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  minimumSize: const Size(60, 30),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                ),
                                child: Text(
                                  preset['name'],
                                  style: const TextStyle(fontSize: 10),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Left Side: Color Change Options
              Align(
                alignment: Alignment.centerLeft,

                child: Container(
                  width: 100,
                  height: 200,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Colors',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: _addRandomColor,
                            icon: const Icon(Icons.add, color: Colors.white),
                            iconSize: 16,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                          ),
                          IconButton(
                            onPressed: _removeLastColor,
                            icon: const Icon(Icons.remove, color: Colors.white),
                            iconSize: 16,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                          ),
                          IconButton(
                            onPressed: _shuffleColors,
                            icon: const Icon(Icons.shuffle, color: Colors.white),
                            iconSize: 16,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                            childAspectRatio: 1,
                          ),
                          itemCount: currentColors.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _editColor(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: currentColors[index],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
                                ),
                                child: const Icon(Icons.edit, color: Colors.white, size: 12),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Switch(
                            value: animated,
                            onChanged: (value) {
                              setState(() {
                                animated = value;
                              });
                            },
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          const Text('Anim', style: TextStyle(color: Colors.white, fontSize: 8)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Switch(
                            value: enableGlow,
                            onChanged: (value) {
                              setState(() {
                                enableGlow = value;
                              });
                            },
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          const Text('Glow', style: TextStyle(color: Colors.white, fontSize: 8)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Center: Small Progress Bars
              Positioned(
                bottom: 8,
                left: MediaQuery.of(context).size.width * 0.25,
                right: MediaQuery.of(context).size.width * 0.25,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Text('I', style: TextStyle(color: Colors.white, fontSize: 10)),
                          Expanded(
                            child: Slider(
                              value: intensity,
                              min: 0.1,
                              max: 2.0,
                              onChanged: (value) {
                                setState(() {
                                  intensity = value;
                                });
                              },
                            ),
                          ),
                          Text(intensity.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 8)),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('S', style: TextStyle(color: Colors.white, fontSize: 10)),
                          Expanded(
                            child: Slider(
                              value: speed,
                              min: 0.1,
                              max: 3.0,
                              onChanged: (value) {
                                setState(() {
                                  speed = value;
                                });
                              },
                            ),
                          ),
                          Text(speed.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 8)),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('O', style: TextStyle(color: Colors.white, fontSize: 10)),
                          Expanded(
                            child: Slider(
                              value: opacity,
                              min: 0.1,
                              max: 1.0,
                              onChanged: (value) {
                                setState(() {
                                  opacity = value;
                                });
                              },
                            ),
                          ),
                          Text(opacity.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 8)),
                        ],
                      ),
                      if (enableGlow)
                        Row(
                          children: [
                            const Text('G', style: TextStyle(color: Colors.white, fontSize: 10)),
                            Expanded(
                              child: Slider(
                                value: glowRadius,
                                min: 1.0,
                                max: 30.0,
                                onChanged: (value) {
                                  setState(() {
                                    glowRadius = value;
                                  });
                                },
                              ),
                            ),
                            Text(
                              glowRadius.toStringAsFixed(0),
                              style: const TextStyle(color: Colors.white, fontSize: 8),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addRandomColor() {
    setState(() {
      final random = DateTime.now().millisecondsSinceEpoch;
      currentColors = List<Color>.from(currentColors)..add(Color((random * 0x1000000).toInt()).withValues(alpha: 1.0));
    });
  }

  void _removeLastColor() {
    if (currentColors.length > 1) {
      setState(() {
        currentColors = List<Color>.from(currentColors)..removeLast();
      });
    }
  }

  void _shuffleColors() {
    setState(() {
      currentColors = List<Color>.from(currentColors)..shuffle();
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
                children:
                    [
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
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
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
            onColorChanged(Color.fromARGB(alpha, value.toInt(), green, blue));
          },
        ),
        const Text('Green'),
        Slider(
          value: green.toDouble(),
          max: 255,
          divisions: 255,
          onChanged: (value) {
            onColorChanged(Color.fromARGB(alpha, red, value.toInt(), blue));
          },
        ),
        const Text('Blue'),
        Slider(
          value: blue.toDouble(),
          max: 255,
          divisions: 255,
          onChanged: (value) {
            onColorChanged(Color.fromARGB(alpha, red, green, value.toInt()));
          },
        ),
      ],
    );
  }
}
