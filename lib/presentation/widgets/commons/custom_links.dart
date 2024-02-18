import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomLinks {
  Widget link(final String? url, final IconData icon, {final double tamanio = 30}) {
    return Visibility(
      visible: url != null,
      child: GestureDetector(
        onTap: () => lanzarUrl(url.toString()),
        child: Icon(icon, size: tamanio),
      ),
    );
  }

  Future<void> lanzarUrl(String url) async {
    final urlFinal = Uri.parse(url);
    if (!await launchUrl(urlFinal, mode: LaunchMode.externalApplication)) {
      if (!await launchUrl(urlFinal, mode: LaunchMode.inAppWebView)) {
        throw Exception('no puede ser lanzada la url $url');
      }
    }
  }
}
