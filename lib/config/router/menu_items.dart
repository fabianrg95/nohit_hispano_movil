import 'package:flutter/material.dart';
import 'package:no_hit/presentation/views/juegos/lista_juegos_view.dart';
import 'package:no_hit/presentation/views/jugadores/lista_jugadores_view.dart';
import 'package:no_hit/presentation/views/partidas/partidas_view.dart';

enum MenuItem {
  inicio(
    title: 'Partidas',
    link: '/partidas',
    page: PartidasView(),
    icon: Icons.workspace_premium,
  ),
  juegos(
    title: 'Juegos',
    link: '/juegos',
    page: ListaJuegosView(),
    icon: Icons.sports_esports_outlined,
  ),
  jugadores(
    title: 'Jugadores',
    link: '/jugadores',
    page: ListaJugadoresView(),
    icon: Icons.person_2_outlined,
  );

  final String title;
  final String link;
  final Widget page;
  final IconData icon;

  const MenuItem({required this.title, required this.link, required this.icon, required this.page});
}
