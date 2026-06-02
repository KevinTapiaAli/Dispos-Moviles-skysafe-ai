class AnalisisMeteorologico {
  final int? id;
  final String estadoDetectado;
  final double confianza;
  final double probabilidadLluvia;
  final double probabilidadTormenta;
  final String nivelRiesgo;
  final String recomendacion;
  final String? rutaImagen;
  final DateTime fechaAnalisis;

  AnalisisMeteorologico({
    this.id,
    required this.estadoDetectado,
    required this.confianza,
    required this.probabilidadLluvia,
    required this.probabilidadTormenta,
    required this.nivelRiesgo,
    required this.recomendacion,
    this.rutaImagen,
    required this.fechaAnalisis,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'estadoDetectado': estadoDetectado,
      'confianza': confianza,
      'probabilidadLluvia': probabilidadLluvia,
      'probabilidadTormenta': probabilidadTormenta,
      'nivelRiesgo': nivelRiesgo,
      'recomendacion': recomendacion,
      'rutaImagen': rutaImagen,
      'fechaAnalisis': fechaAnalisis.toIso8601String(),
    };
  }

  factory AnalisisMeteorologico.fromMap(Map<String, dynamic> map) {
    return AnalisisMeteorologico(
      id: map['id'],
      estadoDetectado: map['estadoDetectado'] ?? '',
      confianza: (map['confianza'] ?? 0).toDouble(),
      probabilidadLluvia: (map['probabilidadLluvia'] ?? 0).toDouble(),
      probabilidadTormenta: (map['probabilidadTormenta'] ?? 0).toDouble(),
      nivelRiesgo: map['nivelRiesgo'] ?? '',
      recomendacion: map['recomendacion'] ?? '',
      rutaImagen: map['rutaImagen'],
      fechaAnalisis: DateTime.tryParse(map['fechaAnalisis'] ?? '') ??
          DateTime.now(),
    );
  }
}