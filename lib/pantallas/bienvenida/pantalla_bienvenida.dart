import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/rutas_app.dart';
import '../../utils/colores_app.dart';
import '../../utils/textos_app.dart';
import '../../widgets/animaciones/entrada_animada.dart';
import '../../widgets/animaciones/fondo_aurora.dart';
import '../../widgets/botones/boton_gradiente.dart';

class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FondoAurora(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 24, 26, 28),
            child: Column(
              children: [
                const Spacer(),

                EntradaAnimada(
                  delay: 100,
                  child: Container(
                    width: 132,
                    height: 132,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.28),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColoresApp.cianNeon.withOpacity(0.30),
                          blurRadius: 36,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.radar_rounded,
                      color: Colors.white,
                      size: 70,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                EntradaAnimada(
                  delay: 220,
                  child: Text(
                    TextosApp.nombreApp,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const EntradaAnimada(
                  delay: 330,
                  child: Text(
                    'Inteligencia visual para evaluar el cielo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                EntradaAnimada(
                  delay: 440,
                  child: Text(
                    TextosApp.bienvenidaMensaje,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.88),
                      fontSize: 15,
                      height: 1.65,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                EntradaAnimada(
                  delay: 540,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.18),
                      ),
                    ),
                    child: const Column(
                      children: [
                        _ItemBeneficio(
                          icono: Icons.cloud_done_rounded,
                          texto: 'Clasificación visual del cielo',
                        ),
                        SizedBox(height: 12),
                        _ItemBeneficio(
                          icono: Icons.shield_rounded,
                          texto: 'Nivel de riesgo operativo',
                        ),
                        SizedBox(height: 12),
                        _ItemBeneficio(
                          icono: Icons.picture_as_pdf_rounded,
                          texto: 'Reportes listos para presentar',
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                EntradaAnimada(
                  delay: 660,
                  child: BotonGradiente(
                    texto: 'Comenzar análisis',
                    icono: Icons.arrow_forward_rounded,
                    onPressed: () {
                      Get.offNamed(RutasApp.principal);
                    },
                  ),
                ),

                const SizedBox(height: 14),

                EntradaAnimada(
                  delay: 760,
                  child: TextButton(
                    onPressed: () {
                      Get.offNamed(RutasApp.principal);
                    },
                    child: Text(
                      'Explorar la aplicación',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.86),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ItemBeneficio extends StatelessWidget {
  final IconData icono;
  final String texto;

  const _ItemBeneficio({
    required this.icono,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.14),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icono,
            color: ColoresApp.cianNeon,
            size: 21,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}