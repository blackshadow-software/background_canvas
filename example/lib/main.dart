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
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Background Canvas Demo',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Choose a preset:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
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
                                ? Colors.blue
                                : Colors.grey[300],
                            foregroundColor: currentType == preset['type']
                                ? Colors.white
                                : Colors.black87,
                          ),
                          child: Text(preset['name']),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Intensity: '),
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
                        const Text('Speed: '),
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
                        const Text('Opacity: '),
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
                        const Text('Animated: '),
                        Switch(
                          value: animated,
                          onChanged: (value) {
                            setState(() {
                              animated = value;
                            });
                          },
                        ),
                        const SizedBox(width: 20),
                        const Text('Glow: '),
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
                          const Text('Glow Radius: '),
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
              Flexible(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
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
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
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
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentType.toString().split('.').last,
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
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
