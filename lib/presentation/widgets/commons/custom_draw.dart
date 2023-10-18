import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:no_hit/config/router/menu_items.dart';
import 'package:no_hit/main.dart';

class CustomDraw extends StatelessWidget {
  const CustomDraw({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: color.primary,
        child: ListView(
          children: [
            cabeceraMenu(),
            const _ItemMenu(item: MenuItem.inicio),
            const _ItemMenu(item: MenuItem.partidas),
            const _ItemMenu(item: MenuItem.juegos),
            const _ItemMenu(item: MenuItem.jugadores),
            // const _ItemMenu(item: MenuItem.informacion),
            // const _ItemMenu(item: MenuItem.contacto),
          ],
        ),
      ),
    );
  }

  Widget cabeceraMenu() {
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
              'assets/images/panel_blanco.png',
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
          context.go(item.link);
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => item.page,));
        });
  }
}
