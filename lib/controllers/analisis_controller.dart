import 'dart:io';

import 'package:get/get.dart';

import '../modelos/analisis_avanzado.dart';
import '../modelos/resultado_clima.dart';

class AnalisisController extends GetxController {
  final RxBool cargando = false.obs;
  final RxBool cargandoAvanzado = false.obs;

  final Rxn<File> imagenSeleccionada = Rxn<File>();
  final Rxn<ResultadoClima> resultadoActual = Rxn<ResultadoClima>();
  final Rxn<AnalisisAvanzado> analisisAvanzado = Rxn<AnalisisAvanzado>();

  final RxList<ResultadoClima> historial = <ResultadoClima>[].obs;

  void cambiarCarga(bool valor) {
    cargando.value = valor;
  }

  void cambiarCargaAvanzada(bool valor) {
    cargandoAvanzado.value = valor;
  }

  void guardarImagen(File imagen) {
    imagenSeleccionada.value = imagen;
  }

  void guardarResultado(ResultadoClima resultado) {
    resultadoActual.value = resultado;

    historial.insert(0, resultado);

    if (historial.length > 20) {
      historial.removeLast();
    }
  }

  void guardarAnalisisAvanzado(AnalisisAvanzado analisis) {
    analisisAvanzado.value = analisis;
  }

  void limpiarAnalisis() {
    imagenSeleccionada.value = null;
    resultadoActual.value = null;
    analisisAvanzado.value = null;
    cargando.value = false;
    cargandoAvanzado.value = false;
  }

  void limpiarHistorial() {
    historial.clear();
  }

  int get totalAnalisis {
    return historial.length;
  }

  int contarPorRiesgo(String riesgo) {
    return historial.where((resultado) {
      return resultado.nivelRiesgo.toLowerCase() == riesgo.toLowerCase();
    }).length;
  }

  int contarPorEstado(String estado) {
    return historial.where((resultado) {
      return resultado.estadoDetectado.toLowerCase() == estado.toLowerCase();
    }).length;
  }

  double get promedioConfianza {
    if (historial.isEmpty) {
      return 0.0;
    }

    final double suma = historial.fold(
      0.0,
      (total, resultado) => total + resultado.confianza,
    );

    return suma / historial.length;
  }
}