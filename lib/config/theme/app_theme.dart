import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      useMaterial3: true,
      colorSchemeSeed: const Color(0xffb99763),
      listTileTheme: ListTileThemeData(tileColor: const Color(0xff666666).withAlpha(80)),
      brightness: Brightness.dark,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xff444444),
          unselectedLabelStyle:
              TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6)),
          unselectedItemColor: Color.fromRGBO(255, 255, 255, 0.6)));
}
