import 'package:flutter/material.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/dto/juego/juego_dto.dart';
import 'package:no_hit/main.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class CardJuego extends StatelessWidget {
  final JuegoDto juego;
  final Function? accion;
  final bool animarImagen;
  final double tamanio;
  final bool posicionInversa;
  const CardJuego({super.key, required this.juego, this.accion, this.animarImagen = true, this.tamanio = 170, this.posicionInversa = false});

  @override
  Widget build(BuildContext context) {
    if (accion != null) {
      return GestureDetector(
        onTap: () => accion!(),
        child: _itemJuego(juego: juego, tamanio: tamanio, inversa: posicionInversa),
      );
    } else {
      return _itemJuego(juego: juego, tamanio: tamanio, inversa: posicionInversa);
    }
  }
}

Widget _itemJuego({required final JuegoDto juego, required final double tamanio, required final bool inversa}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: SizedBox(
      height: tamanio + 10,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: inversa == true ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            mainAxisAlignment: inversa == true ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              const Expanded(flex: 1, child: SizedBox(height: 1)),
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
                  child: Column(
                    crossAxisAlignment: inversa == true ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                    mainAxisAlignment: inversa == true ? MainAxisAlignment.start : MainAxisAlignment.end,
                    children: [
                      Text(
                        juego.nombre,
                        style: styleTexto.titleMedium,
                        textAlign: inversa == true ? TextAlign.start : TextAlign.end,
                      ),
                      Visibility(
                          visible: juego.subtitulo.toString().toLowerCase() != 'null',
                          child: Text(juego.subtitulo.toString(),
                              style: styleTexto.bodySmall, textAlign: inversa == true ? TextAlign.start : TextAlign.end))
                    ],
                  )),
            ],
          ),
          Align(
            alignment: inversa == true ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Hero(
                tag: juego.nombre + (juego.subtitulo == null ? juego.subtitulo.toString() : juego.id.toString()),
                child: ImagenJuego(
                  juego: juego.nombre,
                  urlImagen: juego.urlImagen,
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
