import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:no_hit/infraestructure/dto/jugador/jugador_dto.dart';
import 'package:no_hit/presentation/views/inicio/inicio_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
            title: const Text("Desarrollador"),
          ),
          body: contenido(context),
        ),
      ),
    );
  }

  Widget contenido(BuildContext context) {
    final TextTheme styleTexto = Theme.of(context).textTheme;
    final ColorScheme color = Theme.of(context).colorScheme;
    final Size size = MediaQuery.of(context).size;

    JugadorDto jugadorDto = JugadorDto(
      id: 148,
      anioNacimiento: "1995",
      codigoBandera: "co",
      pronombre: "He/they",
      nacionalidad: "Colombiano",
    );
    jugadorDto.mostrarInformacion = true;
    jugadorDto.gentilicio = "Colombiano";

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'fabian.rg0801@gmail.com',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
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
        JugadorCommons().informacionJugadorLite(jugadorDto),
        const SizedBox(height: 20),
        ListTile(
            leading: const Icon(FontAwesomeIcons.envelope),
            title: const Text("Correo electrónico"),
            contentPadding: const EdgeInsets.symmetric(horizontal: 50),
            textColor: Colors.white,
            onTap: () => /*To do arreglar para ios */
                launchUrl(emailLaunchUri)),
        ListTile(
          leading: const Icon(FontAwesomeIcons.github),
          title: const Text("Github"),
          contentPadding: const EdgeInsets.symmetric(horizontal: 50),
          textColor: Colors.white,
          onTap: () => CustomLinks().lanzarUrl("https://github.com/fabianrg95"),
        ),
        ListTile(
          leading: const Icon(FontAwesomeIcons.instagram),
          title: const Text("Instagram"),
          contentPadding: const EdgeInsets.symmetric(horizontal: 50),
          textColor: Colors.white,
          onTap: () => CustomLinks().lanzarUrl("https://www.instagram.com/fabiancho.r"),
        ),
        ListTile(
          leading: const Icon(FontAwesomeIcons.twitch),
          title: const Text("Twitch"),
          contentPadding: const EdgeInsets.symmetric(horizontal: 50),
          textColor: Colors.white,
          onTap: () => CustomLinks().lanzarUrl("https://www.twitch.tv/fabiancho13"),
        ),
        ListTile(
          leading: const Icon(FontAwesomeIcons.youtube),
          title: const Text("Youtube"),
          contentPadding: const EdgeInsets.symmetric(horizontal: 50),
          textColor: Colors.white,
          onTap: () => CustomLinks().lanzarUrl("https://www.youtube.com/channel/UC1jyPT2CCXnUs8k11UWVjyQ"),
        ),
        const Expanded(flex: 1, child: SizedBox(height: 1))
      ],
    );
  }
}
