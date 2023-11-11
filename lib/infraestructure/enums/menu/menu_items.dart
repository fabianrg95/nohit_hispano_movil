import 'package:flutter/material.dart';
import 'package:no_hit/presentation/views/views.dart';

enum MenuItem {
  inicio(
    title: 'inicio',
    link: '/inicio',
    page: InicioView(),
    icon: Icons.home_max_outlined,
  ),
  partidas(
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
    icon: Icons.groups_2_outlined,
  ),
  informacion(
    title: 'Informacion',
    link: '/informacion',
    page: InformacionView(),
    icon: Icons.info_outline,
  ),
  contacto(
    title: 'Contacto',
    link: '/contacto',
    page: InformacionView(),
    icon: Icons.engineering_outlined,
  );

  final String title;
  final String link;
  final Widget page;
  final IconData icon;

  const MenuItem({required this.title, required this.link, required this.icon, required this.page});
}
