import 'package:flutter/material.dart';
import 'package:no_hit/config/theme/app_theme.dart';

class ViewData {
  Widget muestraInformacion({required List<Widget> items, required CrossAxisAlignment alineacion, Function? accion}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
        child: GestureDetector(
            onTap: () => accion != null ? accion() : null,
            child: SizedBox(width: double.infinity, child: Column(crossAxisAlignment: alineacion, children: items))),
      ),
    );
  }

  BoxDecoration decorationContainerBasic(
      {bool topLeft = true, bool bottomLeft = true, bool bottomRight = true, bool topRight = true, ColorScheme? color}) {
    ColorScheme colorSheme = color ?? AppTheme().color;

    BorderRadius borderRadius = BorderRadius.only(
        bottomLeft: Radius.circular(bottomLeft ? 20 : 0),
        bottomRight: Radius.circular(bottomRight ? 20 : 0),
        topLeft: Radius.circular(topLeft ? 20 : 0),
        topRight: Radius.circular(topRight ? 20 : 0));

    return BoxDecoration(
      color: colorSheme.secondary,
      borderRadius: borderRadius,
      border: Border.all(color: colorSheme.tertiary, width: 2),
    );
  }
}
