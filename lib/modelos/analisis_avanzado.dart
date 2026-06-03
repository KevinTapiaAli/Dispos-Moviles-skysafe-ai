class AnalisisAvanzado {
  final String estadoVisual;
  final double confianzaGemini;
  final String nivelRiesgo;
  final double probabilidadLluvia;
  final double probabilidadTormenta;
  final String explicacion;
  final String recomendacion;
  final String observacionReporte;
  final bool requiereRevision;
  final String fuente;

  const AnalisisAvanzado({
    required this.estadoVisual,
    required this.confianzaGemini,
    required this.nivelRiesgo,
    required this.probabilidadLluvia,
    required this.probabilidadTormenta,
    required this.explicacion,
    required this.recomendacion,
    required this.observacionReporte,
    required this.requiereRevision,
    this.fuente = 'Gemini API',
  });

  factory AnalisisAvanzado.fromJson(Map<String, dynamic> json) {
    return AnalisisAvanzado(
      estadoVisual: _texto(json['estado_visual'], 'No determinado'),
      confianzaGemini: _numero(json['confianza_gemini'], 0),
      nivelRiesgo: _texto(json['nivel_riesgo'], 'Medio'),
      probabilidadLluvia: _numero(json['probabilidad_lluvia'], 0),
      probabilidadTormenta: _numero(json['probabilidad_tormenta'], 0),
      explicacion: _texto(
        json['explicacion'],
        'No se pudo generar una explicación avanzada.',
      ),
      recomendacion: _texto(
        json['recomendacion'],
        'Se recomienda complementar el análisis con información meteorológica oficial.',
      ),
      observacionReporte: _texto(
        json['observacion_reporte'],
        'Análisis visual complementario generado con IA.',
      ),
      requiereRevision: _booleano(json['requiere_revision'], true),
      fuente: _texto(json['fuente'], 'Gemini API'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estado_visual': estadoVisual,
      'confianza_gemini': confianzaGemini,
      'nivel_riesgo': nivelRiesgo,
      'probabilidad_lluvia': probabilidadLluvia,
      'probabilidad_tormenta': probabilidadTormenta,
      'explicacion': explicacion,
      'recomendacion': recomendacion,
      'observacion_reporte': observacionReporte,
      'requiere_revision': requiereRevision,
      'fuente': fuente,
    };
  }

  static String _texto(dynamic valor, String defecto) {
    if (valor == null) return defecto;

    final texto = valor.toString().trim();

    if (texto.isEmpty) {
      return defecto;
    }

    return texto;
  }

  static double _numero(dynamic valor, double defecto) {
    if (valor == null) return defecto;

    if (valor is num) {
      return valor.toDouble().clamp(0, 100);
    }

    final convertido = double.tryParse(valor.toString());

    if (convertido == null) {
      return defecto;
    }

    return convertido.clamp(0, 100);
  }

  static bool _booleano(dynamic valor, bool defecto) {
    if (valor == null) return defecto;

    if (valor is bool) {
      return valor;
    }

    final texto = valor.toString().toLowerCase().trim();

    if (texto == 'true' || texto == 'verdadero' || texto == 'si') {
      return true;
    }

    if (texto == 'false' || texto == 'falso' || texto == 'no') {
      return false;
    }

    return defecto;
  }
}