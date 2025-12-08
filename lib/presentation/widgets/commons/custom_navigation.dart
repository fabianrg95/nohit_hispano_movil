import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:no_hit/config/helpers/app_info.dart';
import 'package:no_hit/infraestructure/enums/menu/menu_items.dart';
import 'package:no_hit/main.dart';
import 'package:package_info_plus/package_info_plus.dart' as package_info;

class CustomNavigation extends StatelessWidget {
  const CustomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    return SafeArea(
      child: Drawer(
        backgroundColor: color.primary,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  cabeceraMenu(color),
                  const SizedBox(height: 16),
                  const _ItemMenu(item: MenuItem.inicio),
                  const _ItemMenu(item: MenuItem.juegos),
                  const _ItemMenu(item: MenuItem.jugadores),
                  const _ItemMenu(item: MenuItem.partidas),
                  const _ItemMenu(item: MenuItem.favoritos),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      height: 1,
                      color: color.tertiary.withAlpha(100),
                    ),
                  ),
                  const SizedBox(height: 8),
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
            _FooterVersion(color: color),
          ],
        ),
      ),
    );
  }

  Widget cabeceraMenu(final ColorScheme color) {
    return FadeInDown(
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: AppInfo().porcentajeAlto(0.2),
        padding: EdgeInsets.symmetric(horizontal: AppInfo().porcentajeAncho(0.15)),
        decoration: BoxDecoration(
          color: color.tertiary,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppInfo().porcentajeAncho(0.5)), bottomRight: Radius.circular(AppInfo().porcentajeAncho(0.5))),
        ),
        child: Image.asset(
          'assets/images/panel_${color.brightness != Brightness.dark ? 'blanco' : 'negro'}.png',
          width: AppInfo().porcentajeAncho(0.5),
          height: AppInfo().porcentajeAlto(0.01),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Material(
        color: Colors.transparent,
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
          borderRadius: BorderRadius.circular(12),
          splashColor: color.tertiary.withValues(alpha: 0.15),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: color.tertiary,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.title,
                    style: textTheme.bodyLarge?.copyWith(
                      color: color.tertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: color.onTertiary.withValues(alpha: 0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterVersion extends StatefulWidget {
  final ColorScheme color;

  const _FooterVersion({required this.color});

  @override
  State<_FooterVersion> createState() => _FooterVersionState();
}

class _FooterVersionState extends State<_FooterVersion> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await package_info.PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: widget.color.tertiary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Text(
          'v$_version',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: widget.color.tertiary.withValues(alpha: 0.6),
              ),
        ),
      ),
    );
  }
}
