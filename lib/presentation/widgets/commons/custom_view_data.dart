import 'package:flutter/material.dart';
import 'package:no_hit/main.dart';

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

  BoxDecoration decorationContainerBasic({bool topLeft = true, bool bottomLeft = true, bool bottomRight = true, bool topRight = true}) {
    BorderRadius borderRadius = BorderRadius.only(
        bottomLeft: Radius.circular(bottomLeft ? 20 : 0),
        bottomRight: Radius.circular(bottomRight ? 20 : 0),
        topLeft: Radius.circular(topLeft ? 20 : 0),
        topRight: Radius.circular(topRight ? 45 : 0));

    return BoxDecoration(
      color: color.secondary,
      borderRadius: borderRadius,
      border: Border.all(color: color.tertiary, width: 2),
    );
  }
}
