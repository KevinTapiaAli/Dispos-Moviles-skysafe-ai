import 'package:flutter/material.dart';

import '../../utils/colores_app.dart';

class PantallaInformacion extends StatelessWidget {
  const PantallaInformacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondoClaro,
      appBar: AppBar(
        title: const Text('Información del Proyecto'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _EncabezadoInformacion(),
              SizedBox(height: 20),
              _TarjetaInformacion(
                titulo: '¿Qué es SkySafe AI?',
                icono: Icons.flight_takeoff_rounded,
                contenido:
                    'SkySafe AI es una aplicación móvil inteligente que analiza imágenes del cielo mediante inteligencia artificial para clasificar condiciones meteorológicas visuales y estimar un nivel de riesgo operativo.',
              ),
              SizedBox(height: 16),
              _TarjetaInformacion(
                titulo: 'Objetivo del sistema',
                icono: Icons.flag_rounded,
                contenido:
                    'El objetivo principal es apoyar la evaluación preliminar de condiciones visuales para operaciones aeroespaciales y aeronáuticas, como despegues y aterrizajes, especialmente en contextos académicos o demostrativos.',
              ),
              SizedBox(height: 16),
              _TarjetaInformacion(
                titulo: 'Condiciones que puede detectar',
                icono: Icons.cloud_rounded,
                contenido:
                    'La aplicación puede clasificar imágenes en cinco estados meteorológicos: despejado, parcialmente nublado, nublado, lluvia y tormenta.',
              ),
              SizedBox(height: 16),
              _TarjetaInformacion(
                titulo: 'Tecnologías utilizadas',
                icono: Icons.memory_rounded,
                contenido:
                    'El proyecto utiliza Flutter y Dart para la aplicación móvil, TensorFlow Lite para ejecutar el modelo de inteligencia artificial, MobileNetV2 como red neuronal base y Google Colab para el entrenamiento del modelo.',
              ),
              SizedBox(height: 16),
              _TarjetaInformacion(
                titulo: 'Funcionamiento general',
                icono: Icons.settings_suggest_rounded,
                contenido:
                    'El usuario toma una foto o selecciona una imagen. Luego la app procesa la imagen, la envía al modelo IA, obtiene una clasificación, calcula el riesgo y genera una recomendación operativa.',
              ),
              SizedBox(height: 16),
              _TarjetaInformacion(
                titulo: 'Importante',
                icono: Icons.warning_rounded,
                contenido:
                    'SkySafe AI no reemplaza reportes meteorológicos oficiales, radares, estaciones climáticas ni criterios profesionales de seguridad aérea. Su función es apoyar una evaluación visual preliminar con fines académicos.',
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _EncabezadoInformacion extends StatelessWidget {
  const _EncabezadoInformacion();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: ColoresApp.gradientePrincipal,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: ColoresApp.sombraSuave,
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.cloud_done_rounded,
            color: Colors.white,
            size: 48,
          ),
          SizedBox(height: 14),
          Text(
            'SKYSAFE AI',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Sistema Inteligente de Evaluación Meteorológica para Operaciones Aeroespaciales y Aeronáuticas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaInformacion extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final String contenido;

  const _TarjetaInformacion({
    required this.titulo,
    required this.icono,
    required this.contenido,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: ColoresApp.celesteIA.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icono,
                color: ColoresApp.azulPrincipal,
                size: 28,
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
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: ColoresApp.azulOscuro,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    contenido,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: ColoresApp.textoSecundario,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}