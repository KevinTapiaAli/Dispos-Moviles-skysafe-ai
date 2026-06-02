import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../modelos/resultado_clima.dart';

class ServicioIA {
  Interpreter? _interpreter;

  final List<String> _etiquetas = [
    'despejado',
    'lluvia',
    'nublado',
    'parcialmente_nublado',
    'tormenta',
  ];

  Future<void> _cargarModelo() async {
    if (_interpreter != null) return;

    _interpreter = await Interpreter.fromAsset(
      'lib/ia/modelo_skysafe.tflite',
    );

    print('Modelo IA cargado correctamente');
    print('Input shape: ${_interpreter!.getInputTensor(0).shape}');
    print('Output shape: ${_interpreter!.getOutputTensor(0).shape}');
  }

  Future<ResultadoClima> analizarImagen(File imagenFile) async {
    await _cargarModelo();

    final bytes = await imagenFile.readAsBytes();
    final imagenOriginal = img.decodeImage(bytes);

    if (imagenOriginal == null) {
      throw Exception('No se pudo leer la imagen seleccionada.');
    }

    final imagenRedimensionada = img.copyResize(
      imagenOriginal,
      width: 224,
      height: 224,
    );

    final input = List.generate(
      1,
      (_) => List.generate(
        224,
        (y) => List.generate(
          224,
          (x) {
            final pixel = imagenRedimensionada.getPixel(x, y);

            return [
              pixel.r.toDouble(),
              pixel.g.toDouble(),
              pixel.b.toDouble(),
            ];
          },
        ),
      ),
    );

    final output = List.generate(
      1,
      (_) => List.filled(_etiquetas.length, 0.0),
    );

    _interpreter!.run(input, output);

    final List<double> predicciones = output[0].map((e) {
      return (e as num).toDouble();
    }).toList();

    print('Predicciones completas:');
    for (int i = 0; i < _etiquetas.length; i++) {
      print('${_etiquetas[i]}: ${(predicciones[i] * 100).toStringAsFixed(2)}%');
    }

    int indiceMayor = 0;
    double valorMayor = predicciones[0];

    for (int i = 1; i < predicciones.length; i++) {
      if (predicciones[i] > valorMayor) {
        valorMayor = predicciones[i];
        indiceMayor = i;
      }
    }

    final String estadoDetectado = _etiquetas[indiceMayor];
    final double confianza = valorMayor * 100;

    final double probabilidadLluvia =
        predicciones[_etiquetas.indexOf('lluvia')] * 100;

    final double probabilidadTormenta =
        predicciones[_etiquetas.indexOf('tormenta')] * 100;

    final String nivelRiesgo = _calcularRiesgo(
      estadoDetectado,
      probabilidadLluvia,
      probabilidadTormenta,
    );

    final String recomendacion = _generarRecomendacion(
      estadoDetectado,
      nivelRiesgo,
    );

    return ResultadoClima(
      estadoDetectado: estadoDetectado,
      confianza: confianza,
      probabilidadLluvia: probabilidadLluvia,
      probabilidadTormenta: probabilidadTormenta,
      nivelRiesgo: nivelRiesgo,
      recomendacion: recomendacion,
      rutaImagen: imagenFile.path,
      fechaAnalisis: DateTime.now(),
    );
  }

  String _calcularRiesgo(
    String estado,
    double lluvia,
    double tormenta,
  ) {
    final estadoNormalizado = estado.toLowerCase();

    if (estadoNormalizado == 'tormenta' || tormenta >= 45) {
      return 'Alto';
    }

    if (estadoNormalizado == 'lluvia' || lluvia >= 40) {
      return 'Medio';
    }

    if (estadoNormalizado == 'nublado') {
      return 'Medio';
    }

    return 'Bajo';
  }

  String _generarRecomendacion(
    String estado,
    String riesgo,
  ) {
    final estadoNormalizado = estado.toLowerCase();

    if (riesgo == 'Alto') {
      return 'No se recomienda realizar operaciones de despegue o aterrizaje. Las condiciones visuales pueden representar un riesgo elevado y se debe consultar información meteorológica oficial.';
    }

    if (riesgo == 'Medio') {
      return 'Se recomienda operar con precaución. Es necesario complementar este análisis con reportes meteorológicos oficiales antes de tomar una decisión.';
    }

    if (estadoNormalizado == 'despejado') {
      return 'Las condiciones visuales parecen favorables. Aun así, se recomienda verificar reportes meteorológicos oficiales antes de realizar una operación aérea.';
    }

    if (estadoNormalizado == 'parcialmente_nublado') {
      return 'Las condiciones visuales son aceptables, pero se recomienda revisar la evolución de la nubosidad antes de una operación aérea.';
    }

    return 'El análisis fue completado. Se recomienda complementar el resultado con información meteorológica oficial.';
  }

  void cerrarModelo() {
    _interpreter?.close();
    _interpreter = null;
  }
}