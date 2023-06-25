import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/presentation/providers/providers.dart';
import 'package:no_hit/presentation/views/juegos/detalle_juego_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class ListaJuegos extends ConsumerStatefulWidget {
  final bool juegosOficiales;

  const ListaJuegos({super.key, required this.juegosOficiales});

  @override
  TabViewJuegosState createState() => TabViewJuegosState();
}

class TabViewJuegosState extends ConsumerState<ListaJuegos> {
  @override
  void initState() {
    super.initState();
    ref
        .read(juegosProvider.notifier)
        .loadData(oficialTeamHitless: widget.juegosOficiales);
  }

  @override
  Widget build(BuildContext context) {
    final List<Juego>? juegos =
        ref.watch(juegosProvider)[widget.juegosOficiales];

    if (juegos == null) {
      return const PantallaCargaBasica();
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        //mainAxisExtent: 300 //tamaño alto de cada item
      ),
      itemCount: juegos.length,
      itemBuilder: (BuildContext context, int index) {
        final Juego juego = juegos[index];

        return CardJuego(
          juego: juego,
          accion: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetalleJuego(juego: juego))),
        );
      },
    );

    // return ListView.builder(
    //   itemCount: juegos.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     final Juego juego = juegos[index];

    //     return CardJuego(
    //       juego: juego,
    //       accion: () => Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //               builder: (context) => DetalleJuego(juego: juego))),
    //       left: index.isEven,
    //     );
    //   },
    // );
  }
}
