import 'dart:math' as math;

import 'package:flutter/material.dart';

class ShakeTransition extends StatefulWidget {
  const ShakeTransition({
    required this.trigger,
    required this.child,
    super.key,
  });

  final int trigger;
  final Widget child;

  @override
  State<ShakeTransition> createState() => _ShakeTransitionState();
}

class _ShakeTransitionState extends State<ShakeTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curve;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void didUpdateWidget(covariant ShakeTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger) {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) {
        final wave = math.sin(_curve.value * math.pi * 6);
        final offset = wave * (1 - _curve.value) * 14;
        return Transform.translate(offset: Offset(offset, 0), child: child);
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
