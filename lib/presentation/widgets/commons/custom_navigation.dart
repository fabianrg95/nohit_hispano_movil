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
            const _ItemMenu(item: MenuItem.favoritos),
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
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.tertiary.withValues(alpha: 0.3),
                color.tertiary.withValues(alpha: 0.3),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, ___) => FadeTransition(
                    opacity: animation,
                    child: item.page,
                  ),
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            splashColor: color.primary.withValues(alpha: 0.2),
            highlightColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Icon Container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.primary.withValues(alpha: 0.9),
                          color.primary.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: color.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      item.icon,
                      color: color.tertiary,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Title
                  Expanded(
                    child: Text(
                      item.title,
                      style: textTheme.titleMedium?.copyWith(
                        color: color.outline,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),

                  // Chevron
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: color.onSurfaceVariant.withValues(alpha: 0.6),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
