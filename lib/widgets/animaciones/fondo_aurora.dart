import 'package:flutter/material.dart';

import '../../utils/colores_app.dart';

class FondoAurora extends StatefulWidget {
  final Widget child;

  const FondoAurora({
    super.key,
    required this.child,
  });

  @override
  State<FondoAurora> createState() => _FondoAuroraState();
}

class _FondoAuroraState extends State<FondoAurora>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animacion;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);

    _animacion = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animacion,
      builder: (context, child) {
        final double valor = _animacion.value;

        return Container(
          decoration: const BoxDecoration(
            gradient: ColoresApp.gradienteAurora,
          ),
          child: Stack(
            children: [
              Positioned(
                top: -70 + (valor * 22),
                left: -80 + (valor * 18),
                child: _BurbujaAurora(
                  size: 220,
                  color: ColoresApp.cianNeon.withOpacity(0.22),
                ),
              ),
              Positioned(
                bottom: -90 + (valor * 26),
                right: -70 + (valor * 20),
                child: _BurbujaAurora(
                  size: 240,
                  color: ColoresApp.violetaIA.withOpacity(0.22),
                ),
              ),
              Positioned(
                top: 240 - (valor * 20),
                right: 40 + (valor * 10),
                child: _BurbujaAurora(
                  size: 120,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
              widget.child,
            ],
          ),
        );
      },
    );
  }
}

class _BurbujaAurora extends StatelessWidget {
  final double size;
  final Color color;

  const _BurbujaAurora({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 80,
              spreadRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}