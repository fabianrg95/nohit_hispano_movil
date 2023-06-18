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

    return ListView.builder(
      itemCount: juegos.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == juegos.length) {
          return const SizedBox(height: 50);
        }

        final Juego juego = juegos[index];

        return Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: CardJuego(juego: juego, accion: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetalleJuego(juego: juego)))));
      },
    );
  }
}
