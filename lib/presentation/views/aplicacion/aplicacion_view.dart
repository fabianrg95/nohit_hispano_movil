import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:no_hit/main.dart';
import 'package:no_hit/presentation/views/inicio/inicio_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Aplicacion extends StatelessWidget {
  static const nombre = 'aplicacion-screen';
  const Aplicacion({super.key});

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
                title: const Text("Aplicación"),
              ),
              body: contenido(context, snapshot),
            ),
          );
        },
      ),
    );
  }

  Widget contenido(BuildContext context, AsyncSnapshot snapshot) {
    // final TextTheme styleTexto = Theme.of(context).textTheme;
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
                'assets/images/panel_${color.brightness == Brightness.dark ? 'blanco' : 'negro'}.png',
                width: 200,
                height: 200,
              ),
            ),
            item('Proyecto de código abierto', null),
            item('App Version', packageInfo.version),
            item('Build Number', packageInfo.buildNumber),
            ListTile(
              leading: const Icon(FontAwesomeIcons.github),
              title: const Text("Github"),
              contentPadding: const EdgeInsets.symmetric(horizontal: 50),
              textColor: Colors.white,
              onTap: () => CustomLinks().lanzarUrl("https://github.com/fabianrg95/nohit_hispano_movil"),
            ),
            /* ToDo agregar la redireccion a la tienda de apple */
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Divider(),
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.googlePlay),
              title: const Text("Google play"),
              contentPadding: const EdgeInsets.symmetric(horizontal: 50),
              textColor: Colors.white,
              onTap: () => CustomLinks().lanzarUrl("https://play.google.com/store/apps/details?id=com.fabianrodriguez.nohit.hispano"),
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
