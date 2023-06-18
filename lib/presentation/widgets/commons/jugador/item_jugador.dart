import 'package:flutter/material.dart';
import 'package:no_hit/domain/entities/jugador.dart';
import 'package:no_hit/presentation/views/jugadores/detalle_jugador_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class ItemJugador extends StatelessWidget {
  final Jugador jugador;

  const ItemJugador({
    super.key,
    required this.jugador,
  });

  @override
  Widget build(BuildContext context) {
    final styleText = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black38,
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: Offset(0, 0))
            ]),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: color.tertiary)),
          child: ListTile(
            leading: BanderaJugador(codigoBandera: jugador.codigoBandera),
            title: Text(jugador.nombre),
            subtitle: Visibility(
                visible: jugador.pronombre != null,
                child: Text(jugador.pronombre.toString())),
            dense: false,
            titleTextStyle: styleText.titleMedium,
            subtitleTextStyle: styleText.bodySmall,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetalleJugadorView(idJugador: jugador.id))),
            trailing: Text(
              '${jugador.cantidadPartidas} partida${jugador.cantidadPartidas == 1 ? '' : 's'}',
            ),
          ),
        ),
      ),
    );
  }
}
