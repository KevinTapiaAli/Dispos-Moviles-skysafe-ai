import '../modelos/analisis_avanzado.dart';
import '../modelos/resultado_clima.dart';

class ServicioAnalisisRespaldo {
  AnalisisAvanzado generarDesdeResultadoLocal(ResultadoClima resultado) {
    final estado = resultado.estadoDetectado.toLowerCase();
    final lluvia = resultado.probabilidadLluvia;
    final tormenta = resultado.probabilidadTormenta;
    final confianza = resultado.confianza;

    String riesgo = resultado.nivelRiesgo;
    String explicacion;
    String recomendacion;
    String observacionReporte;
    bool requiereRevision = false;

    if (confianza < 55) {
      requiereRevision = true;
    }

    if (estado.contains('lluvia') || lluvia >= 60) {
      riesgo = 'Medio';
      explicacion =
          'La imagen presenta características asociadas a lluvia o humedad visible. El modelo local detectó una probabilidad elevada de lluvia, por lo que se recomienda interpretar el resultado con precaución.';
      recomendacion =
          'Evitar operaciones sensibles al clima y complementar la decisión con información meteorológica oficial antes de continuar.';
      observacionReporte =
          'El análisis local identifica condiciones compatibles con lluvia. Se recomienda validar el resultado con fuentes meteorológicas oficiales debido a que la evaluación se basa únicamente en características visuales.';
    } else if (estado.contains('tormenta') || tormenta >= 45) {
      riesgo = 'Alto';
      explicacion =
          'La imagen muestra señales que pueden asociarse a inestabilidad atmosférica. La probabilidad de tormenta o nubosidad intensa requiere atención operativa.';
      recomendacion =
          'Suspender o postergar operaciones aéreas no esenciales hasta contar con una verificación meteorológica confiable.';
      observacionReporte =
          'El sistema detecta indicadores visuales relacionados con posible tormenta o condiciones inestables. Se recomienda realizar una verificación complementaria antes de tomar decisiones.';
    } else if (estado.contains('nublado') || estado.contains('parcialmente')) {
      riesgo = confianza >= 70 ? 'Bajo' : 'Medio';
      explicacion =
          'La imagen presenta nubosidad parcial o moderada. Aunque no necesariamente representa una condición crítica, puede afectar la visibilidad o cambiar con rapidez.';
      recomendacion =
          'Operar con precaución y revisar la evolución de la nubosidad antes de realizar una operación aérea.';
      observacionReporte =
          'El análisis visual identifica presencia de nubosidad. Las condiciones parecen manejables, pero se recomienda monitoreo adicional por tratarse de una evaluación preliminar.';
    } else {
      riesgo = 'Bajo';
      explicacion =
          'La imagen presenta condiciones visuales favorables, con baja probabilidad de lluvia o tormenta según el modelo local.';
      recomendacion =
          'Las condiciones visuales parecen aceptables. Aun así, se recomienda verificar reportes meteorológicos oficiales antes de una operación aérea.';
      observacionReporte =
          'El sistema identifica condiciones visuales favorables. El resultado debe considerarse como apoyo preliminar y no como pronóstico meteorológico oficial.';
    }

    return AnalisisAvanzado(
      estadoVisual: resultado.estadoDetectado,
      confianzaGemini: confianza,
      nivelRiesgo: riesgo,
      probabilidadLluvia: lluvia,
      probabilidadTormenta: tormenta,
      explicacion: explicacion,
      recomendacion: recomendacion,
      observacionReporte: observacionReporte,
      requiereRevision: requiereRevision,
      fuente: 'Análisis avanzado local',
    );
  }
}