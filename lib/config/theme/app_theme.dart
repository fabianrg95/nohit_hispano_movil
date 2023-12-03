import 'package:flutter/material.dart';
import 'package:no_hit/infraestructure/enums/enums.dart';

class AppTheme {
  final bool esTemaClaro;

  AppTheme({this.esTemaClaro = true});

  ThemeData getTheme() {
    final ColorScheme colorScheme = validarTema();

    return ThemeData(
      fontFamily: 'SharpGrotesk',
      colorScheme: colorScheme,
      progressIndicatorTheme: ProgressIndicatorThemeData(circularTrackColor: colorScheme.tertiary),
      useMaterial3: true,
      cardTheme: CardTheme(color: colorScheme.secondary),
      listTileTheme: ListTileThemeData(textColor: colorScheme.outline),
      // appBarTheme: AppBarTheme(
        // backgroundColor: Colors.transparent,
        // centerTitle: false,
        // foregroundColor: colorScheme.tertiary,
        // surfaceTintColor: colorScheme.tertiary,
      // ),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: colorScheme.primary,
                    showDragHandle: true)
    );
  }

  ColorScheme validarTema() {
    return esTemaClaro ? PaletaColores.temaClaro.getPaletaColor() : PaletaColores.temaOscuro.getPaletaColor();
  }

  AppTheme copyWith({bool? isDarkmode}) => AppTheme(
        esTemaClaro: isDarkmode ?? esTemaClaro,
      );
}
