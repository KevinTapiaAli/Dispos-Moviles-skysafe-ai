import 'dart:io';

import 'package:flutter/material.dart';

import '../modelos/resultado_clima.dart';

class AnalisisProvider extends ChangeNotifier {
  bool cargando = false;

  File? imagenSeleccionada;
  ResultadoClima? resultadoActual;

  void cambiarCarga(bool valor) {
    cargando = valor;
    notifyListeners();
  }

  void guardarImagen(File imagen) {
    imagenSeleccionada = imagen;
    notifyListeners();
  }

  void guardarResultado(ResultadoClima resultado) {
    resultadoActual = resultado;
    notifyListeners();
  }

  void limpiarAnalisis() {
    imagenSeleccionada = null;
    resultadoActual = null;
    cargando = false;
    notifyListeners();
  }
}