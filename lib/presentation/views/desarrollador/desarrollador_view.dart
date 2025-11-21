import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';

import 'package:no_hit/presentation/views/inicio/inicio_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';

class Desarrollador extends StatelessWidget {
  static const nombre = 'desarrollador-screen';
  const Desarrollador({super.key});

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
            title: Text(AppLocalizations.of(context)!.desarrollador),
            centerTitle: true,
          ),
          body: contenido(context),
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.tertiary),
      title: Text(title),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
  }

  Widget contenido(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final JugadorDto jugadorDto = JugadorDto(
      id: 148,
      anioNacimiento: "1995",
      codigoBandera: "co",
      pronombre: "He/Him",
      nacionalidad: "Colombiano",
    )
      ..mostrarInformacion = true
      ..gentilicio = "Colombiano";

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'fabian.rg0801@gmail.com',
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Section
          Card(
            elevation: 4,
            color: colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Profile Image
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.primary,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        "assets/images/foto.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Name
                  Text(
                    "Fabian Rodriguez",
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Title/Role
                  Text(
                    'Mobile Developer',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Contact Card
          Card(
            elevation: 4,
            color: colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Email
                _buildListTile(
                  context,
                  icon: FontAwesomeIcons.envelope,
                  title: AppLocalizations.of(context)!.correo_electronico,
                  onTap: () => launchUrl(emailLaunchUri),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                // GitHub
                _buildListTile(
                  context,
                  icon: FontAwesomeIcons.github,
                  title: 'GitHub',
                  onTap: () => CustomLinks().lanzarUrl("https://github.com/fabianrg95"),
                ),
                // Add more contact options here as needed
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Social Media Card
          Card(
            elevation: 4,
            color: colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Instagram
                _buildListTile(
                  context,
                  icon: FontAwesomeIcons.instagram,
                  title: AppLocalizations.of(context)!.instagram,
                  onTap: () => CustomLinks().lanzarUrl("https://www.instagram.com/fabiancho.r"),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                // Twitch
                _buildListTile(
                  context,
                  icon: FontAwesomeIcons.twitch,
                  title: AppLocalizations.of(context)!.twitch,
                  onTap: () => CustomLinks().lanzarUrl("https://www.twitch.tv/fabiancho13"),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                // Discord
                _buildListTile(
                  context,
                  icon: FontAwesomeIcons.discord,
                  title: AppLocalizations.of(context)!.discord,
                  onTap: () => CustomLinks().lanzarUrl("https://discord.gg/pDmvE2TSp9"),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                // YouTube
                _buildListTile(
                  context,
                  icon: FontAwesomeIcons.youtube,
                  title: AppLocalizations.of(context)!.youtube,
                  onTap: () => CustomLinks().lanzarUrl("https://www.youtube.com/channel/UC1jyPT2CCXnUs8k11UWVjyQ"),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                // PayPal
                _buildListTile(
                  context,
                  icon: FontAwesomeIcons.paypal,
                  title: AppLocalizations.of(context)!.paypal,
                  onTap: () => CustomLinks().lanzarUrl("https://www.paypal.com/donate/?hosted_button_id=88R47UE5XYDSQ"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Copyright
          Text(
            '© ${DateTime.now().year} Fabian Rodriguez',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
