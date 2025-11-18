import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:no_hit/presentation/views/inicio/inicio_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

import '../../../l10n/app_localizations.dart';

class Comunidad extends StatelessWidget {
  static const nombre = 'comunidad-screen';
  const Comunidad({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, __, ___) => const InicioView()));
        },
        child: SafeArea(
          child: Scaffold(
            drawer: const CustomNavigation(),
            appBar: AppBar(
              forceMaterialTransparency: true,
              title: Text(AppLocalizations.of(context)!.comunidad),
              centerTitle: true,
            ),
            body: contenido(context),
          ),
        ));
  }

  Widget contenido(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: size.width * 0.5,
              height: size.width * 0.5,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.surfaceVariant.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.outline.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.shadow.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/comunidadNoHit.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              'Síguenos en redes',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Conéctate con nuestra comunidad',
              style: textTheme.bodyMedium?.copyWith(
                color: color.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // Social Media Buttons
            _buildSocialButton(
              context,
              icon: FontAwesomeIcons.twitter,
              label: 'Twitter',
              color: const Color(0xFF1DA1F2),
              onTap: () => CustomLinks().lanzarUrl("https://twitter.com/NoHitHispano"),
            ),
            const SizedBox(height: 16),
            _buildSocialButton(
              context,
              icon: FontAwesomeIcons.youtube,
              label: 'YouTube',
              color: const Color(0xFFFF0000),
              onTap: () => CustomLinks().lanzarUrl("https://www.youtube.com/channel/UCTjczNq199DwG-nIM9o6oQg"),
            ),
            const SizedBox(height: 16),
            _buildSocialButton(
              context,
              icon: FontAwesomeIcons.twitch,
              label: 'Twitch',
              color: const Color(0xFF9146FF),
              onTap: () => CustomLinks().lanzarUrl("https://www.twitch.tv/nohithispano"),
            ),
            const SizedBox(height: 16),
            _buildSocialButton(
              context,
              icon: FontAwesomeIcons.discord,
              label: 'Discord',
              color: const Color(0xFF5865F2),
              onTap: () => CustomLinks().lanzarUrl("https://discord.gg/BXrdaQXrCp"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              FaIcon(icon, color: color, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
