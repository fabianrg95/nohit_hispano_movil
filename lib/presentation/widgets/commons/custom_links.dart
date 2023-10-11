import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomLinks {
  Widget link(final String? url, final String urlImagen) {
    return Visibility(
      visible: url != null,
      child: GestureDetector(
        onTap: () => _lanzarUrl(url.toString()),
        child: Image.asset(urlImagen, width: 30, height: 30),
      ),
    );
  }

  Future<void> _lanzarUrl(String url) async {
    final urlFinal = Uri.parse(url);
    if (!await launchUrl(urlFinal, mode: LaunchMode.externalApplication)) {
      if (!await launchUrl(urlFinal, mode: LaunchMode.inAppWebView)) {
        throw Exception('no puede ser lanzada la url $url');
      }
    }
  }
}
