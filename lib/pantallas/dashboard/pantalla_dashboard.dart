import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/rutas_app.dart';
import '../../controllers/analisis_controller.dart';
import '../../modelos/resultado_clima.dart';
import '../../utils/colores_app.dart';

class PantallaDashboard extends StatelessWidget {
  const PantallaDashboard({super.key});

  Color _colorRiesgo(String riesgo) {
    switch (riesgo.toLowerCase()) {
      case 'bajo':
        return ColoresApp.riesgoBajo;
      case 'medio':
        return ColoresApp.riesgoMedio;
      case 'alto':
        return ColoresApp.riesgoAlto;
      default:
        return ColoresApp.azulPrincipal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AnalisisController controller = Get.find<AnalisisController>();

    return Scaffold(
      backgroundColor: ColoresApp.fondoClaro,
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SafeArea(
        child: Obx(() {
          final ResultadoClima? resultado = controller.resultadoActual.value;

          if (resultado == null) {
            return const _DashboardVacio();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Indicadores visuales',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: ColoresApp.azulOscuro,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Resumen gráfico del análisis meteorológico realizado por SkySafe AI.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: ColoresApp.textoSecundario,
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: _TarjetaIndicador(
                        titulo: 'Confianza',
                        valor: '${resultado.confianza.toStringAsFixed(1)}%',
                        icono: Icons.verified_rounded,
                        color: ColoresApp.azulPrincipal,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TarjetaIndicador(
                        titulo: 'Riesgo',
                        valor: resultado.nivelRiesgo,
                        icono: Icons.warning_rounded,
                        color: _colorRiesgo(resultado.nivelRiesgo),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: _TarjetaIndicador(
                        titulo: 'Lluvia',
                        valor:
                            '${resultado.probabilidadLluvia.toStringAsFixed(1)}%',
                        icono: Icons.water_drop_rounded,
                        color: ColoresApp.azulMedio,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TarjetaIndicador(
                        titulo: 'Tormenta',
                        valor:
                            '${resultado.probabilidadTormenta.toStringAsFixed(1)}%',
                        icono: Icons.thunderstorm_rounded,
                        color: ColoresApp.riesgoAlto,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: _TarjetaIndicador(
                        titulo: 'Análisis',
                        valor: '${controller.totalAnalisis}',
                        icono: Icons.analytics_rounded,
                        color: ColoresApp.azulPrincipal,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TarjetaIndicador(
                        titulo: 'Promedio',
                        valor:
                            '${controller.promedioConfianza.toStringAsFixed(1)}%',
                        icono: Icons.speed_rounded,
                        color: ColoresApp.azulMedio,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _TarjetaEstado(
                  resultado: resultado,
                ),

                const SizedBox(height: 18),

                _TarjetaBarras(resultado: resultado),

                const SizedBox(height: 18),

                _TarjetaResumenOperativo(
                  resultado: resultado,
                  colorRiesgo: _colorRiesgo(resultado.nivelRiesgo),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _DashboardVacio extends StatelessWidget {
  const _DashboardVacio();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.dashboard_rounded,
              size: 82,
              color: ColoresApp.azulPrincipal,
            ),
            const SizedBox(height: 18),
            const Text(
              'Dashboard sin datos',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: ColoresApp.azulOscuro,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Primero realiza un análisis de imagen para generar indicadores visuales.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: ColoresApp.textoSecundario,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Get.toNamed(RutasApp.camaraIA);
              },
              icon: const Icon(Icons.camera_alt_rounded),
              label: const Text('Realizar análisis'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaIndicador extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;
  final Color color;

  const _TarjetaIndicador({
    required this.titulo,
    required this.valor,
    required this.icono,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: ColoresApp.sombraSuave,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icono,
                color: color,
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 13,
                color: ColoresApp.textoSecundario,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              valor,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaEstado extends StatelessWidget {
  final ResultadoClima resultado;

  const _TarjetaEstado({
    required this.resultado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: ColoresApp.gradientePrincipal,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: ColoresApp.sombraSuave,
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.airplanemode_active_rounded,
            color: Colors.white,
            size: 42,
          ),
          const SizedBox(height: 12),
          const Text(
            'Estado meteorológico detectado',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            resultado.estadoDetectado.replaceAll('_', ' ').toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.30),
              ),
            ),
            child: Text(
              'Nivel de riesgo: ${resultado.nivelRiesgo}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaBarras extends StatelessWidget {
  final ResultadoClima resultado;

  const _TarjetaBarras({
    required this.resultado,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: ColoresApp.sombraSuave,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mediciones principales',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: ColoresApp.azulOscuro,
              ),
            ),
            const SizedBox(height: 18),
            _BarraDashboard(
              titulo: 'Confianza del modelo',
              porcentaje: resultado.confianza,
              color: ColoresApp.azulPrincipal,
            ),
            _BarraDashboard(
              titulo: 'Probabilidad de lluvia',
              porcentaje: resultado.probabilidadLluvia,
              color: ColoresApp.azulMedio,
            ),
            _BarraDashboard(
              titulo: 'Probabilidad de tormenta',
              porcentaje: resultado.probabilidadTormenta,
              color: ColoresApp.riesgoAlto,
            ),
          ],
        ),
      ),
    );
  }
}

class _BarraDashboard extends StatelessWidget {
  final String titulo;
  final double porcentaje;
  final Color color;

  const _BarraDashboard({
    required this.titulo,
    required this.porcentaje,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double valor = porcentaje.clamp(0, 100) / 100;

    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoPrincipal,
                  ),
                ),
              ),
              Text(
                '${porcentaje.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColoresApp.azulOscuro,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: valor,
            minHeight: 10,
            borderRadius: BorderRadius.circular(20),
            backgroundColor: color.withOpacity(0.13),
            color: color,
          ),
        ],
      ),
    );
  }
}

class _TarjetaResumenOperativo extends StatelessWidget {
  final ResultadoClima resultado;
  final Color colorRiesgo;

  const _TarjetaResumenOperativo({
    required this.resultado,
    required this.colorRiesgo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: ColoresApp.sombraSuave,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen operativo',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: ColoresApp.azulOscuro,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: colorRiesgo.withOpacity(0.10),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: colorRiesgo.withOpacity(0.35),
                ),
              ),
              child: Text(
                resultado.recomendacion,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: ColoresApp.textoPrincipal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}