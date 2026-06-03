import 'package:flutter/material.dart';

class ColoresApp {
  // Identidad principal: estilo aeroespacial moderno
  static const Color nocheProfunda = Color(0xFF07111F);
  static const Color azulEspacial = Color(0xFF0B1E33);
  static const Color azulGalactico = Color(0xFF102A43);
  static const Color azulElectrico = Color(0xFF2563EB);
  static const Color cianNeon = Color(0xFF22D3EE);
  static const Color violetaIA = Color(0xFF7C3AED);
  static const Color lavandaSuave = Color(0xFFEDE9FE);

  // Fondos
  static const Color fondoClaro = Color(0xFFF6F8FC);
  static const Color fondoTarjeta = Color(0xFFFFFFFF);
  static const Color fondoSuave = Color(0xFFEFF6FF);
  static const Color bordeSuave = Color(0xFFE2E8F0);

  // Textos
  static const Color textoPrincipal = Color(0xFF111827);
  static const Color textoSecundario = Color(0xFF64748B);
  static const Color textoClaro = Color(0xFFFFFFFF);

  // Estados operativos
  static const Color riesgoBajo = Color(0xFF10B981);
  static const Color riesgoMedio = Color(0xFFF59E0B);
  static const Color riesgoAlto = Color(0xFFEF4444);

  static const Color verdeSuave = Color(0xFFD1FAE5);
  static const Color naranjaSuave = Color(0xFFFEF3C7);
  static const Color rojoSuave = Color(0xFFFEE2E2);
  static const Color azulSuave = Color(0xFFDBEAFE);
  static const Color cianSuave = Color(0xFFCFFAFE);
  static const Color violetaSuave = Color(0xFFEDE9FE);

  // Compatibilidad con nombres anteriores
  static const Color azulNoche = nocheProfunda;
  static const Color azulPetroleo = azulGalactico;
  static const Color azulPrincipal = azulElectrico;
  static const Color azulSecundario = cianNeon;
  static const Color azulOscuro = nocheProfunda;
  static const Color azulMedio = azulElectrico;
  static const Color grisTexto = textoSecundario;
  static const Color grisOscuro = textoPrincipal;
  static const Color grisClaro = bordeSuave;
  static const Color blanco = fondoTarjeta;
  static const Color celesteClaro = cianSuave;
  static const Color celesteIA = cianNeon;
  static const Color verdeExito = riesgoBajo;
  static const Color naranjaAlerta = riesgoMedio;
  static const Color rojoError = riesgoAlto;
  static const Color sombraSuave = Color(0x1A000000);

  // Gradientes principales
  static const LinearGradient gradientePrincipal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      nocheProfunda,
      azulGalactico,
      violetaIA,
    ],
  );

  static const LinearGradient gradienteAurora = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF07111F),
      Color(0xFF102A43),
      Color(0xFF1E3A8A),
      Color(0xFF7C3AED),
    ],
  );

  static const LinearGradient gradienteBoton = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      azulElectrico,
      cianNeon,
    ],
  );

  static const LinearGradient gradienteTarjetaHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      nocheProfunda,
      azulGalactico,
      azulElectrico,
      cianNeon,
    ],
  );

  static const LinearGradient gradienteVioleta = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      violetaIA,
      azulElectrico,
    ],
  );

  static BoxShadow sombraElegante = BoxShadow(
    color: Colors.black.withOpacity(0.08),
    blurRadius: 24,
    offset: const Offset(0, 12),
  );

  static BoxShadow sombraBoton = BoxShadow(
    color: azulElectrico.withOpacity(0.28),
    blurRadius: 22,
    offset: const Offset(0, 10),
  );
}