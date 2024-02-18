import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:no_hit/main.dart';
import 'package:no_hit/presentation/views/inicio/inicio_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Comunidad extends StatelessWidget {
  static const nombre = 'comunidad-screen';
  const Comunidad({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
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
                title: const Text("Comunidad"),
              ),
              body: contenido(context, snapshot),
            ),
          );
        },
      ),
    );
  }

  Widget contenido(BuildContext context, AsyncSnapshot snapshot) {
    final TextTheme styleTexto = Theme.of(context).textTheme;
    final ColorScheme color = Theme.of(context).colorScheme;
    // final Size size = MediaQuery.of(context).size;
    if (snapshot.hasError) {
      return Center(
        child: Text(snapshot.error.toString()),
      );
    } else if (snapshot.hasData) {
      PackageInfo packageInfo = snapshot.data!;
      return SizedBox(
        height: size.height,
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Image.asset(
                "assets/images/comunidadNoHit.png",
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Comunidad no hit hispanohablante",
              style: styleTexto.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(FontAwesomeIcons.twitter),
              title: const Text("Twitter"),
              contentPadding: const EdgeInsets.symmetric(horizontal: 50),
              textColor: Colors.white,
              onTap: () => CustomLinks().lanzarUrl("https://twitter.com/NoHitHispano"),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Divider(),
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.youtube),
              title: const Text("Youtube"),
              contentPadding: const EdgeInsets.symmetric(horizontal: 50),
              textColor: Colors.white,
              onTap: () => CustomLinks().lanzarUrl("https://www.youtube.com/channel/UCTjczNq199DwG-nIM9o6oQg"),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Divider(),
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.twitch),
              title: const Text("Twitch"),
              contentPadding: const EdgeInsets.symmetric(horizontal: 50),
              textColor: Colors.white,
              onTap: () => CustomLinks().lanzarUrl("https://www.twitch.tv/nohithispano"),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Divider(),
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.discord),
              title: const Text("Discord"),
              contentPadding: const EdgeInsets.symmetric(horizontal: 50),
              textColor: Colors.white,
              onTap: () => CustomLinks().lanzarUrl("https://discord.gg/BXrdaQXrCp"),
            ),
          ],
        ),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  item(String name, String? value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          if (value != null) const SizedBox(height: 10),
          if (value != null)
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
