import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/analisis_controller.dart';
import 'rutas_app.dart';
import 'tema_app.dart';

class SkySafeApp extends StatelessWidget {
  const SkySafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SkySafe AI',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.temaClaro,
      initialRoute: RutasApp.bienvenida,
      getPages: RutasApp.rutas,
      initialBinding: BindingsBuilder(() {
        Get.put<AnalisisController>(
          AnalisisController(),
          permanent: true,
        );
      }),
    );
  }
}