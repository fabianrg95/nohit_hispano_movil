import 'package:flutter/material.dart';

class ShimmerArrows extends StatefulWidget {
  final IconData icon;

  const ShimmerArrows({super.key, required this.icon});

  @override
  State<ShimmerArrows> createState() => _ShimmerArrowsState();
}

class _ShimmerArrowsState extends State<ShimmerArrows> with TickerProviderStateMixin {
  late final AnimationController _controller;

  late ColorScheme color;

  @override
  void initState() {
    _controller = AnimationController.unbounded(vsync: this)..repeat(min: -0.5, max: 5.5, period: const Duration(seconds: 3));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Gradient get gradient => LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.bottomRight,
        colors: [color.primary, color.tertiary, color.primary, color.tertiary, color.primary],
        stops: const [0.0, 0.05, 0.5, 0.95, 1],
        transform: _SlideGradientTransform(_controller.value),
      );

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return ShaderMask(
          shaderCallback: (bounds) => gradient.createShader(bounds),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(heightFactor: .8, widthFactor: 0.4, child: Icon(widget.icon, size: 50)),
          Align(heightFactor: .8, widthFactor: 0.4, child: Icon(widget.icon, size: 50)),
          Align(heightFactor: .8, widthFactor: 0.4, child: Icon(widget.icon, size: 50)),
        ],
      ),
    );
  }
}

class _SlideGradientTransform extends GradientTransform {
  const _SlideGradientTransform(this.percent);

  final double percent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) => Matrix4.translationValues((bounds.height * percent), 0, 0);
}
