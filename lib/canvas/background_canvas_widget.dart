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
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
        _controller.reset();
      }
    }
    
    // Handle duration changes
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.dispose();
      _initializeAnimation();
    }

    // Handle speed changes
    if (oldWidget.speed != widget.speed) {
      if (widget.animated) {
        _controller.stop();
        _controller.duration = Duration(
          milliseconds: (widget.animationDuration.inMilliseconds / widget.speed).round(),
        );
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