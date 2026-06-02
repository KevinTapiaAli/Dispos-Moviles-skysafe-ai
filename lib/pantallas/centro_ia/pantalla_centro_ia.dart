import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/analisis_controller.dart';
import '../../utils/colores_app.dart';

class PantallaCentroIA extends StatelessWidget {
  const PantallaCentroIA({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AnalisisController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Centro de Análisis'),
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 500),
                tween: Tween<double>(begin: 0.95, end: 1),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: ColoresApp.gradienteTarjetaHero,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.auto_graph_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                      SizedBox(height: 14),
                      Text(
                        'Control operativo del cielo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Aquí se concentra el último resultado, el historial reciente y los indicadores visuales más importantes.',
                        style: TextStyle(
                          color: Colors.white,
                          height: 1.5,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Resumen rápido',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ColoresApp.grisOscuro,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _tarjetaMini(
                      titulo: 'Análisis',
                      valor: '${controller.totalAnalisis}',
                      icono: Icons.assessment_rounded,
                      color: ColoresApp.azulPrincipal,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _tarjetaMini(
                      titulo: 'Riesgo alto',
                      valor: '${controller.contarPorRiesgo('Alto')}',
                      icono: Icons.warning_amber_rounded,
                      color: ColoresApp.rojoError,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _tarjetaMini(
                      titulo: 'Riesgo medio',
                      valor: '${controller.contarPorRiesgo('Medio')}',
                      icono: Icons.cloud_queue_rounded,
                      color: ColoresApp.naranjaAlerta,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _tarjetaMini(
                      titulo: 'Promedio',
                      valor:
                          '${controller.promedioConfianza.toStringAsFixed(1)}%',
                      icono: Icons.verified_rounded,
                      color: ColoresApp.verdeExito,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Último análisis',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: ColoresApp.grisOscuro,
                ),
              ),
              const SizedBox(height: 12),

              controller.resultadoActual.value == null
                  ? _mensajeVacio(
                      'Aún no hay análisis realizado',
                      'Cuando analices una imagen del cielo, aquí verás el resultado principal.',
                    )
                  : _tarjetaUltimoAnalisis(
                      controller.resultadoActual.value!,
                    ),

              const SizedBox(height: 24),

              const Text(
                'Historial reciente',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: ColoresApp.grisOscuro,
                ),
              ),
              const SizedBox(height: 12),

              if (controller.historial.isEmpty)
                _mensajeVacio(
                  'Sin historial',
                  'Todavía no existen análisis guardados en el sistema.',
                )
              else
                ...controller.historial.take(5).map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: ColoresApp.celesteClaro,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.cloud_done_rounded,
                            color: ColoresApp.azulPrincipal,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.estadoDetectado,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: ColoresApp.grisOscuro,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Confianza: ${item.confianza.toStringAsFixed(2)}% | Riesgo: ${item.nivelRiesgo}',
                                style: const TextStyle(
                                  color: ColoresApp.grisTexto,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tarjetaMini({
    required String titulo,
    required String valor,
    required IconData icono,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icono, color: color),
          ),
          const SizedBox(height: 14),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColoresApp.grisOscuro,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 14,
              color: ColoresApp.grisTexto,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mensajeVacio(String titulo, String subtitulo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.inbox_rounded,
            size: 40,
            color: ColoresApp.azulPrincipal,
          ),
          const SizedBox(height: 10),
          Text(
            titulo,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: ColoresApp.grisOscuro,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ColoresApp.grisTexto,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaUltimoAnalisis(dynamic resultado) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            resultado.estadoDetectado,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: ColoresApp.grisOscuro,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Confianza: ${resultado.confianza.toStringAsFixed(2)}%',
            style: const TextStyle(color: ColoresApp.grisTexto),
          ),
          const SizedBox(height: 8),
          Text(
            'Nivel de riesgo: ${resultado.nivelRiesgo}',
            style: const TextStyle(color: ColoresApp.grisTexto),
          ),
          const SizedBox(height: 8),
          Text(
            resultado.recomendacion,
            style: const TextStyle(
              color: ColoresApp.grisTexto,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}