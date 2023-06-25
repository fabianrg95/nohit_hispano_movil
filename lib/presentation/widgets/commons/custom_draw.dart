import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:no_hit/config/router/menu_items.dart';

class CustomDraw extends StatelessWidget {
  const CustomDraw({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: color.primary,
      child: ListView(children: [
        FadeInDown(
          duration: const Duration(milliseconds: 300),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(550),
                bottomRight: Radius.circular(550)),
            child: DrawerHeader(
                decoration: BoxDecoration(
                  color: color.tertiary,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(550),
                      bottomRight: Radius.circular(550)),
                ),
                child: Image.asset(
                  'assets/images/panel_negro.png',
                  height: 110,
                )),
          ),
        ),
        const _ItemMenu(item: MenuItem.inicio),
        const _ItemMenu(item: MenuItem.juegos),
        const _ItemMenu(item: MenuItem.jugadores)
      ]),
    );
  }
}

class _ItemMenu extends StatelessWidget {
  final MenuItem item;

  const _ItemMenu({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    return ListTile(
        contentPadding: const EdgeInsets.only(left: 30),
        leading: Icon(
          item.icon,
          color: color.tertiary,
          size: 40,
        ),
        title: Text(
          item.title,
          style: textStyle.titleLarge?.copyWith(color: color.tertiary),
        ),
        onTap: () {
          //Navigator.pop(context);
          context.go(item.link);
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => item.page,));
        });
  }
}
