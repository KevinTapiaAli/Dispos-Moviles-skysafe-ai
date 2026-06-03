
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import '../../servicios/servicio_analisis_respaldo.dart';

import '../../controllers/analisis_controller.dart';
import '../../modelos/analisis_avanzado.dart';
import '../../modelos/resultado_clima.dart';
import '../../servicios/servicio_gemini.dart';
import '../../servicios/servicio_ia.dart';
import '../../utils/colores_app.dart';
import '../../utils/textos_app.dart';
import '../../widgets/animaciones/entrada_animada.dart';
import '../../widgets/botones/boton_gradiente.dart';

class PantallaCamaraIA extends StatefulWidget {
  final VoidCallback? onIrCentroIA;
  final VoidCallback? onIrReportes;

  const PantallaCamaraIA({
    super.key,
    this.onIrCentroIA,
    this.onIrReportes,
  });

  @override
  State<PantallaCamaraIA> createState() => _PantallaCamaraIAState();
}

class _PantallaCamaraIAState extends State<PantallaCamaraIA> {
  final ImagePicker _imagePicker = ImagePicker();
  final ServicioIA _servicioIA = ServicioIA();
  final ServicioGemini _servicioGemini = ServicioGemini();
  final ServicioAnalisisRespaldo _servicioRespaldo = ServicioAnalisisRespaldo();
  final AnalisisController _controller = Get.find<AnalisisController>();

  Future<void> _tomarFoto() async {
    try {
      final XFile? foto = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (foto == null) {
        _mostrarMensaje(
          titulo: 'Acción cancelada',
          mensaje: 'No se tomó ninguna fotografía.',
          color: ColoresApp.riesgoMedio,
        );
        return;
      }

      await _procesarImagen(File(foto.path));
    } catch (e) {
      _mostrarMensaje(
        titulo: 'Error al abrir cámara',
        mensaje: 'No se pudo acceder a la cámara del dispositivo.',
        color: ColoresApp.riesgoAlto,
      );
    }
  }

  Future<void> _seleccionarDesdeGaleria() async {
    try {
      final XFile? imagenSeleccionada = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (imagenSeleccionada == null) {
        _mostrarMensaje(
          titulo: 'Acción cancelada',
          mensaje: 'No se seleccionó ninguna imagen.',
          color: ColoresApp.riesgoMedio,
        );
        return;
      }

      await _procesarImagen(File(imagenSeleccionada.path));
    } catch (e) {
      _mostrarMensaje(
        titulo: 'Error al abrir galería',
        mensaje: 'No se pudo seleccionar una imagen desde la galería.',
        color: ColoresApp.riesgoAlto,
      );
    }
  }

  Future<void> _procesarImagen(File imagen) async {
    _controller.guardarImagen(imagen);
    _controller.resultadoActual.value = null;
    _controller.analisisAvanzado.value = null;

    await _analizarConModeloLocal(imagen);
  }

  Future<void> _analizarConModeloLocal(File imagen) async {
    _controller.cambiarCarga(true);

    try {
      final ResultadoClima resultadoLocal =
          await _servicioIA.analizarImagen(imagen);

      _controller.guardarResultado(resultadoLocal);

      _mostrarMensaje(
        titulo: 'Análisis local completado',
        mensaje: 'El modelo TensorFlow Lite generó un resultado inicial.',
        color: ColoresApp.azulElectrico,
      );

      await _analizarConGemini(
        imagen: imagen,
        resultadoLocal: resultadoLocal,
      );
    } catch (e) {
      _mostrarMensaje(
        titulo: 'Error de análisis',
        mensaje: 'No se pudo analizar la imagen con el modelo local.',
        color: ColoresApp.riesgoAlto,
      );
    } finally {
      _controller.cambiarCarga(false);
    }
  }

  Future<void> _analizarConGemini({
    required File imagen,
    required ResultadoClima resultadoLocal,
  }) async {
    _controller.cambiarCargaAvanzada(true);

    try {
      final AnalisisAvanzado analisisAvanzado =
          await _servicioGemini.analizarImagenAvanzada(
        imagen: imagen,
        resultadoLocal: resultadoLocal,
      );

      _controller.guardarAnalisisAvanzado(analisisAvanzado);

      _mostrarMensaje(
        titulo: 'Análisis avanzado completado',
        mensaje: 'Gemini generó una segunda evaluación visual.',
        color: ColoresApp.violetaIA,
      );
    } catch (e) {
      debugPrint('========== ERROR GEMINI ==========');
      debugPrint(e.toString());
      debugPrint('==================================');

      final AnalisisAvanzado respaldo =
          _servicioRespaldo.generarDesdeResultadoLocal(resultadoLocal);

      _controller.guardarAnalisisAvanzado(respaldo);

    _mostrarMensaje(
        titulo: 'Análisis avanzado local generado',
        mensaje:
            'Gemini no respondió por cuota o conexión, pero la app generó una explicación profesional con el resultado local.',
        color: ColoresApp.riesgoMedio,
      );
    } finally {
      _controller.cambiarCargaAvanzada(false);
    }
  }

