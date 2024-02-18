import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:no_hit/presentation/views/aplicacion/aplicacion_view.dart';
import 'package:no_hit/presentation/views/comunidad/comunidad_view.dart';
import 'package:no_hit/presentation/views/introduccion/introduccion_view.dart';
import 'package:no_hit/presentation/views/views.dart';

enum MenuItem {
  inicio(
    title: 'Inicio',
    link: '/inicio',
    page: InicioView(),
    nombre: InicioView.nombre,
    icon: Icons.home_outlined,
  ),
  partidas(
    title: 'Partidas',
    link: '/partidas',
    page: PartidasView(),
    icon: Icons.workspace_premium,
    nombre: PartidasView.nombre,
  ),
  juegos(
    title: 'Juegos',
    link: '/juegos',
    page: ListaJuegosView(),
    icon: Icons.sports_esports_outlined,
    nombre: ListaJuegosView.nombre,
  ),
  jugadores(
    title: 'Jugadores',
    link: '/jugadores',
    page: ListaJugadoresView(),
    icon: Icons.groups_2_outlined,
    nombre: ListaJugadoresView.nombre,
  ),
  preguntasFrecuentes(
    title: 'Preguntas frecuentes',
    link: '/preguntas_frecuentes',
    page: PreguntasFrecuentesView(),
    icon: Icons.info_outline,
    nombre: PreguntasFrecuentesView.nombre,
  ),
  desarrollador(
    title: 'Desarrollador',
    link: '/desarrollador',
    page: Desarrollador(),
    icon: Icons.developer_mode_outlined,
    nombre: Desarrollador.nombre,
  ),
  aplicacion(
    title: 'Aplicacion',
    link: '/aplicacion',
    page: Aplicacion(),
    icon: Icons.app_shortcut_outlined,
    nombre: Aplicacion.nombre,
  ),
  comunidad(
    title: 'Comunidad',
    link: '/comunidad',
    page: Comunidad(),
    icon: Icons.groups_2_outlined,
    nombre: Comunidad.nombre,
  ),
  introduccion(
    title: 'Introduccion',
    link: '/introduccion',
    page: IntroduccionView(),
    icon: Icons.view_carousel_outlined,
    nombre: IntroduccionView.nombre,
  );

  final String title;
  final String link;
  final Widget page;
  final IconData icon;
  final String nombre;

  const MenuItem({required this.title, required this.link, required this.icon, required this.page, required this.nombre});

  static List<GoRoute> obtenerRutas() {
    final List<GoRoute> listaRutas = [];
    for (final MenuItem item in MenuItem.values) {
      listaRutas.add(GoRoute(path: item.link, name: item.nombre, builder: (context, state) => item.page));
    }
    return listaRutas;
  }
}
