import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/analisis_controller.dart';
import '../../utils/colores_app.dart';
import '../../utils/textos_app.dart';

class PantallaInicio extends StatelessWidget {
  final VoidCallback? onIrCamara;
  final VoidCallback? onIrCentroIA;
  final VoidCallback? onIrReportes;

  const PantallaInicio({
    super.key,
    this.onIrCamara,
    this.onIrCentroIA,
    this.onIrReportes,
  });

  @override
  Widget build(BuildContext context) {
    final AnalisisController controller = Get.find<AnalisisController>();

    return Scaffold(
      backgroundColor: ColoresApp.fondoClaro,
      appBar: AppBar(
        title: const Text('CieloSeguro IA'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AnimacionEntrada(
                delay: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Panel inteligente',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: ColoresApp.grisOscuro,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      TextosApp.mensajeInicio,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: ColoresApp.grisTexto,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _AnimacionEntrada(
                delay: 100,
                child: _TarjetaHero(
                  onIrCamara: onIrCamara,
                ),
              ),
              const SizedBox(height: 24),
              _AnimacionEntrada(
                delay: 200,
                child: Obx(() {
                  return Row(
                    children: [
                      Expanded(
                        child: _TarjetaEstadistica(
                          titulo: 'Análisis',
                          valor: '${controller.totalAnalisis}',
                          icono: Icons.analytics_rounded,
                          color: ColoresApp.azulPrincipal,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _TarjetaEstadistica(
                          titulo: 'Promedio IA',
                          valor:
                              '${controller.promedioConfianza.toStringAsFixed(1)}%',
                          icono: Icons.verified_rounded,
                          color: ColoresApp.verdeExito,
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 24),
              _AnimacionEntrada(
                delay: 300,
                child: const Text(
                  'Acciones rápidas',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: ColoresApp.grisOscuro,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _AnimacionEntrada(
                delay: 400,
                child: _AccionesRapidas(
                  onIrCamara: onIrCamara,
                  onIrCentroIA: onIrCentroIA,
                  onIrReportes: onIrReportes,
                ),
              ),
              const SizedBox(height: 24),
              _AnimacionEntrada(
                delay: 500,
                child: Obx(() {
                  final resultado = controller.resultadoActual.value;

                  if (resultado == null) {
                    return _TarjetaSinAnalisis(
                      onIrCamara: onIrCamara,
                    );
                  }

                  return _TarjetaUltimoResultado(
                    estado: resultado.estadoDetectado,
                    confianza: resultado.confianza,
                    riesgo: resultado.nivelRiesgo,
                    recomendacion: resultado.recomendacion,
                    onIrCentroIA: onIrCentroIA,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TarjetaHero extends StatelessWidget {
  final VoidCallback? onIrCamara;

  const _TarjetaHero({
    required this.onIrCamara,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: ColoresApp.gradienteTarjetaHero,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: ColoresApp.azulPrincipal.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: -4,
            child: Icon(
              Icons.cloud_rounded,
              size: 110,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.radar_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Evalúa el cielo en segundos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Toma una imagen del cielo, analiza la condición visual y recibe un nivel de riesgo operativo con inteligencia artificial.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 22),
              ElevatedButton.icon(
                onPressed: onIrCamara,
                icon: const Icon(Icons.camera_alt_rounded),
                label: const Text('Iniciar análisis IA'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: ColoresApp.azulPrincipal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TarjetaEstadistica extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;
  final Color color;

  const _TarjetaEstadistica({
    required this.titulo,
    required this.valor,
    required this.icono,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(
              icono,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 26,
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
}
class _AccionesRapidas extends StatelessWidget {
  final VoidCallback? onIrCamara;
  final VoidCallback? onIrCentroIA;
  final VoidCallback? onIrReportes;

  const _AccionesRapidas({
    required this.onIrCamara,
    required this.onIrCentroIA,
    required this.onIrReportes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AccionHorizontal(
          titulo: 'Nuevo análisis meteorológico',
          subtitulo: 'Usa la cámara o galería para evaluar el cielo.',
          icono: Icons.camera_alt_rounded,
          color: ColoresApp.azulPrincipal,
          onTap: onIrCamara,
        ),
        const SizedBox(height: 12),
        _AccionHorizontal(
          titulo: 'Centro de Análisis IA',
          subtitulo: 'Último resultado, historial e indicadores juntos.',
          icono: Icons.auto_graph_rounded,
          color: ColoresApp.cianSuave,
          onTap: onIrCentroIA,
        ),
        const SizedBox(height: 12),
        _AccionHorizontal(
          titulo: 'Generar reporte operativo',
          subtitulo: 'Exporta el análisis en PDF para presentar.',
          icono: Icons.picture_as_pdf_rounded,
          color: ColoresApp.rojoError,
          onTap: onIrReportes,
        ),
      ],
    );
  }
}

class _AccionHorizontal extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final Color color;
  final VoidCallback? onTap;

  const _AccionHorizontal({
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  icono,
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ColoresApp.grisOscuro,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitulo,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: ColoresApp.grisTexto,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: ColoresApp.grisTexto,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TarjetaSinAnalisis extends StatelessWidget {
  final VoidCallback? onIrCamara;

  const _TarjetaSinAnalisis({
    required this.onIrCamara,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: ColoresApp.grisClaro,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_upload_rounded,
            size: 48,
            color: ColoresApp.azulPrincipal,
          ),
          const SizedBox(height: 14),
          const Text(
            'Todavía no hay análisis',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: ColoresApp.grisOscuro,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Realiza tu primer análisis visual para obtener una recomendación operativa.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColoresApp.grisTexto,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: onIrCamara,
            icon: const Icon(Icons.camera_alt_rounded),
            label: const Text('Analizar ahora'),
          ),
        ],
      ),
    );
  }
}

class _TarjetaUltimoResultado extends StatelessWidget {
  final String estado;
  final double confianza;
  final String riesgo;
  final String recomendacion;
  final VoidCallback? onIrCentroIA;

  const _TarjetaUltimoResultado({
    required this.estado,
    required this.confianza,
    required this.riesgo,
    required this.recomendacion,
    required this.onIrCentroIA,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Último resultado',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: ColoresApp.grisOscuro,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: ColoresApp.celesteClaro,
                child: Icon(
                  Icons.cloud_done_rounded,
                  color: ColoresApp.azulPrincipal,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  estado.replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: ColoresApp.grisOscuro,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Confianza IA: ${confianza.toStringAsFixed(2)}%',
            style: const TextStyle(
              color: ColoresApp.grisTexto,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Nivel de riesgo: $riesgo',
            style: const TextStyle(
              color: ColoresApp.grisTexto,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            recomendacion,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              height: 1.5,
              color: ColoresApp.grisTexto,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onIrCentroIA,
              icon: const Icon(Icons.auto_graph_rounded),
              label: const Text('Ver análisis completo'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimacionEntrada extends StatelessWidget {
  final Widget child;
  final int delay;

  const _AnimacionEntrada({
    required this.child,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}