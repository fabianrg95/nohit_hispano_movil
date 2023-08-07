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
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .push(PageRouteBuilder(pageBuilder: (context, animation, __) {
          return FadeTransition(
              opacity: animation,
              child: DetalleJugadorView(idJugador: jugador.id));
        })),
        child: Container(
          decoration: BoxDecoration(
              color: color.secondary,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: color.tertiary, width: 2),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black38,
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: Offset(0, 0))
              ]),
          child: ListTile(
            trailing: BanderaJugador(
                codigoBandera: jugador.codigoBandera, tamanio: 38),
            title:
                Text(jugador.nombre, style: styleText.titleLarge, maxLines: 2),
          ),
        ),
      ),
    );
  }
}
