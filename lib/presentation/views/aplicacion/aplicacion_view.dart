import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:no_hit/presentation/views/inicio/inicio_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../l10n/app_localizations.dart';

class Aplicacion extends StatelessWidget {
  static const nombre = 'aplicacion-screen';
  const Aplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, __, ___) => const InicioView()));
      },
      child: FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return SafeArea(
            child: Scaffold(
              drawer: const CustomNavigation(),
              appBar: AppBar(
                forceMaterialTransparency: true,
                title: Text(AppLocalizations.of(context)!.aplicacion),
                centerTitle: true,
              ),
              body: contenido(context, snapshot),
            ),
          );
        },
      ),
    );
  }

  Widget contenido(BuildContext context, AsyncSnapshot snapshot) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (snapshot.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: color.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar la información',
              style: textTheme.titleMedium?.copyWith(color: color.onSurface),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: color.onSurfaceVariant),
              ),
            ),
          ],
        ),
      );
    }

    if (!snapshot.hasData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final PackageInfo packageInfo = snapshot.data!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // App Logo and Basic Info
          Card(
            elevation: 0,
            color: color.surfaceVariant.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: color.outline.withValues(alpha: 0.1)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: color.tertiary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.primary.withValues(alpha: 0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/panel_${isDark ? 'negro' : 'blanco'}.png',
                      width: size.width * 0.3,
                      height: size.width * 0.3,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Hit Hispano',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'v${packageInfo.version}+${packageInfo.buildNumber}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: color.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // App Info Cards
          _buildInfoCard(
            context,
            title: 'Acerca de',
            icon: Icons.info_outline_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoItem(
                  context,
                  icon: Icons.update_rounded,
                  title: 'Última actualización',
                  value: '17 de Nov, 2023',
                ),
                const SizedBox(height: 12),
                _buildInfoItem(
                  context,
                  icon: Icons.storage_rounded,
                  title: 'Tamaño de la app',
                  value: '15.2 MB',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Links Section
          Text(
            'Enlaces',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          _buildLinkCard(
            context,
            icon: FontAwesomeIcons.github,
            title: 'GitHub',
            onTap: () => CustomLinks().lanzarUrl("https://github.com/fabianrg95/nohit_hispano_movil"),
          ),
          const SizedBox(height: 12),
          _buildLinkCard(
            context,
            icon: FontAwesomeIcons.googlePlay,
            title: 'Google Play',
            onTap: () => CustomLinks().lanzarUrl("https://play.google.com/store/apps/details?id=com.fabianrodriguez.nohit.hispano"),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required IconData icon, required Widget child}) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: color.surfaceVariant.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.outline.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color.tertiary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    color: color.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, {required IconData icon, required String title, required String value}) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: color.onSurfaceVariant.withValues(alpha: 0.8)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.bodySmall?.copyWith(
                color: color.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: color.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLinkCard(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: color.surfaceVariant.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.outline.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              FaIcon(icon, color: color.tertiary, size: 20),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.bodyLarge?.copyWith(
                    color: color.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: color.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
