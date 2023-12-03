import 'package:flutter/material.dart';
import 'package:no_hit/main.dart';
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
      extendBodyBehindAppBar: true,
      appBar: _titulo(context),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://images.igdb.com/igdb/image/upload/t_cover_big/co47rj.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: null /* add child content here */,
      ),
    );
  }

  AppBar _titulo(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      forceMaterialTransparency: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(onPressed: () => Navigator.of(context).pop(), style: IconButton.styleFrom(backgroundColor: color.primary), icon: Icon(Icons.close, color: color.tertiary,)),
    );
  }
}
