/*Nombre del proyecto: SkySafe AI
Fecha del análisis
Estado detectado
Confianza del modelo
Probabilidad de lluvia
Probabilidad de tormenta
Nivel de riesgo
Recomendación operativa
Imagen analizada
Conclusión del análisis


PDF: para imprimir o presentar
Word: para editar o entregar como documento*/

import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../modelos/resultado_clima.dart';

class ServicioReportes {
  Future<void> generarReportePDF({
    required ResultadoClima resultado,
    File? imagen,
  }) async {
    final pdf = pw.Document();

    Uint8List? imagenBytes;

    if (imagen != null && await imagen.exists()) {
      imagenBytes = await imagen.readAsBytes();
    }

    final String fecha = DateFormat('dd/MM/yyyy HH:mm').format(
      resultado.fechaAnalisis,
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _encabezadoPDF(),
            pw.SizedBox(height: 24),

            pw.Text(
              'Reporte de Análisis Meteorológico Visual',
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 10),

            pw.Text(
              'Fecha del análisis: $fecha',
              style: const pw.TextStyle(
                fontSize: 12,
              ),
            ),

            pw.SizedBox(height: 18),

            if (imagenBytes != null) _imagenPDF(imagenBytes),

            if (imagenBytes != null) pw.SizedBox(height: 22),

            _datosResultadoPDF(resultado),

            pw.SizedBox(height: 22),

            _recomendacionPDF(resultado),

            pw.SizedBox(height: 24),

            _notaPDF(),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _encabezadoPDF() {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(18),
      decoration: pw.BoxDecoration(
        color: PdfColors.blueGrey900,
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'SKYSAFE AI',
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 26,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            'Sistema Inteligente de Evaluación Meteorológica para Operaciones Aeroespaciales y Aeronáuticas',
            style: const pw.TextStyle(
              color: PdfColors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _imagenPDF(Uint8List imagenBytes) {
    return pw.Container(
      height: 190,
      width: double.infinity,
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(
          color: PdfColors.grey400,
        ),
      ),
      child: pw.Image(
        pw.MemoryImage(imagenBytes),
        fit: pw.BoxFit.cover,
      ),
    );
  }

  pw.Widget _datosResultadoPDF(ResultadoClima resultado) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(
          color: PdfColors.grey300,
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _datoPDF(
            'Estado detectado',
            resultado.estadoDetectado.replaceAll('_', ' ').toUpperCase(),
          ),
          _datoPDF(
            'Confianza del modelo',
            '${resultado.confianza.toStringAsFixed(2)}%',
          ),
          _datoPDF(
            'Probabilidad de lluvia',
            '${resultado.probabilidadLluvia.toStringAsFixed(2)}%',
          ),
          _datoPDF(
            'Probabilidad de tormenta',
            '${resultado.probabilidadTormenta.toStringAsFixed(2)}%',
          ),
          _datoPDF(
            'Nivel de riesgo',
            resultado.nivelRiesgo.toUpperCase(),
          ),
        ],
      ),
    );
  }

  pw.Widget _datoPDF(String titulo, String valor) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 9),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              '$titulo:',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Text(
              valor,
              style: const pw.TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _recomendacionPDF(ResultadoClima resultado) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Recomendación operativa',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(14),
          decoration: pw.BoxDecoration(
            color: PdfColors.blueGrey50,
            borderRadius: pw.BorderRadius.circular(10),
          ),
          child: pw.Text(
            resultado.recomendacion,
            style: const pw.TextStyle(
              fontSize: 12,
              lineSpacing: 4,
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _notaPDF() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Nota importante',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          'Este reporte fue generado automáticamente por SkySafe AI. La aplicación no reemplaza reportes meteorológicos oficiales, radares, estaciones climáticas ni criterios profesionales de seguridad aérea. Su uso está orientado a evaluación visual preliminar y fines académicos.',
          style: const pw.TextStyle(
            fontSize: 11,
            lineSpacing: 4,
          ),
        ),
      ],
    );
  }
}