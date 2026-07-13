import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:no_hit/config/helpers/app_info.dart';
import 'package:no_hit/infraestructure/enums/menu/menu_items.dart';
import 'package:no_hit/main.dart';
import 'package:package_info_plus/package_info_plus.dart' as package_info;

class CustomNavigation extends StatelessWidget {
  final MenuItem? selectedItem;
  final ValueChanged<MenuItem>? onItemSelected;

  const CustomNavigation({super.key, this.selectedItem, this.onItemSelected});

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
                  _ItemMenu(
                    item: MenuItem.inicio,
                    isSelected: selectedItem == MenuItem.inicio,
                    onTap: () => _onTapItem(context, MenuItem.inicio),
                  ),
                  _ItemMenu(
                    item: MenuItem.juegos,
                    isSelected: selectedItem == MenuItem.juegos,
                    onTap: () => _onTapItem(context, MenuItem.juegos),
                  ),
                  _ItemMenu(
                    item: MenuItem.jugadores,
                    isSelected: selectedItem == MenuItem.jugadores,
                    onTap: () => _onTapItem(context, MenuItem.jugadores),
                  ),
                  _ItemMenu(
                    item: MenuItem.partidas,
                    isSelected: selectedItem == MenuItem.partidas,
                    onTap: () => _onTapItem(context, MenuItem.partidas),
                  ),
                  _ItemMenu(
                    item: MenuItem.favoritos,
                    isSelected: selectedItem == MenuItem.favoritos,
                    onTap: () => _onTapItem(context, MenuItem.favoritos),
                  ),
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
                  _ItemMenu(
                    item: MenuItem.preguntasFrecuentes,
                    isSelected: selectedItem == MenuItem.preguntasFrecuentes,
                    onTap: () => _onTapItem(context, MenuItem.preguntasFrecuentes),
                  ),
                  _ItemMenu(
                    item: MenuItem.aplicacion,
                    isSelected: selectedItem == MenuItem.aplicacion,
                    onTap: () => _onTapItem(context, MenuItem.aplicacion),
                  ),
                  _ItemMenu(
                    item: MenuItem.comunidad,
                    isSelected: selectedItem == MenuItem.comunidad,
                    onTap: () => _onTapItem(context, MenuItem.comunidad),
                  ),
                  _ItemMenu(
                    item: MenuItem.desarrollador,
                    isSelected: selectedItem == MenuItem.desarrollador,
                    onTap: () => _onTapItem(context, MenuItem.desarrollador),
                  ),
                ],
              ),
            ),
            _FooterVersion(color: color),
          ],
        ),
      ),
    );
  }

  void _onTapItem(BuildContext context, MenuItem item) {
    Navigator.of(context).pop();

    if (onItemSelected != null) {
      onItemSelected!(item);
      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, ___) => FadeTransition(
          opacity: animation,
          child: item.page,
        ),
        transitionDuration: const Duration(milliseconds: 300),
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
  final bool isSelected;
  final VoidCallback onTap;

  const _ItemMenu({required this.item, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isSelected ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? color.tertiary.withValues(alpha: 0.3) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isSelected ? color.tertiary : Colors.transparent),
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: isSelected ? color.onSurfaceVariant : color.tertiary,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.title,
                    style: textTheme.bodyLarge?.copyWith(
                      color: isSelected ? color.onSurfaceVariant : color.tertiary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
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
