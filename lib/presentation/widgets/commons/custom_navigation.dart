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
            const _ItemMenu(item: MenuItem.juegos),
            const _ItemMenu(item: MenuItem.jugadores),
            const _ItemMenu(item: MenuItem.partidas),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Acerca de",
                style: styleTexto.titleMedium?.copyWith(color: color.tertiary),
              ),
            ),
            const _ItemMenu(item: MenuItem.preguntasFrecuentes),
            const _ItemMenu(item: MenuItem.aplicacion),
            const _ItemMenu(item: MenuItem.comunidad),
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
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(size.width * 0.5), bottomRight: Radius.circular(size.width * 0.5)),
        child: DrawerHeader(
            decoration: BoxDecoration(
              color: color.tertiary,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(size.width * 0.5), bottomRight: Radius.circular(size.width * 0.5)),
            ),
            child: Image.asset(
              'assets/images/panel_${color.brightness != Brightness.dark ? 'blanco' : 'negro'}.png',
              height: size.width * 0.1,
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
        contentPadding: EdgeInsets.only(left: size.width * 0.1),
        leading: Icon(
          item.icon,
          color: color.tertiary,
          size: size.width * 0.08,
        ),
        title: Padding(
          padding: EdgeInsets.only(left: size.width * 0.001),
          child: Text(
            item.title,
            style: TextStyle(color: color.tertiary, fontSize: size.width * 0.04),
          ),
        ),
        onTap: () {
          Navigator.of(context)
              .push(PageRouteBuilder(pageBuilder: (context, animation, ___) => FadeTransition(opacity: animation, child: item.page)));
        });
  }
}
