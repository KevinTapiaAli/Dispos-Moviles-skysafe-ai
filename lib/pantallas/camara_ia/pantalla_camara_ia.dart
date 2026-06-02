import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/analisis_controller.dart';
import '../../modelos/resultado_clima.dart';
import '../../servicios/servicio_ia.dart';
import '../../utils/colores_app.dart';

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
  final AnalisisController _controller = Get.find<AnalisisController>();

  Future<void> _tomarFoto() async {
    final XFile? foto = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (foto == null) return;

    final File imagen = File(foto.path);

    _controller.guardarImagen(imagen);
    _controller.resultadoActual.value = null;

    await _analizarImagen(imagen);
  }

  Future<void> _seleccionarDesdeGaleria() async {
    final XFile? imagenSeleccionada = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (imagenSeleccionada == null) return;

    final File imagen = File(imagenSeleccionada.path);

    _controller.guardarImagen(imagen);
    _controller.resultadoActual.value = null;

    await _analizarImagen(imagen);
  }

  Future<void> _analizarImagen(File imagen) async {
    _controller.cambiarCarga(true);

    try {
      final ResultadoClima resultado = await _servicioIA.analizarImagen(imagen);

      _controller.guardarResultado(resultado);
    } catch (e) {
      Get.snackbar(
        'Error de análisis',
        'No se pudo analizar la imagen: $e',
        backgroundColor: ColoresApp.rojoError,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 18,
      );
    } finally {
      _controller.cambiarCarga(false);
    }
  }

  Color _colorRiesgo(String riesgo) {
    switch (riesgo.toLowerCase()) {
      case 'bajo':
        return ColoresApp.verdeExito;
      case 'medio':
        return ColoresApp.naranjaAlerta;
      case 'alto':
        return ColoresApp.rojoError;
      default:
        return ColoresApp.azulPrincipal;
    }
  }

  @override
  void dispose() {
    _servicioIA.cerrarModelo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondoClaro,
      appBar: AppBar(
        title: const Text('Análisis IA'),
      ),
      body: SafeArea(
        child: Obx(() {
          final File? imagen = _controller.imagenSeleccionada.value;
          final ResultadoClima? resultado = _controller.resultadoActual.value;
          final bool cargando = _controller.cargando.value;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _EncabezadoCamara(),

                const SizedBox(height: 22),

                _AnimacionEntrada(
                  delay: 100,
                  child: _VistaImagen(
                    imagen: imagen,
                    cargando: cargando,
                  ),
                ),

                const SizedBox(height: 18),

                _AnimacionEntrada(
                  delay: 200,
                  child: Row(
                    children: [
                      Expanded(
                        child: _BotonAccionImagen(
                          titulo: 'Cámara',
                          icono: Icons.camera_alt_rounded,
                          principal: true,
                          onTap: cargando ? null : _tomarFoto,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _BotonAccionImagen(
                          titulo: 'Galería',
                          icono: Icons.image_rounded,
                          principal: false,
                          onTap: cargando ? null : _seleccionarDesdeGaleria,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                if (cargando) const _EstadoAnalizando(),

                if (resultado != null && !cargando) ...[
                  _AnimacionEntrada(
                    delay: 300,
                    child: _TarjetaResultadoProfesional(
                      resultado: resultado,
                      colorRiesgo: _colorRiesgo(resultado.nivelRiesgo),
                      onIrCentroIA: widget.onIrCentroIA,
                      onIrReportes: widget.onIrReportes,
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                _AnimacionEntrada(
                  delay: 400,
                  child: const _TarjetaConsejo(),
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
    return const _AnimacionEntrada(
      delay: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Escanea el cielo',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: ColoresApp.grisOscuro,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Selecciona una imagen meteorológica o toma una foto para estimar visualmente la condición del cielo y su nivel de riesgo.',
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: ColoresApp.grisTexto,
            ),
          ),
        ],
      ),
    );
  }
}

class _VistaImagen extends StatelessWidget {
  final File? imagen;
  final bool cargando;

  const _VistaImagen({
    required this.imagen,
    required this.cargando,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: double.infinity,
      height: 290,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.cloud_upload_rounded,
                        color: Colors.white,
                        size: 46,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Esperando imagen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28),
                      child: Text(
                        'Usa la cámara o la galería para iniciar el análisis inteligente.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (imagen != null)
              Positioned(
                left: 16,
                top: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.image_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Imagen cargada',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (cargando)
              Container(
                color: Colors.black.withOpacity(0.45),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BotonAccionImagen extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final bool principal;
  final VoidCallback? onTap;

  const _BotonAccionImagen({
    required this.titulo,
    required this.icono,
    required this.principal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (principal) {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 17),
          decoration: BoxDecoration(
            gradient: ColoresApp.gradienteBoton,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: ColoresApp.azulPrincipal.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icono,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icono),
      label: Text(titulo),
    );
  }
}

class _EstadoAnalizando extends StatelessWidget {
  const _EstadoAnalizando();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Procesando imagen...',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ColoresApp.grisOscuro,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'La inteligencia artificial está evaluando las condiciones visuales del cielo.',
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.5,
              color: ColoresApp.grisTexto,
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaResultadoProfesional extends StatelessWidget {
  final ResultadoClima resultado;
  final Color colorRiesgo;
  final VoidCallback? onIrCentroIA;
  final VoidCallback? onIrReportes;

  const _TarjetaResultadoProfesional({
    required this.resultado,
    required this.colorRiesgo,
    required this.onIrCentroIA,
    required this.onIrReportes,
  });

  @override
  Widget build(BuildContext context) {
    final double confianza = resultado.confianza.clamp(0, 100) / 100;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resultado inteligente',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: ColoresApp.grisOscuro,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: ColoresApp.celesteClaro,
                child: const Icon(
                  Icons.cloud_done_rounded,
                  color: ColoresApp.azulPrincipal,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  resultado.estadoDetectado.replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColoresApp.grisOscuro,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            'Confianza del modelo',
            style: TextStyle(
              color: ColoresApp.grisTexto,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: confianza,
            minHeight: 11,
            borderRadius: BorderRadius.circular(20),
            backgroundColor: ColoresApp.grisClaro,
            color: ColoresApp.azulPrincipal,
          ),
          const SizedBox(height: 8),
          Text(
            '${resultado.confianza.toStringAsFixed(2)}%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: ColoresApp.grisOscuro,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _MiniDatoResultado(
                  titulo: 'Lluvia',
                  valor: '${resultado.probabilidadLluvia.toStringAsFixed(1)}%',
                  icono: Icons.water_drop_rounded,
                  color: ColoresApp.azulSecundario,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniDatoResultado(
                  titulo: 'Tormenta',
                  valor:
                      '${resultado.probabilidadTormenta.toStringAsFixed(1)}%',
                  icono: Icons.thunderstorm_rounded,
                  color: ColoresApp.rojoError,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: colorRiesgo.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorRiesgo.withOpacity(0.35),
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

          const SizedBox(height: 16),

          Text(
            resultado.recomendacion,
            style: const TextStyle(
              height: 1.6,
              color: ColoresApp.grisTexto,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onIrCentroIA,
                  icon: const Icon(Icons.auto_graph_rounded),
                  label: const Text('Centro IA'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onIrReportes,
                  icon: const Icon(Icons.picture_as_pdf_rounded),
                  label: const Text('Reporte'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniDatoResultado extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;
  final Color color;

  const _MiniDatoResultado({
    required this.titulo,
    required this.valor,
    required this.icono,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            icono,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            valor,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: ColoresApp.grisOscuro,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            titulo,
            style: const TextStyle(
              color: ColoresApp.grisTexto,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaConsejo extends StatelessWidget {
  const _TarjetaConsejo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ColoresApp.naranjaSuave,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.info_rounded,
            color: ColoresApp.naranjaAlerta,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Este análisis es una evaluación visual preliminar. Para decisiones reales se deben consultar reportes meteorológicos oficiales.',
              style: TextStyle(
                height: 1.5,
                color: ColoresApp.grisOscuro,
              ),
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