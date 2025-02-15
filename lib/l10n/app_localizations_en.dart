// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String partidas(String isEnabled) {
    String _temp0 = intl.Intl.selectLogic(
      isEnabled,
      {
        'true': 'Partidas',
        'false': 'Partida',
        'other': 'Partidas',
      },
    );
    return '$_temp0';
  }

  @override
  String jugadores(String isEnabled) {
    String _temp0 = intl.Intl.selectLogic(
      isEnabled,
      {
        'true': 'Jugadores',
        'false': 'Jugador',
        'other': 'Jugadores',
      },
    );
    return '$_temp0';
  }

  @override
  String juegos(String isEnabled) {
    String _temp0 = intl.Intl.selectLogic(
      isEnabled,
      {
        'true': 'Juegos',
        'false': 'Juego',
        'other': 'Juegos',
      },
    );
    return '$_temp0';
  }

  @override
  String get preguntas_frecuentes => 'Preguntas frecuentes';

  @override
  String get team_hitless => 'Team hitless';

  @override
  String tipo_juego(String isEnabled) {
    String _temp0 = intl.Intl.selectLogic(
      isEnabled,
      {
        'true': 'Oficial',
        'false': 'No oficial',
        'other': 'No oficial',
      },
    );
    return '$_temp0';
  }

  @override
  String get juego_sin_jugadores => 'El juego no cuenta con jugadores registradas';

  @override
  String get ultimo_jugador => 'Ultimo jugador';

  @override
  String get juego_sin_partidas => 'El juego no cuenta con partidas registradas';

  @override
  String primera_partida(String isEnabled) {
    String _temp0 = intl.Intl.selectLogic(
      isEnabled,
      {
        'true': 'y única',
        'false': '',
        'other': '',
      },
    );
    return 'Primera $_temp0 partida';
  }

  @override
  String get jugadores_nuevos => 'Jugadores nuevos';

  @override
  String get informacion_partida => 'Información partida';

  @override
  String get es_primera_partida => '¿Primera Partida?';

  @override
  String get hispano => 'Hispano';

  @override
  String get mundial => 'Mundial';

  @override
  String get ultimas_partidas => 'Ultimas Partidas';

  @override
  String get ultima_partida => 'Ultima Partida';

  @override
  String get jugador_sin_informacion => 'Jugador sin información';

  @override
  String get informacion_jugador => 'Información Jugador';

  @override
  String get consultando_partidas => 'Consultando las partidas del juego seleccionado';

  @override
  String get fecha_partida => 'Fecha partida';

  @override
  String get nombre_partida => 'Nombre partida';

  @override
  String get consultando_ultimas_partidas => 'Consultando ultimas partidas';

  @override
  String get ingrese_usuario => 'Ingrese un nombre de usuario';

  @override
  String get ingrese_juego => 'Ingrese el nombre de un videojuego';

  @override
  String get buscar_jugador => 'Buscar jugador';

  @override
  String get buscar_juego => 'Buscar juego';

  @override
  String get aplicacion => 'Aplicación';

  @override
  String get proyecto_codigo_abierto => 'Proyecto de código abierto';

  @override
  String get app_version => 'Numero de version';

  @override
  String get numero_construccion => 'Numero construcción';

  @override
  String get github => 'Github';

  @override
  String get google_play => 'Google play';

  @override
  String get twitter => 'Twitter';

  @override
  String get comunidad => 'Comunidad';

  @override
  String get youtube => 'YouTube';

  @override
  String get twitch => 'Twitch';

  @override
  String get discord => 'Discord';

  @override
  String get comunidad_hispano => 'Comunidad no hit hispanohablante';

  @override
  String get desarrollador => 'Desarrollador';

  @override
  String get correo_electronico => 'Correo electrónico';

  @override
  String get instagram => 'Instagram';

  @override
  String get paypal => 'PayPal';

  @override
  String get introduccion_1 => 'Aca encontraras las partidas, Jugadores y juegos registrados en la comunidad No Hit Hispanohablante.';

  @override
  String get introduccion_2 => 'Una partida No hit/hitless consiste en completar un juego de principio a fin sin recibir algún golpe de un enemigo o una trampa.';

  @override
  String get empezar => 'Empezar';

  @override
  String get lista_completa => 'Lista completa';

  @override
  String get jugadores_vacio => 'No se encontraron jugadores.';

  @override
  String get filtros => 'Filtros';

  @override
  String get nacionalidad => 'Nacionalidad';

  @override
  String get generos => 'Generos';

  @override
  String get limpiar_filtros => 'Limpiar filtros';

  @override
  String get aplicar_filtros => 'Aplicar filtros';

  @override
  String get favoritos => 'Favoritos';

  @override
  String get guias => 'Guias';

  @override
  String get jugadores_favoritos_vacio => 'No se encontraron jugadores marcados como favoritos.';

  @override
  String get juegos_favoritos_vacio => 'No se encontraron juegos marcados como favoritos.';

  @override
  String get consultando_jugadores_favoritos => 'Consultando jugadores favoritos';

  @override
  String get consultando_juegos_favoritos => 'Consultando juegos Favoritos';
}
