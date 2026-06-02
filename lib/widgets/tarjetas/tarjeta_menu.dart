import 'package:flutter/material.dart';
import '../../utils/colores_app.dart';

class TarjetaMenu extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final IconData icono;
  final VoidCallback onTap;

  const TarjetaMenu({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: ColoresApp.azulPrincipal.withOpacity(0.25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icono,
                size: 42,
                color: ColoresApp.azulPrincipal,
              ),
              const SizedBox(height: 14),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                descripcion,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}