import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../modelos/analisis_avanzado.dart';
import '../modelos/resultado_clima.dart';

class ServicioGemini {
  static const String _modelo = 'gemini-1.5-flash';

  String get _apiKey {
    final String? key = dotenv.env['GEMINI_API_KEY'];

    if (key == null || key.trim().isEmpty) {
      throw Exception(
        'No se encontró GEMINI_API_KEY. Revisa el archivo .env.',
      );
    }

    return key.trim();
  }

  Future<AnalisisAvanzado> analizarImagenAvanzada({
    required File imagen,
    required ResultadoClima resultadoLocal,
  }) async {
    final List<int> bytes = await imagen.readAsBytes();
    final String imagenBase64 = base64Encode(bytes);
    final String mimeType = _obtenerMimeType(imagen.path);

    final Uri url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$_modelo:generateContent',
    );

    final Map<String, dynamic> body = {
      'contents': [
        {
          'parts': [
            {
              'inline_data': {
                'mime_type': mimeType,
                'data': imagenBase64,
              },
            },
            {
              'text': _crearPrompt(resultadoLocal),
            },
          ],
        },
      ],
      'generationConfig': {
        'temperature': 0.2,
        'topP': 0.8,
        'topK': 40,
        'maxOutputTokens': 1000,
        'responseMimeType': 'application/json',
      },
    };

    debugPrint('========== GEMINI REQUEST ==========');
    debugPrint('Modelo usado: $_modelo');
    debugPrint('MimeType: $mimeType');
    debugPrint('Imagen bytes: ${bytes.length}');
    debugPrint('API Key cargada: ${_apiKey.isNotEmpty}');
    debugPrint('====================================');

    final http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': _apiKey,
      },
      body: jsonEncode(body),
    );

    debugPrint('========== GEMINI RESPONSE ==========');
    debugPrint('Status code: ${response.statusCode}');
    debugPrint('Body: ${response.body}');
    debugPrint('=====================================');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Error Gemini ${response.statusCode}: ${response.body}',
      );
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    final dynamic textoRespuesta =
        data['candidates']?[0]?['content']?['parts']?[0]?['text'];

    if (textoRespuesta == null || textoRespuesta.toString().trim().isEmpty) {
      throw Exception(
        'Gemini no devolvió texto válido. Respuesta: ${response.body}',
      );
    }

    final String jsonLimpio = _limpiarJson(textoRespuesta.toString());
    final Map<String, dynamic> jsonRespuesta = jsonDecode(jsonLimpio);

    return AnalisisAvanzado.fromJson(jsonRespuesta);
  }

  String _crearPrompt(ResultadoClima resultadoLocal) {
    return '''
Eres un asistente experto en análisis visual meteorológico para una app llamada CieloSeguro IA.

La aplicación ya realizó un análisis local con TensorFlow Lite. Tu tarea es analizar visualmente la imagen como segunda opinión y complementar el resultado.

Resultado local:
- Estado detectado: ${resultadoLocal.estadoDetectado}
- Confianza local: ${resultadoLocal.confianza.toStringAsFixed(2)}%
- Probabilidad de lluvia local: ${resultadoLocal.probabilidadLluvia.toStringAsFixed(2)}%
- Probabilidad de tormenta local: ${resultadoLocal.probabilidadTormenta.toStringAsFixed(2)}%
- Nivel de riesgo local: ${resultadoLocal.nivelRiesgo}
- Recomendación local: ${resultadoLocal.recomendacion}

Analiza únicamente lo visible en la imagen.
No inventes datos externos.
No uses pronósticos reales.
No digas que es un reporte oficial.

Responde únicamente en JSON válido, sin markdown y sin texto adicional.

Formato obligatorio:
{
  "estado_visual": "despejado | parcialmente_nublado | nublado | lluvia | tormenta",
  "confianza_gemini": 0,
  "nivel_riesgo": "Bajo | Medio | Alto",
  "probabilidad_lluvia": 0,
  "probabilidad_tormenta": 0,
  "explicacion": "explicación clara y humana para el usuario",
  "recomendacion": "recomendación operativa concreta",
  "observacion_reporte": "texto profesional para incluir en un reporte académico o técnico",
  "requiere_revision": false,
  "fuente": "Gemini API"
}
''';
  }

  String _obtenerMimeType(String ruta) {
    final String lower = ruta.toLowerCase();

    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
      return 'image/jpeg';
    }

    return 'image/jpeg';
  }

  String _limpiarJson(String texto) {
    String limpio = texto.trim();

    if (limpio.startsWith('```json')) {
      limpio = limpio.replaceFirst('```json', '').trim();
    }

    if (limpio.startsWith('```')) {
      limpio = limpio.replaceFirst('```', '').trim();
    }

    if (limpio.endsWith('```')) {
      limpio = limpio.substring(0, limpio.length - 3).trim();
    }

    final int inicio = limpio.indexOf('{');
    final int fin = limpio.lastIndexOf('}');

    if (inicio != -1 && fin != -1 && fin > inicio) {
      limpio = limpio.substring(inicio, fin + 1);
    }

    return limpio;
  }
}