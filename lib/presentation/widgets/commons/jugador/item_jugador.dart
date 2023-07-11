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

    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.black38,
                spreadRadius: 0,
                blurRadius: 5,
                offset: Offset(0, 0))
          ]),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetalleJugadorView(idJugador: jugador.id))),
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                  child: BanderaJugador(
                      codigoBandera: jugador.codigoBandera, tamanio: 45),
                ),
                Text(jugador.nombre,
                    maxLines: 2,
                    softWrap: true,
                    style:
                        styleText.bodySmall?.copyWith(color: color.tertiary)),
                Visibility(
                    visible: jugador.pronombre != null,
                    child: Text(jugador.pronombre.toString(),
                        style: styleText.bodySmall
                            ?.copyWith(color: color.tertiary))),
                const Expanded(child: Text('')),
                SizedBox(
                  width: 100,
                  child: Chip(
                    elevation: 0,
                    label: Text(
                      '${jugador.cantidadPartidas} partida${jugador.cantidadPartidas == 1 ? '' : 's'}',
                      style: styleText.labelSmall,
                    ),
                  ),
                ),
              ],
            )
            // ListTile(
            //   leading: BanderaJugador(codigoBandera: jugador.codigoBandera),
            //   title: Text(jugador.nombre,
            //       style: styleText.bodyMedium?.copyWith(color: color.tertiary)),
            //   subtitle: Visibility(
            //       visible: jugador.pronombre != null,
            //       child: Text(jugador.pronombre.toString(),
            //           style:
            //               styleText.bodyMedium?.copyWith(color: color.tertiary))),
            //   dense: false,
            //   titleTextStyle: styleText.titleMedium,
            //   subtitleTextStyle: styleText.bodySmall,
            //
            //   trailing:
            // ),
            ),
      ),
    );
  }
}
