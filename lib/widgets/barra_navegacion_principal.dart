import 'package:flutter/material.dart';

import '../utils/colores_app.dart';

class BarraNavegacionPrincipal extends StatelessWidget {
  final int indiceActual;
  final Function(int) onTap;

  const BarraNavegacionPrincipal({
    super.key,
    required this.indiceActual,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: ColoresApp.nocheProfunda,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          _ItemNavegacion(
            titulo: 'Inicio',
            icono: Icons.home_rounded,
            activo: indiceActual == 0,
            onTap: () => onTap(0),
          ),
          _ItemNavegacion(
            titulo: 'Centro',
            icono: Icons.auto_graph_rounded,
            activo: indiceActual == 1,
            onTap: () => onTap(1),
          ),

          const SizedBox(width: 8),

          _BotonCentralCamara(
            activo: indiceActual == 2,
            onTap: () => onTap(2),
          ),

          const SizedBox(width: 8),

          _ItemNavegacion(
            titulo: 'Reporte',
            icono: Icons.picture_as_pdf_rounded,
            activo: indiceActual == 3,
            onTap: () => onTap(3),
          ),
          _ItemNavegacion(
            titulo: 'Info',
            icono: Icons.info_rounded,
            activo: indiceActual == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}

class _ItemNavegacion extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final bool activo;
  final VoidCallback onTap;

  const _ItemNavegacion({
    required this.titulo,
    required this.icono,
    required this.activo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: activo
                ? Colors.white.withOpacity(0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: activo ? 1.13 : 1,
                duration: const Duration(milliseconds: 220),
                child: Icon(
                  icono,
                  size: 23,
                  color: activo
                      ? ColoresApp.cianNeon
                      : Colors.white.withOpacity(0.58),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                titulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: activo ? FontWeight.w800 : FontWeight.w500,
                  color: activo
                      ? ColoresApp.cianNeon
                      : Colors.white.withOpacity(0.58),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotonCentralCamara extends StatefulWidget {
  final bool activo;
  final VoidCallback onTap;

  const _BotonCentralCamara({
    required this.activo,
    required this.onTap,
  });

  @override
  State<_BotonCentralCamara> createState() => _BotonCentralCamaraState();
}

class _BotonCentralCamaraState extends State<_BotonCentralCamara> {
  bool presionado = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => presionado = true),
      onTapCancel: () => setState(() => presionado = false),
      onTapUp: (_) => setState(() => presionado = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: presionado ? 0.92 : 1,
        duration: const Duration(milliseconds: 150),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: ColoresApp.gradienteBoton,
            boxShadow: [
              BoxShadow(
                color: ColoresApp.cianNeon.withOpacity(
                  widget.activo ? 0.48 : 0.28,
                ),
                blurRadius: widget.activo ? 30 : 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(widget.activo ? 0.95 : 0.55),
              width: 3,
            ),
          ),
          child: const Icon(
            Icons.camera_alt_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}