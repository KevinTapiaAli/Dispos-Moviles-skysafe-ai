import 'package:flutter/material.dart';

class EntradaAnimada extends StatelessWidget {
  final Widget child;
  final int delay;
  final double desplazamiento;
  final Duration duracion;

  const EntradaAnimada({
    super.key,
    required this.child,
    this.delay = 0,
    this.desplazamiento = 28,
    this.duracion = const Duration(milliseconds: 600),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duracion + Duration(milliseconds: delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, desplazamiento * (1 - value)),
            child: Transform.scale(
              scale: 0.96 + (0.04 * value),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}