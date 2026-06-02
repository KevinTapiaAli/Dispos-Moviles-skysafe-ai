import 'package:flutter/material.dart';

class ColoresApp {
  // Nueva identidad visual profesional
  static const Color azulNoche = Color(0xFF0B1F33);
  static const Color azulPetroleo = Color(0xFF12344D);
  static const Color azulPrincipal = Color(0xFF1F5D7A);
  static const Color azulSecundario = Color(0xFF2E7DA1);
  static const Color cianSuave = Color(0xFF5BC0EB);
  static const Color celesteClaro = Color(0xFFDFF3FA);

  static const Color blanco = Color(0xFFFFFFFF);
  static const Color fondoClaro = Color(0xFFF4F7FA);
  static const Color grisClaro = Color(0xFFE7EDF3);
  static const Color grisTexto = Color(0xFF6B7A8C);
  static const Color grisOscuro = Color(0xFF243447);

  static const Color verdeExito = Color(0xFF30B27A);
  static const Color verdeSuave = Color(0xFFE7F8F0);

  static const Color naranjaAlerta = Color(0xFFF4A340);
  static const Color naranjaSuave = Color(0xFFFFF2E2);

  static const Color rojoError = Color(0xFFE85D5D);
  static const Color rojoSuave = Color(0xFFFFEBEB);

  // Compatibilidad con nombres anteriores
  static const Color azulOscuro = azulNoche;
  static const Color azulMedio = azulSecundario;
  static const Color celesteIA = cianSuave;
  static const Color textoPrincipal = grisOscuro;
  static const Color textoSecundario = grisTexto;
  static const Color riesgoBajo = verdeExito;
  static const Color riesgoMedio = naranjaAlerta;
  static const Color riesgoAlto = rojoError;
  static const Color sombraSuave = Color(0x1A000000);

  static const LinearGradient gradientePrincipal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      azulNoche,
      azulPrincipal,
      cianSuave,
    ],
  );

  static const LinearGradient gradienteTarjetaHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F2740),
      Color(0xFF1C5977),
      Color(0xFF59B9D9),
    ],
  );

  static const LinearGradient gradienteBoton = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      azulPrincipal,
      azulSecundario,
    ],
  );
}