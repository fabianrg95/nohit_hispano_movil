import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
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
          child: DrawerHeader(
              decoration: BoxDecoration(
                  color: color.tertiary,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(150),
                      bottomRight: Radius.circular(150))),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/panel_negro.png',
                    height: 120,
                  ),
                ],
              )),
        ),
        //const _ItemMenu(item: MenuItem.inicio, reemplazar: true),
        const _ItemMenu(item: MenuItem.juegos),
        const _ItemMenu(item: MenuItem.jugadores)
      ]),
    );
  }
}

class _ItemMenu extends StatelessWidget {
  final MenuItem item;
  final bool reemplazar;

  const _ItemMenu({required this.item, this.reemplazar = false});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    return ListTile(
        contentPadding: const EdgeInsets.only(left: 60),
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
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => item.page,
          ));
        });
  }
}
