// lib/core/widgets/charts/animated_counter.dart
// Number ticker animation for KPIs and counters

import 'package:flutter/material.dart';
import '../../theme/app_animations.dart';

/// Animated counter that smoothly transitions between numbers
class AnimatedCounter extends StatefulWidget {
  final double value;
  final int decimals;
  final TextStyle? textStyle;
  final Duration duration;
  final Curve curve;
  final String? prefix;
  final String? suffix;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.decimals = 0,
    this.textStyle,
    this.duration = AppAnimations.emphasis,
    this.curve = AppAnimations.defaultCurve,
    this.prefix,
    this.suffix,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: _previousValue,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _animation = Tween<double>(
        begin: _previousValue,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String lastFormatted = '';

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final formatted = _animation.value.toStringAsFixed(widget.decimals);
        if (formatted == lastFormatted && lastFormatted.isNotEmpty) {
          return Text(
            lastFormatted,
            style: widget.textStyle,
          );
        }
        lastFormatted =
            '${widget.prefix ?? ''}$formatted${widget.suffix ?? ''}';

        return Text(
          lastFormatted,
          style: widget.textStyle,
        );
      },
    );
  }
}

/// Animated counter specifically for currency
class AnimatedCurrencyCounter extends StatelessWidget {
  final double value;
  final String symbol;
  final TextStyle? textStyle;
  final Duration duration;

  const AnimatedCurrencyCounter({
    super.key,
    required this.value,
    this.symbol = 'FCFA',
    this.textStyle,
    this.duration = AppAnimations.emphasis,
  });

  @override
  Widget build(BuildContext context) {
    // Format with thousand separators
    final absValue = value.abs();
    absValue.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
        );

    return AnimatedCounter(
      value: value,
      decimals: 0,
      textStyle: textStyle,
      duration: duration,
      suffix: ' $symbol',
    );
  }
}

/// Animated percentage counter
class AnimatedPercentageCounter extends StatelessWidget {
  final double value;
  final int decimals;
  final TextStyle? textStyle;
  final Duration duration;

  const AnimatedPercentageCounter({
    super.key,
    required this.value,
    this.decimals = 1,
    this.textStyle,
    this.duration = AppAnimations.emphasis,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCounter(
      value: value,
      decimals: decimals,
      textStyle: textStyle,
      duration: duration,
      suffix: '%',
    );
  }
}