import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colores_app.dart';

class TemaApp {
  static ThemeData get temaClaro {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: ColoresApp.fondoClaro,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColoresApp.azulPrincipal,
        brightness: Brightness.light,
        primary: ColoresApp.azulPrincipal,
        secondary: ColoresApp.cianSuave,
        surface: ColoresApp.blanco,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        headlineLarge: GoogleFonts.poppins(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: ColoresApp.grisOscuro,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: ColoresApp.grisOscuro,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ColoresApp.grisOscuro,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          color: ColoresApp.grisOscuro,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          color: ColoresApp.grisTexto,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ColoresApp.azulPrincipal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColoresApp.azulPrincipal,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColoresApp.azulPrincipal,
          side: const BorderSide(color: ColoresApp.azulPrincipal, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}