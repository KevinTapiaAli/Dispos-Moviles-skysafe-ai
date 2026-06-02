import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/rutas_app.dart';
import '../../controllers/analisis_controller.dart';
import '../../modelos/resultado_clima.dart';
import '../../servicios/servicio_reportes.dart';
import '../../utils/colores_app.dart';

class PantallaReportes extends StatelessWidget {
  const PantallaReportes({super.key});

  @override
  Widget build(BuildContext context) {
    final AnalisisController controller = Get.find<AnalisisController>();
    final ServicioReportes servicioReportes = ServicioReportes();

    return Scaffold(
      backgroundColor: ColoresApp.fondoClaro,
      appBar: AppBar(
        title: const Text('Reportes'),
      ),
      body: SafeArea(
        child: Obx(() {
          final ResultadoClima? resultado = controller.resultadoActual.value;
          final File? imagen = controller.imagenSeleccionada.value;

          if (resultado == null) {
            return const _ReporteVacio();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Generación de reportes',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: ColoresApp.azulOscuro,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Exporta el último análisis meteorológico visual en formato PDF para imprimir, compartir o presentar.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: ColoresApp.textoSecundario,
                  ),
                ),

                const SizedBox(height: 22),

                _TarjetaVistaPrevia(
                  resultado: resultado,
                  imagen: imagen,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await servicioReportes.generarReportePDF(
                          resultado: resultado,
                          imagen: imagen,
                        );
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'No se pudo generar el reporte PDF: $e',
                          backgroundColor: ColoresApp.riesgoAlto,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    icon: const Icon(Icons.picture_as_pdf_rounded),
                    label: const Text('Generar reporte PDF'),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.snackbar(
                        'Reporte Word',
                        'El reporte Word se agregará en una siguiente mejora. Por ahora el PDF ya está funcional.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: const Icon(Icons.description_rounded),
                    label: const Text('Reporte Word próximamente'),
                  ),
                ),

                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: ColoresApp.azulPrincipal.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: ColoresApp.azulPrincipal.withOpacity(0.20),
                    ),
                  ),
                  child: const Text(
                    'El PDF incluye: imagen analizada, estado detectado, confianza del modelo, probabilidad de lluvia, probabilidad de tormenta, nivel de riesgo, recomendación operativa y nota de uso académico.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: ColoresApp.textoSecundario,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _ReporteVacio extends StatelessWidget {
  const _ReporteVacio();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.picture_as_pdf_rounded,
              size: 82,
              color: ColoresApp.azulPrincipal,
            ),
            const SizedBox(height: 18),
            const Text(
              'No hay datos para reportar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: ColoresApp.azulOscuro,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Primero realiza un análisis de imagen para poder generar un reporte PDF.',
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
              label: const Text('Realizar análisis'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaVistaPrevia extends StatelessWidget {
  final ResultadoClima resultado;
  final File? imagen;

  const _TarjetaVistaPrevia({
    required this.resultado,
    required this.imagen,
  });

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
    final Color colorRiesgo = _colorRiesgo(resultado.nivelRiesgo);

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
            if (imagen != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.file(
                  imagen!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            if (imagen != null) const SizedBox(height: 16),

            const Text(
              'Vista previa del reporte',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: ColoresApp.azulOscuro,
              ),
            ),

            const SizedBox(height: 14),

            _FilaReporte(
              titulo: 'Estado detectado',
              valor: resultado.estadoDetectado.replaceAll('_', ' ').toUpperCase(),
              icono: Icons.cloud_rounded,
            ),
            _FilaReporte(
              titulo: 'Confianza',
              valor: '${resultado.confianza.toStringAsFixed(2)}%',
              icono: Icons.verified_rounded,
            ),
            _FilaReporte(
              titulo: 'Lluvia',
              valor: '${resultado.probabilidadLluvia.toStringAsFixed(2)}%',
              icono: Icons.water_drop_rounded,
            ),
            _FilaReporte(
              titulo: 'Tormenta',
              valor: '${resultado.probabilidadTormenta.toStringAsFixed(2)}%',
              icono: Icons.thunderstorm_rounded,
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: colorRiesgo.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorRiesgo.withOpacity(0.40),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: colorRiesgo,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Nivel de riesgo: ${resultado.nivelRiesgo}',
                      style: TextStyle(
                        color: colorRiesgo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            const Text(
              'Recomendación operativa',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColoresApp.textoPrincipal,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              resultado.recomendacion,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: ColoresApp.textoSecundario,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilaReporte extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;

  const _FilaReporte({
    required this.titulo,
    required this.valor,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
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
                color: ColoresApp.textoSecundario,
              ),
            ),
          ),
          Text(
            valor,
            style: const TextStyle(
              color: ColoresApp.textoPrincipal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}