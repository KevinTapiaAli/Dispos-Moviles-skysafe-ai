class Constantes {
  static const String nombreApp = 'SkySafe AI';

  static const String nombreCompletoApp =
      'Sistema Inteligente de Evaluación Meteorológica para Operaciones Aeroespaciales y Aeronáuticas';

  static const String rutaModelo = 'lib/ia/modelo_skysafe.tflite';

  static const String rutaEtiquetas = 'lib/ia/etiquetas.txt';

  static const int anchoImagenModelo = 224;

  static const int altoImagenModelo = 224;

  static const List<String> clasesClima = [
    'despejado',
    'lluvia',
    'nublado',
    'parcialmente_nublado',
    'tormenta',
  ];

  static const String mensajeUsoAcademico =
      'SkySafe AI no reemplaza reportes meteorológicos oficiales, radares, estaciones climáticas ni criterios profesionales de seguridad aérea. Su uso está orientado a evaluación visual preliminar y fines académicos.';

  static const String recomendacionRiesgoBajo =
      'Las condiciones visuales parecen favorables. Se recomienda complementar el análisis con reportes meteorológicos oficiales antes de realizar una operación aérea.';

  static const String recomendacionRiesgoMedio =
      'Se recomienda operar con precaución. Es importante verificar visibilidad, viento, nubosidad y reportes meteorológicos antes del despegue o aterrizaje.';

  static const String recomendacionRiesgoAlto =
      'No se recomienda realizar operaciones de despegue o aterrizaje bajo estas condiciones visuales. Se requiere una evaluación meteorológica más detallada.';
}