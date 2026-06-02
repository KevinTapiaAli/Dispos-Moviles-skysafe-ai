import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/rutas_app.dart';
import '../../controllers/analisis_controller.dart';
import '../../modelos/resultado_clima.dart';
import '../../utils/colores_app.dart';

class PantallaResultado extends StatelessWidget {
  const PantallaResultado({super.key});

  Color _colorRiesgo(String riesgo) {
    switch (riesgo.toLowerCase()) {
      case 'bajo':
        return ColoresApp.riesgoBajo;
      case 'medio':
        return ColoresApp.riesgoMedio;
      case 'alto':
        return ColoresApp.riesgoAlto;
      default:
        return ColoresApp.azulPrincipal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AnalisisController controller = Get.find<AnalisisController>();

    return Scaffold(
      backgroundColor: ColoresApp.fondoClaro,
      appBar: AppBar(
        title: const Text('Resultado del Análisis'),
      ),
      body: SafeArea(
        child: Obx(() {
          final ResultadoClima? resultado = controller.resultadoActual.value;
          final File? imagen = controller.imagenSeleccionada.value;

          if (resultado == null) {
            return const _SinResultado();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Evaluación meteorológica',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: ColoresApp.azulOscuro,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Resultado generado por el modelo de inteligencia artificial de SkySafe AI.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: ColoresApp.textoSecundario,
                  ),
                ),
                const SizedBox(height: 20),

                if (imagen != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.file(
                      imagen,
                      height: 230,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                const SizedBox(height: 20),

                _TarjetaEstadoPrincipal(
                  resultado: resultado,
                  colorRiesgo: _colorRiesgo(resultado.nivelRiesgo),
                ),

                const SizedBox(height: 18),

                _TarjetaProbabilidades(resultado: resultado),

                const SizedBox(height: 18),

                _TarjetaRecomendacion(
                  resultado: resultado,
                  colorRiesgo: _colorRiesgo(resultado.nivelRiesgo),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Get.toNamed(RutasApp.camaraIA);
                        },
                        icon: const Icon(Icons.camera_alt_rounded),
                        label: const Text('Nuevo análisis'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.toNamed(RutasApp.reportes);
                        },
                        icon: const Icon(Icons.picture_as_pdf_rounded),
                        label: const Text('Reporte'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _SinResultado extends StatelessWidget {
  const _SinResultado();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.analytics_outlined,
              size: 80,
              color: ColoresApp.azulPrincipal,
            ),
            const SizedBox(height: 18),
            const Text(
              'Aún no hay resultados',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: ColoresApp.azulOscuro,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Primero realiza un análisis desde la cámara inteligente o selecciona una imagen desde la galería.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: ColoresApp.textoSecundario,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Get.toNamed(RutasApp.camaraIA);
              },
              icon: const Icon(Icons.camera_alt_rounded),
              label: const Text('Ir a Cámara IA'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaEstadoPrincipal extends StatelessWidget {
  final ResultadoClima resultado;
  final Color colorRiesgo;

  const _TarjetaEstadoPrincipal({
    required this.resultado,
    required this.colorRiesgo,
  });

  IconData _iconoPorEstado(String estado) {
    final estadoNormalizado = estado.toLowerCase();

    if (estadoNormalizado == 'despejado') {
      return Icons.wb_sunny_rounded;
    }

    if (estadoNormalizado == 'parcialmente_nublado') {
      return Icons.cloud_queue_rounded;
    }

    if (estadoNormalizado == 'nublado') {
      return Icons.cloud_rounded;
    }

    if (estadoNormalizado == 'lluvia') {
      return Icons.water_drop_rounded;
    }

    if (estadoNormalizado == 'tormenta') {
      return Icons.thunderstorm_rounded;
    }

    return Icons.cloud_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: ColoresApp.sombraSuave,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              _iconoPorEstado(resultado.estadoDetectado),
              size: 64,
              color: ColoresApp.azulPrincipal,
            ),
            const SizedBox(height: 12),
            const Text(
              'Estado detectado',
              style: TextStyle(
                fontSize: 14,
                color: ColoresApp.textoSecundario,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              resultado.estadoDetectado.replaceAll('_', ' ').toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: ColoresApp.azulOscuro,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: colorRiesgo.withOpacity(0.13),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: colorRiesgo.withOpacity(0.50),
                ),
              ),
              child: Text(
                'Riesgo ${resultado.nivelRiesgo}',
                style: TextStyle(
                  color: colorRiesgo,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaProbabilidades extends StatelessWidget {
  final ResultadoClima resultado;

  const _TarjetaProbabilidades({
    required this.resultado,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: ColoresApp.sombraSuave,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Indicadores del modelo',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: ColoresApp.azulOscuro,
              ),
            ),
            const SizedBox(height: 16),
            _IndicadorPorcentaje(
              titulo: 'Confianza del modelo',
              porcentaje: resultado.confianza,
              icono: Icons.verified_rounded,
            ),
            _IndicadorPorcentaje(
              titulo: 'Probabilidad de lluvia',
              porcentaje: resultado.probabilidadLluvia,
              icono: Icons.water_drop_rounded,
            ),
            _IndicadorPorcentaje(
              titulo: 'Probabilidad de tormenta',
              porcentaje: resultado.probabilidadTormenta,
              icono: Icons.thunderstorm_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _IndicadorPorcentaje extends StatelessWidget {
  final String titulo;
  final double porcentaje;
  final IconData icono;

  const _IndicadorPorcentaje({
    required this.titulo,
    required this.porcentaje,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    final double valor = porcentaje.clamp(0, 100) / 100;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icono,
                color: ColoresApp.azulPrincipal,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    color: ColoresApp.textoPrincipal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${porcentaje.toStringAsFixed(2)}%',
                style: const TextStyle(
                  color: ColoresApp.azulOscuro,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: valor,
            minHeight: 9,
            borderRadius: BorderRadius.circular(20),
            backgroundColor: ColoresApp.azulPrincipal.withOpacity(0.10),
            color: ColoresApp.azulPrincipal,
          ),
        ],
      ),
    );
  }
}

class _TarjetaRecomendacion extends StatelessWidget {
  final ResultadoClima resultado;
  final Color colorRiesgo;

  const _TarjetaRecomendacion({
    required this.resultado,
    required this.colorRiesgo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: ColoresApp.sombraSuave,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recomendación operativa',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: ColoresApp.azulOscuro,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: colorRiesgo.withOpacity(0.10),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: colorRiesgo.withOpacity(0.35),
                ),
              ),
              child: Text(
                resultado.recomendacion,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: ColoresApp.textoPrincipal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}