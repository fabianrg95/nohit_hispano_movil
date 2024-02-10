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
            const _ItemMenu(item: MenuItem.informacion),
            // const _ItemMenu(item: MenuItem.contacto),
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
        contentPadding: const EdgeInsets.only(left: 30),
        leading: Icon(
          item.icon,
          color: color.tertiary,
          size: 40,
        ),
        title: Text(
          item.title,
          style: styleTexto.titleLarge?.copyWith(color: color.tertiary),
        ),
        onTap: () {
          //Navigator.pop(context);
          Navigator.of(context)
              .push(PageRouteBuilder(pageBuilder: (context, animation, ___) => FadeTransition(opacity: animation, child: item.page)));
          // context.go(item.link);
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => item.page,));
        });
  }
}
