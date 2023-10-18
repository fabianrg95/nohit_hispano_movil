import 'package:flutter/material.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class InformacionView extends StatefulWidget {
  static const nombre = 'informacion-screen';
  const InformacionView({super.key});

  @override
  State<InformacionView> createState() => _InformacionViewState();
}

class _InformacionViewState extends State<InformacionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDraw(),
      appBar: _titulo(context),
    );
  }

  AppBar _titulo(BuildContext context) {
    return AppBar(
      title: const Text('Informacion general'),
      centerTitle: true,
    );
  }
}
