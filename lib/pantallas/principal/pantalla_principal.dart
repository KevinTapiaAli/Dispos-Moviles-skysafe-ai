import 'package:flutter/material.dart';

import '../../widgets/barra_navegacion_principal.dart';
import '../camara_ia/pantalla_camara_ia.dart';
import '../centro_ia/pantalla_centro_ia.dart';
import '../informacion/pantalla_informacion.dart';
import '../inicio/pantalla_inicio.dart';
import '../reportes/pantalla_reportes.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int indiceActual = 0;

  void cambiarPagina(int indice) {
    setState(() {
      indiceActual = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> paginas = [
      PantallaInicio(
        onIrCamara: () => cambiarPagina(2),
        onIrCentroIA: () => cambiarPagina(1),
        onIrReportes: () => cambiarPagina(3),
      ),
      const PantallaCentroIA(),
      PantallaCamaraIA(
        onIrCentroIA: () => cambiarPagina(1),
        onIrReportes: () => cambiarPagina(3),
      ),
      const PantallaReportes(),
      const PantallaInformacion(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: IndexedStack(
          key: ValueKey(indiceActual),
          index: indiceActual,
          children: paginas,
        ),
      ),
      bottomNavigationBar: BarraNavegacionPrincipal(
        indiceActual: indiceActual,
        onTap: cambiarPagina,
      ),
    );
  }
}