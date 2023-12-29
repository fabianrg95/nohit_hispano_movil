import 'package:flutter/material.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class ListaJugadoresJuego extends StatelessWidget {
  final List<JugadorDto>? listaJugadores;

  const ListaJugadoresJuego({super.key, required this.listaJugadores});

  @override
  Widget build(BuildContext context) {
    if (listaJugadores == null || listaJugadores!.isEmpty) {
      return const Center(child: Text('El juego no cuenta con jugadores registradas'));
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: listaJugadores!.length,
          itemBuilder: (BuildContext context, int index) => ItemJugador(jugador: listaJugadores![index]),
        ),
      ),
    );
  }
}
