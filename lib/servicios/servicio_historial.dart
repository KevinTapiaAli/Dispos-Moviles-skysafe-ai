import '../modelos/resultado_clima.dart';

class ServicioHistorial {
  static final ServicioHistorial _instancia = ServicioHistorial._interno();

  factory ServicioHistorial() {
    return _instancia;
  }

  ServicioHistorial._interno();

  final List<ResultadoClima> _historial = [];

  List<ResultadoClima> obtenerHistorial() {
    return List.unmodifiable(_historial);
  }

  void agregarResultado(ResultadoClima resultado) {
    _historial.add(resultado);
  }

  void limpiarHistorial() {
    _historial.clear();
  }

  int obtenerTotalAnalisis() {
    return _historial.length;
  }

  int contarPorRiesgo(String riesgo) {
    return _historial.where((resultado) {
      return resultado.nivelRiesgo.toLowerCase() == riesgo.toLowerCase();
    }).length;
  }

  int contarPorEstado(String estado) {
    return _historial.where((resultado) {
      return resultado.estadoDetectado.toLowerCase() == estado.toLowerCase();
    }).length;
  }

  double obtenerPromedioConfianza() {
    if (_historial.isEmpty) {
      return 0.0;
    }

    final double suma = _historial.fold(
      0.0,
      (total, resultado) => total + resultado.confianza,
    );

    return suma / _historial.length;
  }
}