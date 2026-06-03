import 'package:flutter/material.dart';

import '../../utils/colores_app.dart';

class BotonGradiente extends StatefulWidget {
  final String texto;
  final IconData icono;
  final VoidCallback? onPressed;
  final bool expandido;

  const BotonGradiente({
    super.key,
    required this.texto,
    required this.icono,
    required this.onPressed,
    this.expandido = true,
  });

  @override
  State<BotonGradiente> createState() => _BotonGradienteState();
}

class _BotonGradienteState extends State<BotonGradiente> {
  bool presionado = false;

  @override
  Widget build(BuildContext context) {
    final Widget contenido = GestureDetector(
      onTapDown: (_) => setState(() => presionado = true),
      onTapCancel: () => setState(() => presionado = false),
      onTapUp: (_) => setState(() => presionado = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: presionado ? 0.97 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: widget.onPressed == null ? 0.55 : 1,
          duration: const Duration(milliseconds: 180),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              gradient: ColoresApp.gradienteBoton,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                ColoresApp.sombraBoton,
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize:
                  widget.expandido ? MainAxisSize.max : MainAxisSize.min,
              children: [
                Icon(
                  widget.icono,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.texto,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (widget.expandido) {
      return SizedBox(
        width: double.infinity,
        child: contenido,
      );
    }

    return contenido;
  }
}