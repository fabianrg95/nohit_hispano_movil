import 'package:flutter/material.dart';

class ViewData {
  Widget muestraInformacion({required List<Widget> items, required CrossAxisAlignment alineacion}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
        child: Row(children: [Expanded(child: Column(crossAxisAlignment: alineacion, children: items))]),
      ),
    );
  }
}
