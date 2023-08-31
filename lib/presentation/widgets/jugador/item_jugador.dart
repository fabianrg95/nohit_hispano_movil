import 'package:flutter/material.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/dto/jugador/jugador_dto.dart';
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
    final styleText = Theme.of(context).textTheme;

    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
            return FadeTransition(opacity: animation, child: DetalleJugadorView(idJugador: jugador.id!));
          })),
          child: Container(
            decoration: AppTheme.decorationContainerBasic(bottomLeft: true, bottomRight: true, topLeft: true, topRight: true),
            child: ListTile(
              trailing: BanderaJugador(codigoBandera: jugador.codigoBandera, tamanio: 38, defaultNegro: true),
              title: Text(jugador.nombre!, style: styleText.titleLarge, maxLines: 2),
            ),
          ),
        ));
  }
}
