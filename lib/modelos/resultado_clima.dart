class ResultadoClima {
  final String estadoDetectado;
  final double confianza;
  final double probabilidadLluvia;
  final double probabilidadTormenta;
  final String nivelRiesgo;
  final String recomendacion;
  final DateTime fechaAnalisis;
  final String? rutaImagen;

  ResultadoClima({
    required this.estadoDetectado,
    required this.confianza,
    required this.probabilidadLluvia,
    required this.probabilidadTormenta,
    required this.nivelRiesgo,
    required this.recomendacion,
    required this.fechaAnalisis,
    this.rutaImagen,
  });

  Map<String, dynamic> toMap() {
    return {
      'estadoDetectado': estadoDetectado,
      'confianza': confianza,
      'probabilidadLluvia': probabilidadLluvia,
      'probabilidadTormenta': probabilidadTormenta,
      'nivelRiesgo': nivelRiesgo,
      'recomendacion': recomendacion,
      'fechaAnalisis': fechaAnalisis.toIso8601String(),
      'rutaImagen': rutaImagen,
    };
  }

  factory ResultadoClima.fromMap(Map<String, dynamic> map) {
    return ResultadoClima(
      estadoDetectado: map['estadoDetectado'] ?? '',
      confianza: (map['confianza'] ?? 0).toDouble(),
      probabilidadLluvia: (map['probabilidadLluvia'] ?? 0).toDouble(),
      probabilidadTormenta: (map['probabilidadTormenta'] ?? 0).toDouble(),
      nivelRiesgo: map['nivelRiesgo'] ?? '',
      recomendacion: map['recomendacion'] ?? '',
      fechaAnalisis: DateTime.tryParse(map['fechaAnalisis'] ?? '') ?? DateTime.now(),
      rutaImagen: map['rutaImagen'],
    );
  }
}