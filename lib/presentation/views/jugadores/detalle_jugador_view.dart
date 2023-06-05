import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/presentation/providers/providers.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class DetalleJugadorView extends ConsumerStatefulWidget {
  final int idJugador;

  const DetalleJugadorView({super.key, required this.idJugador});

  @override
  DetalleJugadorState createState() => DetalleJugadorState();
}

class DetalleJugadorState extends ConsumerState<DetalleJugadorView> {
  @override
  void initState() {
    super.initState();
    ref.read(detalleJugadorProvider.notifier).loadData(widget.idJugador);
  }

  @override
  Widget build(BuildContext context) {
    final DetalleJugador? jugador = ref.watch(detalleJugadorProvider);
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    if (jugador == null || jugador.id == 0 || jugador.id != widget.idJugador) {
      return const PantallaCargaBasica();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
              title: Text(
                jugador.nombre,
                style: textStyle.titleLarge?.copyWith(color: colors.primary),
              ),

              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: BanderaJugador(codigoBandera: jugador.codigoBandera),
                )
              ]
      ),
      body: _ListaPartidasJugador(jugador: jugador),
    );

    // return Scaffold(
    //   body: CustomScrollView(
    //     slivers: [
    //       SliverAppBar(
    //         flexibleSpace: FlexibleSpaceBar(
    //           centerTitle: true,
    //           title: Text(
    //             jugador.nombre,
    //             style: textStyle.titleLarge?.copyWith(color: colors.primary),
    //           ),

    //           // actions: [
    //           //   Padding(
    //           //     padding: const EdgeInsets.only(right: 5),
    //           //     child: BanderaJugador(codigoBandera: jugador.codigoBandera),
    //           //   )
    //           // ]
    //         ),
    //       ),
    //       SliverList(
    //           delegate: SliverChildBuilderDelegate((context, index) {
    //         return _ListaPartidasJugador(jugador: jugador);
    //       }, childCount: 1))
    //     ],
    //   ),
    // );
  }
}

class _ListaPartidasJugador extends StatelessWidget {
  const _ListaPartidasJugador({
    required this.jugador,
  });

  final DetalleJugador? jugador;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: jugador!.partidas.length,
      itemBuilder: (BuildContext context, int index) {
        Partidas partidas = jugador!.partidas[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: FloatingActionButton(
            heroTag: '${jugador!.id}${jugador!.cantidadPartidas}${partidas.nombreJuego}',
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.sports_esports_outlined,
                      color: Colors.white),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(partidas.nombreJuego,
                        style: textStyle.bodyMedium,
                        maxLines: 2,
                        softWrap: true),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
