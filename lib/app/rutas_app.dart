import 'package:get/get.dart';

import '../pantallas/bienvenida/pantalla_bienvenida.dart';
import '../pantallas/principal/pantalla_principal.dart';

// Rutas antiguas para compatibilidad
import '../pantallas/inicio/pantalla_inicio.dart';
import '../pantallas/camara_ia/pantalla_camara_ia.dart';
import '../pantallas/centro_ia/pantalla_centro_ia.dart';
import '../pantallas/resultado/pantalla_resultado.dart';
import '../pantallas/historial/pantalla_historial.dart';
import '../pantallas/dashboard/pantalla_dashboard.dart';
import '../pantallas/reportes/pantalla_reportes.dart';
import '../pantallas/informacion/pantalla_informacion.dart';

class RutasApp {
  static const String bienvenida = '/';
  static const String principal = '/principal';

  // Rutas antiguas para que no fallen archivos anteriores
  static const String inicio = '/inicio';
  static const String camaraIA = '/camara-ia';
  static const String centroIA = '/centro-ia';
  static const String resultado = '/resultado';
  static const String historial = '/historial';
  static const String dashboard = '/dashboard';
  static const String reportes = '/reportes';
  static const String informacion = '/informacion';

  static final List<GetPage> rutas = [
    GetPage(
      name: bienvenida,
      page: () => const PantallaBienvenida(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: principal,
      page: () => const PantallaPrincipal(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 450),
    ),

    // Rutas de respaldo para pantallas antiguas
    GetPage(
      name: inicio,
      page: () => const PantallaInicio(),
    ),
    GetPage(
      name: camaraIA,
      page: () => const PantallaCamaraIA(),
    ),
    GetPage(
      name: centroIA,
      page: () => const PantallaCentroIA(),
    ),
    GetPage(
      name: resultado,
      page: () => const PantallaResultado(),
    ),
    GetPage(
      name: historial,
      page: () => const PantallaHistorial(),
    ),
    GetPage(
      name: dashboard,
      page: () => const PantallaDashboard(),
    ),
    GetPage(
      name: reportes,
      page: () => const PantallaReportes(),
    ),
    GetPage(
      name: informacion,
      page: () => const PantallaInformacion(),
    ),
  ];
}