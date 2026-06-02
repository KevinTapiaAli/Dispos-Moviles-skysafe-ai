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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          _item(
            icono: Icons.home_rounded,
            titulo: 'Inicio',
            activo: indiceActual == 0,
            onPressed: () => onTap(0),
          ),
          _item(
            icono: Icons.analytics_rounded,
            titulo: 'Centro IA',
            activo: indiceActual == 1,
            onPressed: () => onTap(1),
          ),
          const SizedBox(width: 10),
          _botonCentral(
            onPressed: () => onTap(2),
            activo: indiceActual == 2,
          ),
          const SizedBox(width: 10),
          _item(
            icono: Icons.picture_as_pdf_rounded,
            titulo: 'Reportes',
            activo: indiceActual == 3,
            onPressed: () => onTap(3),
          ),
          _item(
            icono: Icons.info_rounded,
            titulo: 'Info',
            activo: indiceActual == 4,
            onPressed: () => onTap(4),
          ),
        ],
      ),
    );
  }

  Widget _item({
    required IconData icono,
    required String titulo,
    required bool activo,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color: activo ? ColoresApp.celesteClaro : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icono,
                size: 22,
                color: activo
                    ? ColoresApp.azulPrincipal
                    : ColoresApp.grisTexto,
              ),
              const SizedBox(height: 4),
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: ativoPeso(activo),
                  color: activo
                      ? ColoresApp.azulPrincipal
                      : ColoresApp.grisTexto,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FontWeight ativoPeso(bool activo) {
    return activo ? FontWeight.w700 : FontWeight.w500;
  }

  Widget _botonCentral({
    required VoidCallback onPressed,
    required bool activo,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          gradient: ColoresApp.gradienteBoton,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ColoresApp.azulPrincipal.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: activo ? Colors.white : Colors.white.withOpacity(0.7),
            width: 3,
          ),
        ),
        child: const Icon(
          Icons.camera_alt_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}