import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primario = Color(0xff48426D);
  static const Color secundario = Color.fromARGB(255, 53, 49, 85);
  static const Color terciario = Color.fromARGB(255, 238, 193, 141);
  static const Color texto = Color(0xffBEABC2);

  ThemeData getTheme() => ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(circularTrackColor: terciario),
      useMaterial3: true,
      cardTheme: const CardTheme(color: secundario),
      listTileTheme: const ListTileThemeData(textColor: texto),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: terciario,
          selectedItemColor: Color(0xff353052),
          unselectedLabelStyle: TextStyle(color: Color(0xff353052)),
          unselectedItemColor: Color(0xFF353052)),
      colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: primario,
          background: primario,
          primary: primario,
          secondary: secundario,
          tertiary: terciario),
      tabBarTheme: TabBarTheme(
          indicator: BoxDecoration(
              color: terciario, borderRadius: BorderRadius.circular(10))),
      appBarTheme: const AppBarTheme(
          backgroundColor: terciario,
          centerTitle: true,
          foregroundColor: secundario,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)))));
}
