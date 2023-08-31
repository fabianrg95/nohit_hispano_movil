import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/juego/juego_dto.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
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
    ref.read(juegosProvider.notifier).loadData(oficialTeamHitless: widget.juegosOficiales);
  }

  @override
  Widget build(BuildContext context) {
    final List<JuegoDto>? juegos = ref.watch(juegosProvider)[widget.juegosOficiales];

    if (juegos == null) {
      return const PantallaCargaBasica(
        texto: "Consultando Juegos",
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        //mainAxisExtent: 300 //tamaño alto de cada item
      ),
      itemCount: juegos.length,
      itemBuilder: (BuildContext context, int index) {
        final JuegoDto juego = juegos[index];
        return CardJuego(
            juego: juego,
            accion: () => Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, __) {
                    return FadeTransition(opacity: animation, child: DetalleJuego(juego: juego));
                  },
                )));
      },
    );
  }
}
