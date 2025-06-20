import 'package:flutter/material.dart';
import 'canvas_painters.dart';

enum BackgroundCanvasType {
  fluidWaves,
  geometricShapes,
  organicBlobs,
  layeredCurves,
  particleField,
  abstractFlow,
  spiralGalaxy,
  liquidMetal,
  noiseField,
  fractalTree,
  neuralNetwork,
  crystalFormation,
  plasmaBall,
  quantumField,
  digitalRain,
  cosmicWeb,
  molecularStructure,
  waveInterference,
  // New unique canvas designs
  fireworks,
  aurora,
  honeycomb,
  mandala,
  dnaHelix,
  lavaLamp,
  electricField,
  magneticField,
  rippleEffect,
  kaleidoscope,
  particleExplosion,
  orbitalDance,
  // New designs inspired by provided images
  radialBurst,
  flowingLayers,
  radialSunset,
  rainbowFlow,
  angularWaves,
  smoothGradients,
  prismEffect,
  liquidFlow,
  energyField,
  dimensionalRift,
}

class BackgroundCanvasWidget extends StatefulWidget {
  final List<Color> colors;
  final BackgroundCanvasType type;
  final bool animated;
  final Duration animationDuration;
  final double intensity;
  final double speed;
  final double opacity;
  final BlendMode? blendMode;
  final bool enableGlow;
  final double glowRadius;
  final Widget? child;

  const BackgroundCanvasWidget({
    super.key,
    required this.colors,
    this.type = BackgroundCanvasType.fluidWaves,
    this.animated = true,
    this.animationDuration = const Duration(seconds: 3),
    this.intensity = 1.0,
    this.speed = 1.0,
    this.opacity = 1.0,
    this.blendMode,
    this.enableGlow = false,
    this.glowRadius = 10.0,
    this.child,
  });

  @override
  State<BackgroundCanvasWidget> createState() => _BackgroundCanvasWidgetState();
}

class _BackgroundCanvasWidgetState extends State<BackgroundCanvasWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: Duration(
        milliseconds: (widget.animationDuration.inMilliseconds / widget.speed).round(),
      ),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear), // Linear for smooth transitions
    );

    if (widget.animated) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(BackgroundCanvasWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Handle animation state changes
    if (oldWidget.animated != widget.animated) {
      if (widget.animated) {
        _controller.repeat();
      } else {
        _controller.stop();
        // Don't reset to maintain smooth continuation
      }
    }
    
    // Handle duration or speed changes
    if (oldWidget.animationDuration != widget.animationDuration || 
        oldWidget.speed != widget.speed) {
      final wasAnimating = _controller.isAnimating;
      final currentValue = _controller.value;
      
      _controller.stop();
      _controller.duration = Duration(
        milliseconds: (widget.animationDuration.inMilliseconds / widget.speed).round(),
      );
      
      // Resume from current position for smooth transition
      if (widget.animated && wasAnimating) {
        _controller.forward(from: currentValue);
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  CustomPainter _getPainter() {
    switch (widget.type) {
      case BackgroundCanvasType.fluidWaves:
        return FluidWavesPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.geometricShapes:
        return GeometricShapesPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.organicBlobs:
        return OrganicBlobsPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.layeredCurves:
        return LayeredCurvesPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.particleField:
        return ParticleFieldPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.abstractFlow:
        return AbstractFlowPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.spiralGalaxy:
        return SpiralGalaxyPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.liquidMetal:
        return LiquidMetalPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.noiseField:
        return NoiseFieldPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.fractalTree:
        return FractalTreePainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.neuralNetwork:
        return NeuralNetworkPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.crystalFormation:
        return CrystalFormationPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.plasmaBall:
        return PlasmaBallPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.quantumField:
        return QuantumFieldPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.digitalRain:
        return DigitalRainPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.cosmicWeb:
        return CosmicWebPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.molecularStructure:
        return MolecularStructurePainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.waveInterference:
        return WaveInterferencePainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.fireworks:
        return FireworksPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.aurora:
        return AuroraPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.honeycomb:
        return HoneycombPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.mandala:
        return MandalaPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.dnaHelix:
        return DnaHelixPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.lavaLamp:
        return LavaLampPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.electricField:
        return ElectricFieldPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.magneticField:
        return MagneticFieldPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.rippleEffect:
        return RippleEffectPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.kaleidoscope:
        return KaleidoscopePainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.particleExplosion:
        return ParticleExplosionPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.orbitalDance:
        return OrbitalDancePainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.radialBurst:
        return RadialBurstPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.flowingLayers:
        return FlowingLayersPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.radialSunset:
        return RadialSunsetPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.rainbowFlow:
        return RainbowFlowPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.angularWaves:
        return AngularWavesPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.smoothGradients:
        return SmoothGradientsPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.prismEffect:
        return PrismEffectPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.liquidFlow:
        return LiquidFlowPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.energyField:
        return EnergyFieldPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
      case BackgroundCanvasType.dimensionalRift:
        return DimensionalRiftPainter(
          colors: widget.colors,
          animation: _animation,
          intensity: widget.intensity,
          opacity: widget.opacity,
          enableGlow: widget.enableGlow,
          glowRadius: widget.glowRadius,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            Widget canvas = CustomPaint(
              painter: _getPainter(),
              size: Size.infinite,
            );
            
            if (widget.opacity < 1.0) {
              canvas = Opacity(
                opacity: widget.opacity,
                child: canvas,
              );
            }
            
            if (widget.blendMode != null) {
              canvas = ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.transparent,
                  widget.blendMode!,
                ),
                child: canvas,
              );
            }
            
            return canvas;
          },
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}