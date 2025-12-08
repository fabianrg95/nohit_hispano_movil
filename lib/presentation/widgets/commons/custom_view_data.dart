import 'package:flutter/material.dart';
import 'package:no_hit/config/theme/app_theme.dart';

class ViewData {
  Widget muestraInformacionAccion({required List<Widget> items, CrossAxisAlignment alineacion = CrossAxisAlignment.center, Function? accion}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 5),
        child: GestureDetector(
            onTap: () => accion != null ? accion() : null,
            child: SizedBox(width: double.infinity, child: Column(crossAxisAlignment: alineacion, children: items))),
      ),
    );
  }

  Widget muestraInformacionSimple({required List<Widget> items, CrossAxisAlignment alineacion = CrossAxisAlignment.center}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 5),
        child: SizedBox(width: double.infinity, child: Column(crossAxisAlignment: alineacion, children: items)),
      ),
    );
  }

  BoxDecoration decorationContainerBasic(
      {bool borderRadiusTopLeft = true,
      bool borderRadiusBottomLeft = true,
      bool borderRadiusBottomRight = true,
      bool borderRadiusTopRight = true,
      bool borderColorTop = true,
      bool borderColorBottom = true,
      bool borderColorRight = true,
      bool borderColorLeft = true,
      ColorScheme? color}) {
    ColorScheme colorSheme = color ?? AppTheme().color;

    BorderRadius borderRadius = BorderRadius.only(
        bottomLeft: Radius.circular(borderRadiusBottomLeft ? 20 : 0),
        bottomRight: Radius.circular(borderRadiusBottomRight ? 20 : 0),
        topLeft: Radius.circular(borderRadiusTopLeft ? 20 : 0),
        topRight: Radius.circular(borderRadiusTopRight ? 20 : 0));

    Border borderColor = Border(
        top: borderColorTop ? BorderSide(color: colorSheme.tertiary, width: 2) : BorderSide.none,
        bottom: borderColorBottom ? BorderSide(color: colorSheme.tertiary, width: 2) : BorderSide.none,
        right: borderColorRight ? BorderSide(color: colorSheme.tertiary, width: 2) : BorderSide.none,
        left: borderColorLeft ? BorderSide(color: colorSheme.tertiary, width: 2) : BorderSide.none);

    return BoxDecoration(color: colorSheme.surfaceContainerHighest, borderRadius: borderRadius, border: borderColor);
  }
}
