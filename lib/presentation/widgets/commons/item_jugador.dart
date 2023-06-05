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

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: ListTile(
        leading: BanderaJugador(codigoBandera: jugador.codigoBandera),
        title: Text(jugador.nombre),
        subtitle: Text(jugador.pronombre),
        dense: false,
        titleTextStyle: styleText.titleMedium,
        subtitleTextStyle: styleText.bodySmall,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetalleJugadorView(idJugador: jugador.id))),
        trailing: Text(
          '${jugador.cantidadPartidas} partida${jugador.cantidadPartidas == 1 ? '' : 's'}',
        ),
      ),
    );
  }
}
