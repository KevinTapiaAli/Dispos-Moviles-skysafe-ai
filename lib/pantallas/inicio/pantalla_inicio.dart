import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/analisis_controller.dart';
import '../../utils/colores_app.dart';
import '../../utils/textos_app.dart';
import '../../widgets/animaciones/entrada_animada.dart';
import '../../widgets/botones/boton_gradiente.dart';

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
        backgroundColor: ColoresApp.nocheProfunda,
        elevation: 0,
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EntradaAnimada(
                delay: 0,
                child: _EncabezadoInicio(
                  controller: controller,
                ),
              ),

              const SizedBox(height: 24),

              EntradaAnimada(
                delay: 120,
                child: _TarjetaHeroInicio(
                  onIrCamara: onIrCamara,
                ),
              ),

              const SizedBox(height: 24),

              EntradaAnimada(
                delay: 220,
                child: Obx(() {
                  return Row(
                    children: [
                      Expanded(
                        child: _TarjetaIndicadorInicio(
                          titulo: 'Análisis',
                          valor: '${controller.totalAnalisis}',
                          descripcion: 'registros',
                          icono: Icons.analytics_rounded,
                          color: ColoresApp.azulElectrico,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _TarjetaIndicadorInicio(
                          titulo: 'Confianza',
                          valor:
                              '${controller.promedioConfianza.toStringAsFixed(1)}%',
                          descripcion: 'promedio',
                          icono: Icons.verified_rounded,
                          color: ColoresApp.riesgoBajo,
                        ),
                      ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 24),

              EntradaAnimada(
                delay: 320,
                child: const Text(
                  'Acciones rápidas',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: ColoresApp.textoPrincipal,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              EntradaAnimada(
                delay: 420,
                child: _SeccionAccionesRapidas(
                  onIrCamara: onIrCamara,
                  onIrCentroIA: onIrCentroIA,
                  onIrReportes: onIrReportes,
                ),
              ),

              const SizedBox(height: 26),

              EntradaAnimada(
                delay: 520,
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

              const SizedBox(height: 24),

              const EntradaAnimada(
                delay: 620,
                child: _TarjetaAdvertenciaProfesional(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EncabezadoInicio extends StatelessWidget {
  final AnalisisController controller;

  const _EncabezadoInicio({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool tieneAnalisis = controller.resultadoActual.value != null;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tieneAnalisis ? 'Bienvenido nuevamente' : 'Panel inteligente',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: ColoresApp.textoPrincipal,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            TextosApp.mensajeInicio,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: ColoresApp.textoSecundario,
            ),
          ),
        ],
      );
    });
  }
}

class _TarjetaHeroInicio extends StatelessWidget {
  final VoidCallback? onIrCamara;

  const _TarjetaHeroInicio({
    required this.onIrCamara,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: ColoresApp.gradienteTarjetaHero,
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          ColoresApp.sombraBoton,
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -18,
            child: Icon(
              Icons.cloud_rounded,
              size: 150,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Positioned(
            right: 22,
            bottom: 10,
            child: Icon(
              Icons.radar_rounded,
              size: 70,
              color: Colors.white.withOpacity(0.10),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.20),
                  ),
                ),
                child: const Icon(
                  Icons.flight_takeoff_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Evalúa el cielo antes de decidir',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Captura o selecciona una imagen del cielo y recibe una evaluación visual con IA, nivel de riesgo y recomendación operativa.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.90),
                  fontSize: 14.5,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 24),

              BotonGradiente(
                texto: 'Iniciar análisis IA',
                icono: Icons.camera_alt_rounded,
                onPressed: onIrCamara,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TarjetaIndicadorInicio extends StatelessWidget {
  final String titulo;
  final String valor;
  final String descripcion;
  final IconData icono;
  final Color color;

  const _TarjetaIndicadorInicio({
    required this.titulo,
    required this.valor,
    required this.descripcion,
    required this.icono,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ColoresApp.fondoTarjeta,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: ColoresApp.bordeSuave,
        ),
        boxShadow: [
          ColoresApp.sombraElegante,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icono,
              color: color,
              size: 27,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              color: ColoresApp.textoPrincipal,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: ColoresApp.textoPrincipal,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            descripcion,
            style: const TextStyle(
              fontSize: 12,
              color: ColoresApp.textoSecundario,
            ),
          ),
        ],
      ),
    );
  }
}

class _SeccionAccionesRapidas extends StatelessWidget {
  final VoidCallback? onIrCamara;
  final VoidCallback? onIrCentroIA;
  final VoidCallback? onIrReportes;

  const _SeccionAccionesRapidas({
    required this.onIrCamara,
    required this.onIrCentroIA,
    required this.onIrReportes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AccionPremium(
          titulo: 'Nuevo análisis del cielo',
          subtitulo:
              'Toma una foto o selecciona una imagen para evaluarla con IA.',
          icono: Icons.camera_alt_rounded,
          color: ColoresApp.azulElectrico,
          onTap: onIrCamara,
        ),
        const SizedBox(height: 14),
        _AccionPremium(
          titulo: 'Centro de análisis',
          subtitulo:
              'Consulta el último resultado, historial e indicadores operativos.',
          icono: Icons.auto_graph_rounded,
          color: ColoresApp.violetaIA,
          onTap: onIrCentroIA,
        ),
        const SizedBox(height: 14),
        _AccionPremium(
          titulo: 'Reporte profesional',
          subtitulo: 'Genera un reporte del análisis para presentar o guardar.',
          icono: Icons.picture_as_pdf_rounded,
          color: ColoresApp.riesgoAlto,
          onTap: onIrReportes,
        ),
      ],
    );
  }
}

class _AccionPremium extends StatefulWidget {
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final Color color;
  final VoidCallback? onTap;

  const _AccionPremium({
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    required this.color,
    required this.onTap,
  });

  @override
  State<_AccionPremium> createState() => _AccionPremiumState();
}

class _AccionPremiumState extends State<_AccionPremium> {
  bool presionado = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => presionado = true),
      onTapCancel: () => setState(() => presionado = false),
      onTapUp: (_) => setState(() => presionado = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: presionado ? 0.98 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: ColoresApp.fondoTarjeta,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: ColoresApp.bordeSuave,
            ),
            boxShadow: [
              ColoresApp.sombraElegante,
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Icon(
                  widget.icono,
                  color: widget.color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: ColoresApp.textoPrincipal,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.subtitulo,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: ColoresApp.textoSecundario,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: ColoresApp.textoSecundario.withOpacity(0.75),
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
        color: ColoresApp.fondoTarjeta,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: ColoresApp.bordeSuave,
        ),
        boxShadow: [
          ColoresApp.sombraElegante,
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              gradient: ColoresApp.gradienteBoton,
              shape: BoxShape.circle,
              boxShadow: [
                ColoresApp.sombraBoton,
              ],
            ),
            child: const Icon(
              Icons.cloud_upload_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Aún no realizaste un análisis',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: ColoresApp.textoPrincipal,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Selecciona una imagen del cielo para obtener una evaluación visual, nivel de riesgo y recomendación operativa.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.55,
              color: ColoresApp.textoSecundario,
            ),
          ),
          const SizedBox(height: 20),
          BotonGradiente(
            texto: 'Analizar ahora',
            icono: Icons.camera_alt_rounded,
            onPressed: onIrCamara,
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

  Color _colorRiesgo() {
    switch (riesgo.toLowerCase()) {
      case 'bajo':
        return ColoresApp.riesgoBajo;
      case 'medio':
        return ColoresApp.riesgoMedio;
      case 'alto':
        return ColoresApp.riesgoAlto;
      default:
        return ColoresApp.azulElectrico;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color colorRiesgo = _colorRiesgo();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: ColoresApp.fondoTarjeta,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: ColoresApp.bordeSuave,
        ),
        boxShadow: [
          ColoresApp.sombraElegante,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Último análisis',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: ColoresApp.textoPrincipal,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: ColoresApp.cianSuave,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.cloud_done_rounded,
                  color: ColoresApp.azulElectrico,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  estado.replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: ColoresApp.textoPrincipal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Confianza del modelo',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: ColoresApp.textoSecundario,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (confianza.clamp(0, 100)) / 100,
            minHeight: 10,
            borderRadius: BorderRadius.circular(20),
            backgroundColor: ColoresApp.bordeSuave,
            color: ColoresApp.azulElectrico,
          ),
          const SizedBox(height: 8),
          Text(
            '${confianza.toStringAsFixed(2)}%',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: ColoresApp.textoPrincipal,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: colorRiesgo.withOpacity(0.12),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: colorRiesgo.withOpacity(0.30),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.shield_rounded,
                  color: colorRiesgo,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Nivel de riesgo: $riesgo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: colorRiesgo,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            recomendacion,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              height: 1.55,
              color: ColoresApp.textoSecundario,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
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

class _TarjetaAdvertenciaProfesional extends StatelessWidget {
  const _TarjetaAdvertenciaProfesional();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ColoresApp.naranjaSuave,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: ColoresApp.riesgoMedio.withOpacity(0.25),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_rounded,
            color: ColoresApp.riesgoMedio,
            size: 26,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              TextosApp.advertencia,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.55,
                fontWeight: FontWeight.w500,
                color: ColoresApp.textoPrincipal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}