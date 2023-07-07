import 'package:flutter/material.dart';

class PartidasView extends StatelessWidget {
  static const nombre = 'partidas_view';

  const PartidasView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu)),
              title: const Text('No hit hispano'),
              centerTitle: true,
            ),
            body: Container(
  decoration: const BoxDecoration(
    border: Border(
      top: BorderSide(color: Color(0xFFFFFFFF)),
      left: BorderSide(color: Color(0xFFFFFFFF)),
      right: BorderSide(),
      bottom: BorderSide(),
    ),
  ),
  child: const Expanded(child: Text('')),
)
            ));
  }
}
