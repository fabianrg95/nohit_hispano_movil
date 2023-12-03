import 'package:flutter/material.dart';
import 'package:no_hit/infraestructure/dto/jugador/jugador_dto.dart';
import 'package:no_hit/main.dart';
import 'package:no_hit/presentation/views/jugadores/jugador_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class ItemJugador extends StatelessWidget {
  final JugadorDto jugador;

  const ItemJugador({
    super.key,
    required this.jugador,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
            return FadeTransition(opacity: animation, child: DetalleJugadorView(idJugador: jugador.id!));
          })),
          child: Container(
            decoration: ViewData().decorationContainerBasic(),
            child: ListTile(
              trailing: BanderaJugador(codigoBandera: jugador.codigoBandera, tamanio: 38),
              title: Text(jugador.nombre!, style: styleTexto.titleMedium, maxLines: 2),
            ),
          ),
        ));
  }
}
