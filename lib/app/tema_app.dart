import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colores_app.dart';

class TemaApp {
  static ThemeData get temaClaro {
    final TextTheme baseTextTheme = GoogleFonts.poppinsTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ColoresApp.fondoClaro,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColoresApp.azulElectrico,
        brightness: Brightness.light,
        primary: ColoresApp.azulElectrico,
        secondary: ColoresApp.cianNeon,
        surface: ColoresApp.fondoTarjeta,
      ),
      textTheme: baseTextTheme.copyWith(
        headlineLarge: GoogleFonts.poppins(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: ColoresApp.textoPrincipal,
          height: 1.15,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: ColoresApp.textoPrincipal,
          height: 1.2,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 21,
          fontWeight: FontWeight.w700,
          color: ColoresApp.textoPrincipal,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ColoresApp.textoPrincipal,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: ColoresApp.textoPrincipal,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ColoresApp.textoSecundario,
          height: 1.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ColoresApp.nocheProfunda,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: ColoresApp.fondoTarjeta,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColoresApp.azulElectrico,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColoresApp.azulElectrico,
          side: const BorderSide(
            color: ColoresApp.azulElectrico,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ColoresApp.nocheProfunda,
        contentTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}