  void _mostrarMensaje({
    required String titulo,
    required String mensaje,
    required Color color,
  }) {
    Get.snackbar(
      titulo,
      mensaje,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 18,
      duration: const Duration(seconds: 3),
    );
  }

  Color _colorRiesgo(String riesgo) {
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
    return Scaffold(
      backgroundColor: ColoresApp.fondoClaro,
      appBar: AppBar(
        title: const Text('Análisis IA'),
        backgroundColor: ColoresApp.nocheProfunda,
        elevation: 0,
      ),
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final File? imagen = _controller.imagenSeleccionada.value;
          final ResultadoClima? resultado = _controller.resultadoActual.value;
          final AnalisisAvanzado? avanzado =
              _controller.analisisAvanzado.value;

          final bool cargando = _controller.cargando.value;
          final bool cargandoAvanzado = _controller.cargandoAvanzado.value;
          final bool bloqueado = cargando || cargandoAvanzado;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const EntradaAnimada(
                  delay: 0,
                  child: _EncabezadoCamara(),
                ),

                const SizedBox(height: 22),

                EntradaAnimada(
                  delay: 120,
                  child: _TarjetaImagenAnalisis(
                    imagen: imagen,
                    cargando: cargando,
                    cargandoAvanzado: cargandoAvanzado,
                  ),
                ),

                const SizedBox(height: 18),

                EntradaAnimada(
                  delay: 220,
                  child: Row(
                    children: [
                      Expanded(
                        child: BotonGradiente(
                          texto: 'Cámara',
                          icono: Icons.camera_alt_rounded,
                          onPressed: bloqueado ? null : _tomarFoto,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _BotonSecundario(
                          texto: 'Galería',
                          icono: Icons.image_rounded,
                          onTap: bloqueado ? null : _seleccionarDesdeGaleria,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                if (cargando)
                  const EntradaAnimada(
                    delay: 100,
                    child: _TarjetaProceso(
                      icono: Icons.memory_rounded,
                      titulo: 'Analizando con modelo local',
                      mensaje:
                          'TensorFlow Lite está clasificando la imagen directamente desde el dispositivo.',
                      color: ColoresApp.azulElectrico,
                    ),
                  ),

                if (resultado != null && !cargando) ...[
                  EntradaAnimada(
                    delay: 260,
                    child: _TarjetaResultadoLocal(
                      resultado: resultado,
                      colorRiesgo: _colorRiesgo(resultado.nivelRiesgo),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],

                if (cargandoAvanzado)
                  const EntradaAnimada(
                    delay: 320,
                    child: _TarjetaProceso(
                      icono: Icons.auto_awesome_rounded,
                      titulo: 'Generando análisis avanzado',
                      mensaje:
                          'Gemini está revisando la imagen como segunda opinión para mejorar la explicación y el reporte.',
                      color: ColoresApp.violetaIA,
                    ),
                  ),

                if (avanzado != null && !cargandoAvanzado) ...[
                  EntradaAnimada(
                    delay: 380,
                    child: _TarjetaResultadoAvanzado(
                      analisis: avanzado,
                      colorRiesgo: _colorRiesgo(avanzado.nivelRiesgo),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],

                if (resultado != null && !cargando) ...[
                  EntradaAnimada(
                    delay: 460,
                    child: _AccionesResultado(
                      onIrCentroIA: widget.onIrCentroIA,
                      onIrReportes: widget.onIrReportes,
                    ),
                  ),
                  const SizedBox(height: 18),
                ],

                const EntradaAnimada(
                  delay: 540,
                  child: _TarjetaAvisoUso(),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _EncabezadoCamara extends StatelessWidget {
  const _EncabezadoCamara();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Escanea el cielo',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: ColoresApp.textoPrincipal,
            height: 1.15,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Selecciona una imagen o toma una fotografía. Primero se analiza con el modelo local y luego se complementa con Gemini para una explicación más profesional.',
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: ColoresApp.textoSecundario,
          ),
        ),
      ],
    );
  }
}

class _TarjetaImagenAnalisis extends StatelessWidget {
  final File? imagen;
  final bool cargando;
  final bool cargandoAvanzado;

  const _TarjetaImagenAnalisis({
    required this.imagen,
    required this.cargando,
    required this.cargandoAvanzado,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: double.infinity,
      height: 310,
      decoration: BoxDecoration(
        color: ColoresApp.fondoTarjeta,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: ColoresApp.bordeSuave,
        ),
        boxShadow: [
          ColoresApp.sombraElegante,
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imagen != null)
              Image.file(
                imagen!,
                fit: BoxFit.cover,
              )
            else
              Container(
                decoration: const BoxDecoration(
                  gradient: ColoresApp.gradienteTarjetaHero,
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_rounded,
                      color: Colors.white,
                      size: 72,
                    ),
                    SizedBox(height: 18),
                    Text(
                      'Esperando imagen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 34),
                      child: Text(
                        'Usa la cámara o galería para iniciar el análisis inteligente del cielo.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          height: 1.5,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (imagen != null)
              const Positioned(
                left: 16,
                top: 16,
                child: _EtiquetaImagen(
                  texto: 'Imagen cargada',
                  icono: Icons.image_rounded,
                ),
              ),

            if (cargando || cargandoAvanzado)
              Container(
                color: Colors.black.withOpacity(0.52),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        cargando
                            ? 'Analizando imagen...'
                            : 'Consultando Gemini...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EtiquetaImagen extends StatelessWidget {
  final String texto;
  final IconData icono;

  const _EtiquetaImagen({
    required this.texto,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.48),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            icono,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 7),
          Text(
            texto,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BotonSecundario extends StatefulWidget {
  final String texto;
  final IconData icono;
  final VoidCallback? onTap;

  const _BotonSecundario({
    required this.texto,
    required this.icono,
    required this.onTap,
  });

  @override
  State<_BotonSecundario> createState() => _BotonSecundarioState();
}

class _BotonSecundarioState extends State<_BotonSecundario> {
  bool presionado = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => presionado = true),
      onTapCancel: () => setState(() => presionado = false),
      onTapUp: (_) => setState(() => presionado = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: presionado ? 0.97 : 1,
        duration: const Duration(milliseconds: 140),
        child: AnimatedOpacity(
          opacity: widget.onTap == null ? 0.55 : 1,
          duration: const Duration(milliseconds: 180),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: ColoresApp.fondoTarjeta,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: ColoresApp.azulElectrico.withOpacity(0.35),
                width: 1.4,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icono,
                  color: ColoresApp.azulElectrico,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.texto,
                  style: const TextStyle(
                    color: ColoresApp.azulElectrico,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
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

class _TarjetaProceso extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String mensaje;
  final Color color;

  const _TarjetaProceso({
    required this.icono,
    required this.titulo,
    required this.mensaje,
    required this.color,
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
          CircularProgressIndicator(
            color: color,
          ),
          const SizedBox(height: 18),
          Icon(
            icono,
            color: color,
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: ColoresApp.textoPrincipal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.55,
              color: ColoresApp.textoSecundario,
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaResultadoLocal extends StatelessWidget {
  final ResultadoClima resultado;
  final Color colorRiesgo;

  const _TarjetaResultadoLocal({
    required this.resultado,
    required this.colorRiesgo,
  });

  @override
  Widget build(BuildContext context) {
    final double confianza = resultado.confianza.clamp(0, 100);

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
          const _TituloSeccion(
            icono: Icons.memory_rounded,
            titulo: 'Resultado local',
            subtitulo: 'Clasificación generada con TensorFlow Lite.',
            color: ColoresApp.azulElectrico,
          ),
          const SizedBox(height: 18),
          _FilaDato(
            icono: Icons.cloud_rounded,
            titulo: 'Estado detectado',
            valor: resultado.estadoDetectado.replaceAll('_', ' '),
          ),
          const SizedBox(height: 12),
          _FilaDato(
            icono: Icons.water_drop_rounded,
            titulo: 'Probabilidad de lluvia',
            valor: '${resultado.probabilidadLluvia.toStringAsFixed(2)}%',
          ),
          const SizedBox(height: 12),
          _FilaDato(
            icono: Icons.thunderstorm_rounded,
            titulo: 'Probabilidad de tormenta',
            valor: '${resultado.probabilidadTormenta.toStringAsFixed(2)}%',
          ),
          const SizedBox(height: 18),
          const Text(
            'Confianza del modelo local',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: ColoresApp.textoSecundario,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: confianza / 100,
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
              fontWeight: FontWeight.w900,
              color: ColoresApp.textoPrincipal,
            ),
          ),
          const SizedBox(height: 18),
          _EtiquetaRiesgo(
            riesgo: resultado.nivelRiesgo,
            color: colorRiesgo,
          ),
          const SizedBox(height: 16),
          _CajaRecomendacion(
            titulo: 'Recomendación local',
            texto: resultado.recomendacion,
            color: ColoresApp.azulElectrico,
          ),
        ],
      ),
    );
  }
}

class _TarjetaResultadoAvanzado extends StatelessWidget {
  final AnalisisAvanzado analisis;
  final Color colorRiesgo;

  const _TarjetaResultadoAvanzado({
    required this.analisis,
    required this.colorRiesgo,
  });

  @override
  Widget build(BuildContext context) {
    final double confianza = analisis.confianzaGemini.clamp(0, 100);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColoresApp.violetaIA.withOpacity(0.10),
            ColoresApp.cianNeon.withOpacity(0.08),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: ColoresApp.violetaIA.withOpacity(0.20),
        ),
        boxShadow: [
          ColoresApp.sombraElegante,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TituloSeccion(
            icono: Icons.auto_awesome_rounded,
            titulo: 'Análisis avanzado',
            subtitulo: 'Segunda evaluación visual generada con Gemini.',
            color: ColoresApp.violetaIA,
          ),
          const SizedBox(height: 18),
          _FilaDato(
            icono: Icons.visibility_rounded,
            titulo: 'Estado visual',
            valor: analisis.estadoVisual.replaceAll('_', ' '),
          ),
          const SizedBox(height: 12),
          _FilaDato(
            icono: Icons.water_drop_rounded,
            titulo: 'Probabilidad de lluvia',
            valor: '${analisis.probabilidadLluvia.toStringAsFixed(2)}%',
          ),
          const SizedBox(height: 12),
          _FilaDato(
            icono: Icons.thunderstorm_rounded,
            titulo: 'Probabilidad de tormenta',
            valor: '${analisis.probabilidadTormenta.toStringAsFixed(2)}%',
          ),
          const SizedBox(height: 18),
          const Text(
            'Confianza de segunda opinión',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: ColoresApp.textoSecundario,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: confianza / 100,
            minHeight: 10,
            borderRadius: BorderRadius.circular(20),
            backgroundColor: ColoresApp.bordeSuave,
            color: ColoresApp.violetaIA,
          ),
          const SizedBox(height: 8),
          Text(
            '${confianza.toStringAsFixed(2)}%',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: ColoresApp.textoPrincipal,
            ),
          ),
          const SizedBox(height: 18),
          _EtiquetaRiesgo(
            riesgo: analisis.nivelRiesgo,
            color: colorRiesgo,
          ),
          const SizedBox(height: 16),
          _CajaRecomendacion(
            titulo: 'Explicación para el usuario',
            texto: analisis.explicacion,
            color: ColoresApp.violetaIA,
          ),
          const SizedBox(height: 12),
          _CajaRecomendacion(
            titulo: 'Recomendación avanzada',
            texto: analisis.recomendacion,
            color: ColoresApp.azulElectrico,
          ),
          if (analisis.requiereRevision) ...[
            const SizedBox(height: 12),
            _CajaRecomendacion(
              titulo: 'Revisión sugerida',
              texto:
                  'La imagen requiere revisión adicional porque no muestra claramente las condiciones del cielo o presenta señales ambiguas.',
              color: ColoresApp.riesgoMedio,
            ),
          ],
        ],
      ),
    );
  }
}

class _TituloSeccion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final Color color;

  const _TituloSeccion({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
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
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: ColoresApp.textoPrincipal,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitulo,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.35,
                  color: ColoresApp.textoSecundario,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilaDato extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String valor;

  const _FilaDato({
    required this.icono,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icono,
          color: ColoresApp.azulElectrico,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(
              fontSize: 14,
              color: ColoresApp.textoSecundario,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            valor,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: ColoresApp.textoPrincipal,
            ),
          ),
        ),
      ],
    );
  }
}

class _EtiquetaRiesgo extends StatelessWidget {
  final String riesgo;
  final Color color;

  const _EtiquetaRiesgo({
    required this.riesgo,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: color.withOpacity(0.30),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shield_rounded,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Nivel de riesgo: $riesgo',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CajaRecomendacion extends StatelessWidget {
  final String titulo;
  final String texto;
  final Color color;

  const _CajaRecomendacion({
    required this.titulo,
    required this.texto,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: color.withOpacity(0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            texto,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.55,
              color: ColoresApp.textoPrincipal,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccionesResultado extends StatelessWidget {
  final VoidCallback? onIrCentroIA;
  final VoidCallback? onIrReportes;

  const _AccionesResultado({
    required this.onIrCentroIA,
    required this.onIrReportes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _BotonSecundario(
            texto: 'Centro IA',
            icono: Icons.auto_graph_rounded,
            onTap: onIrCentroIA,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _BotonSecundario(
            texto: 'Reporte',
            icono: Icons.picture_as_pdf_rounded,
            onTap: onIrReportes,
          ),
        ),
      ],
    );
  }
}

class _TarjetaAvisoUso extends StatelessWidget {
  const _TarjetaAvisoUso();

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