import 'package:flutter/material.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class ContactoView extends StatelessWidget {
  static const nombre = 'contacto-screen';
  const ContactoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDraw(),
      appBar: _titulo(context),
    );
  }

  AppBar _titulo(BuildContext context) {
    return AppBar(
      title: const Text('Contacto'),
      centerTitle: true,
    );
  }
}
