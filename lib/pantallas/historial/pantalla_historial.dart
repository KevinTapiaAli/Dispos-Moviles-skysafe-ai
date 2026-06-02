import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../app/rutas_app.dart';
import '../../controllers/analisis_controller.dart';
import '../../modelos/resultado_clima.dart';
import '../../utils/colores_app.dart';

class PantallaHistorial extends StatelessWidget {
  const PantallaHistorial({super.key});

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
        title: const Text('Historial de Análisis'),
        actions: [
          Obx(() {
            if (controller.historial.isEmpty) {
              return const SizedBox.shrink();
            }

            return IconButton(
              onPressed: () {
                controller.limpiarHistorial();

                Get.snackbar(
                  'Historial',
                  'El historial fue limpiado correctamente.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: const Icon(Icons.delete_outline_rounded),
            );
          }),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.historial.isEmpty) {
            return const _HistorialVacio();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: controller.historial.length,
            itemBuilder: (context, index) {
              final ResultadoClima resultado = controller.historial[index];

              File? imagen;
              if (resultado.rutaImagen != null) {
                final archivo = File(resultado.rutaImagen!);
                if (archivo.existsSync()) {
                  imagen = archivo;
                }
              }

              return _TarjetaHistorial(
                resultado: resultado,
                imagen: imagen,
                colorRiesgo: _colorRiesgo(resultado.nivelRiesgo),
              );
            },
          );
        }),
      ),
    );
  }
}

class _HistorialVacio extends StatelessWidget {
  const _HistorialVacio();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.history_rounded,
              size: 82,
              color: ColoresApp.azulPrincipal,
            ),
            const SizedBox(height: 18),
            const Text(
              'No hay análisis guardados',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: ColoresApp.azulOscuro,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Cuando analices una imagen del cielo, el resultado aparecerá aquí en el historial.',
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

class _TarjetaHistorial extends StatelessWidget {
  final ResultadoClima resultado;
  final File? imagen;
  final Color colorRiesgo;

  const _TarjetaHistorial({
    required this.resultado,
    required this.imagen,
    required this.colorRiesgo,
  });

  @override
  Widget build(BuildContext context) {
    final String fecha = DateFormat('dd/MM/yyyy HH:mm').format(
      resultado.fechaAnalisis,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 6,
      shadowColor: ColoresApp.sombraSuave,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagen != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.file(
                  imagen!,
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            if (imagen != null) const SizedBox(height: 16),

            Row(
              children: [
                const Icon(
                  Icons.cloud_rounded,
                  color: ColoresApp.azulPrincipal,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    resultado.estadoDetectado.replaceAll('_', ' ').toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColoresApp.azulOscuro,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              fecha,
              style: const TextStyle(
                color: ColoresApp.textoSecundario,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 12),

            _DatoHistorial(
              titulo: 'Confianza del modelo',
              valor: '${resultado.confianza.toStringAsFixed(2)}%',
              icono: Icons.verified_rounded,
            ),
            _DatoHistorial(
              titulo: 'Probabilidad de lluvia',
              valor: '${resultado.probabilidadLluvia.toStringAsFixed(2)}%',
              icono: Icons.water_drop_rounded,
            ),
            _DatoHistorial(
              titulo: 'Probabilidad de tormenta',
              valor: '${resultado.probabilidadTormenta.toStringAsFixed(2)}%',
              icono: Icons.thunderstorm_rounded,
            ),

            const SizedBox(height: 12),

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
              child: Text(
                'Nivel de riesgo: ${resultado.nivelRiesgo}',
                style: TextStyle(
                  color: colorRiesgo,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  final AnalisisController controller =
                      Get.find<AnalisisController>();

                  controller.guardarResultado(resultado);

                  if (resultado.rutaImagen != null) {
                    final archivo = File(resultado.rutaImagen!);
                    if (archivo.existsSync()) {
                      controller.guardarImagen(archivo);
                    }
                  }

                  Get.toNamed(RutasApp.resultado);
                },
                icon: const Icon(Icons.visibility_rounded),
                label: const Text('Ver resultado completo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatoHistorial extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;

  const _DatoHistorial({
    required this.titulo,
    required this.valor,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Icon(
            icono,
            size: 21,
            color: ColoresApp.azulPrincipal,
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