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
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, __, ___) => const InicioView()));
      },
      child: SafeArea(
        child: Scaffold(
          drawer: const CustomNavigation(),
          appBar: AppBar(
            forceMaterialTransparency: true,
            title: Text(AppLocalizations.of(context)!.desarrollador),
          ),
          body: contenido(context),
        ),
      ),
    );
  }

  Widget contenido(BuildContext context) {
    final TextTheme styleTexto = Theme.of(context).textTheme;
    // final ColorScheme color = Theme.of(context).colorScheme;
    final Size size = MediaQuery.of(context).size;

    JugadorDto jugadorDto = JugadorDto(
      id: 148,
      anioNacimiento: "1995",
      codigoBandera: "co",
      pronombre: "He/Him",
      nacionalidad: "Colombiano",
    );
    jugadorDto.mostrarInformacion = true;
    jugadorDto.gentilicio = "Colombiano";

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'fabian.rg0801@gmail.com',
    );

    return SizedBox(
      height: size.height,
      child: ListView(
        shrinkWrap: true,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: Image.asset(
                "assets/images/foto.jpeg",
                width: 200,
                height: 200,
              ),
            ),
          ),
          Text(
            "Fabian Rodriguez",
            style: styleTexto.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          JugadorCommons().informacionJugadorLite(jugadorDto, context),
          const SizedBox(height: 20),
          ListTile(
              leading: const Icon(FontAwesomeIcons.envelope),
              title: Text(AppLocalizations.of(context)!.correo_electronico),
              contentPadding: const EdgeInsets.symmetric(horizontal: 50),
              textColor: Colors.white,
              onTap: () => /*To do arreglar para ios */
                  launchUrl(emailLaunchUri)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Divider(),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.github),
            title: Text(AppLocalizations.of(context)!.github),
            contentPadding: const EdgeInsets.symmetric(horizontal: 50),
            textColor: Colors.white,
            onTap: () => CustomLinks().lanzarUrl("https://github.com/fabianrg95"),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Divider(),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.instagram),
            title: Text(AppLocalizations.of(context)!.instagram),
            contentPadding: const EdgeInsets.symmetric(horizontal: 50),
            textColor: Colors.white,
            onTap: () => CustomLinks().lanzarUrl("https://www.instagram.com/fabiancho.r"),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Divider(),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.twitch),
            title: Text(AppLocalizations.of(context)!.twitch),
            contentPadding: const EdgeInsets.symmetric(horizontal: 50),
            textColor: Colors.white,
            onTap: () => CustomLinks().lanzarUrl("https://www.twitch.tv/fabiancho13"),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Divider(),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.discord),
            title: Text(AppLocalizations.of(context)!.discord),
            contentPadding: const EdgeInsets.symmetric(horizontal: 50),
            textColor: Colors.white,
            onTap: () => CustomLinks().lanzarUrl("https://discord.gg/pDmvE2TSp9"),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Divider(),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.youtube),
            title: Text(AppLocalizations.of(context)!.youtube),
            contentPadding: const EdgeInsets.symmetric(horizontal: 50),
            textColor: Colors.white,
            onTap: () => CustomLinks().lanzarUrl("https://www.youtube.com/channel/UC1jyPT2CCXnUs8k11UWVjyQ"),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Divider(),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.paypal),
            title: Text(AppLocalizations.of(context)!.paypal),
            contentPadding: const EdgeInsets.symmetric(horizontal: 50),
            textColor: Colors.white,
            onTap: () => CustomLinks().lanzarUrl("https://www.paypal.com/donate/?hosted_button_id=88R47UE5XYDSQ"),
          )
        ],
      ),
    );
  }
}
