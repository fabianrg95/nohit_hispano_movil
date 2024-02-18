import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:no_hit/infraestructure/enums/menu/menu_items.dart';
import 'package:no_hit/main.dart';

class CustomNavigation extends StatelessWidget {
  const CustomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    return SafeArea(
      child: Drawer(
        backgroundColor: color.primary,
        child: ListView(
          children: [
            cabeceraMenu(color),
            const SizedBox(height: 20),
            const _ItemMenu(item: MenuItem.inicio),
            const _ItemMenu(item: MenuItem.partidas),
            const _ItemMenu(item: MenuItem.juegos),
            const _ItemMenu(item: MenuItem.jugadores),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Acerca de",
                style: styleTexto.titleMedium?.copyWith(color: color.tertiary),
              ),
            ),
            const _ItemMenu(item: MenuItem.preguntasFrecuentes),
            const _ItemMenu(item: MenuItem.desarrollador),
          ],
        ),
      ),
    );
  }

  Widget cabeceraMenu(final ColorScheme color) {
    return FadeInDown(
      duration: const Duration(milliseconds: 300),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(550), bottomRight: Radius.circular(550)),
        child: DrawerHeader(
            decoration: BoxDecoration(
              color: color.tertiary,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(550), bottomRight: Radius.circular(550)),
            ),
            child: Image.asset(
              'assets/images/panel_${color.brightness != Brightness.dark ? 'blanco' : 'negro'}.png',
              height: 110,
            )),
      ),
    );
  }
}

class _ItemMenu extends StatelessWidget {
  final MenuItem item;

  const _ItemMenu({required this.item});

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    return ListTile(
        contentPadding: const EdgeInsets.only(left: 20),
        leading: Icon(
          item.icon,
          color: color.tertiary,
          size: 30,
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            item.title,
            style: styleTexto.titleMedium?.copyWith(color: color.tertiary),
          ),
        ),
        onTap: () {
          Navigator.of(context)
              .push(PageRouteBuilder(pageBuilder: (context, animation, ___) => FadeTransition(opacity: animation, child: item.page)));
        });
  }
}
