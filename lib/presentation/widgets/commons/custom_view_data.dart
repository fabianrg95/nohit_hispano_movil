import 'package:flutter/material.dart';

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
}
