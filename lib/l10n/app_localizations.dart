import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @partidas.
  ///
  /// In es, this message translates to:
  /// **'{isEnabled, select, true {Partidas} false {Partida} other{Partidas}}'**
  String partidas(String isEnabled);

  /// No description provided for @jugadores.
  ///
  /// In es, this message translates to:
  /// **'{isEnabled, select, true {Jugadores} false {Jugador} other{Jugadores}}'**
  String jugadores(String isEnabled);

  /// No description provided for @juegos.
  ///
  /// In es, this message translates to:
  /// **'{isEnabled, select, true {Juegos} false {Juego} other{Juegos}}'**
  String juegos(String isEnabled);

  /// No description provided for @preguntas_frecuentes.
  ///
  /// In es, this message translates to:
  /// **'Preguntas frecuentes'**
  String get preguntas_frecuentes;

  /// No description provided for @team_hitless.
  ///
  /// In es, this message translates to:
  /// **'Team hitless'**
  String get team_hitless;

  /// No description provided for @tipo_juego.
  ///
  /// In es, this message translates to:
  /// **'{isEnabled, select, true {Oficial} false {No oficial} other{No oficial}}'**
  String tipo_juego(String isEnabled);

  /// No description provided for @juego_sin_jugadores.
  ///
  /// In es, this message translates to:
  /// **'El juego no cuenta con jugadores registradas'**
  String get juego_sin_jugadores;

  /// No description provided for @ultimo_jugador.
  ///
  /// In es, this message translates to:
  /// **'Ultimo jugador'**
  String get ultimo_jugador;

  /// No description provided for @juego_sin_partidas.
  ///
  /// In es, this message translates to:
  /// **'El juego no cuenta con partidas registradas'**
  String get juego_sin_partidas;

  /// No description provided for @primera_partida.
  ///
  /// In es, this message translates to:
  /// **'Primera {isEnabled, select, true {y única} false {} other{}} partida'**
  String primera_partida(String isEnabled);

  /// No description provided for @jugadores_nuevos.
  ///
  /// In es, this message translates to:
  /// **'Jugadores nuevos'**
  String get jugadores_nuevos;

  /// No description provided for @informacion_partida.
  ///
  /// In es, this message translates to:
  /// **'Información partida'**
  String get informacion_partida;

  /// No description provided for @es_primera_partida.
  ///
  /// In es, this message translates to:
  /// **'¿Primera Partida?'**
  String get es_primera_partida;

  /// No description provided for @hispano.
  ///
  /// In es, this message translates to:
  /// **'Hispano'**
  String get hispano;

  /// No description provided for @mundial.
  ///
  /// In es, this message translates to:
  /// **'Mundial'**
  String get mundial;

  /// No description provided for @ultimas_partidas.
  ///
  /// In es, this message translates to:
  /// **'Ultimas Partidas'**
  String get ultimas_partidas;

  /// No description provided for @ultima_partida.
  ///
  /// In es, this message translates to:
  /// **'Ultima Partida'**
  String get ultima_partida;

  /// No description provided for @jugador_sin_informacion.
  ///
  /// In es, this message translates to:
  /// **'Jugador sin información'**
  String get jugador_sin_informacion;

  /// No description provided for @informacion_jugador.
  ///
  /// In es, this message translates to:
  /// **'Información Jugador'**
  String get informacion_jugador;

  /// No description provided for @consultando_partidas.
  ///
  /// In es, this message translates to:
  /// **'Consultando las partidas del juego seleccionado'**
  String get consultando_partidas;

  /// No description provided for @fecha_partida.
  ///
  /// In es, this message translates to:
  /// **'Fecha partida'**
  String get fecha_partida;

  /// No description provided for @nombre_partida.
  ///
  /// In es, this message translates to:
  /// **'Nombre partida'**
  String get nombre_partida;

  /// No description provided for @consultando_ultimas_partidas.
  ///
  /// In es, this message translates to:
  /// **'Consultando ultimas partidas'**
  String get consultando_ultimas_partidas;

  /// No description provided for @ingrese_usuario.
  ///
  /// In es, this message translates to:
  /// **'Ingrese un nombre de usuario'**
  String get ingrese_usuario;

  /// No description provided for @ingrese_juego.
  ///
  /// In es, this message translates to:
  /// **'Ingrese el nombre de un videojuego'**
  String get ingrese_juego;

  /// No description provided for @buscar_jugador.
  ///
  /// In es, this message translates to:
  /// **'Buscar jugador'**
  String get buscar_jugador;

  /// No description provided for @buscar_juego.
  ///
  /// In es, this message translates to:
  /// **'Buscar juego'**
  String get buscar_juego;

  /// No description provided for @aplicacion.
  ///
  /// In es, this message translates to:
  /// **'Aplicación'**
  String get aplicacion;

  /// No description provided for @proyecto_codigo_abierto.
  ///
  /// In es, this message translates to:
  /// **'Proyecto de código abierto'**
  String get proyecto_codigo_abierto;

  /// No description provided for @app_version.
  ///
  /// In es, this message translates to:
  /// **'Numero de version'**
  String get app_version;

  /// No description provided for @numero_construccion.
  ///
  /// In es, this message translates to:
  /// **'Numero construcción'**
  String get numero_construccion;

  /// No description provided for @github.
  ///
  /// In es, this message translates to:
  /// **'Github'**
  String get github;

  /// No description provided for @google_play.
  ///
  /// In es, this message translates to:
  /// **'Google play'**
  String get google_play;

  /// No description provided for @twitter.
  ///
  /// In es, this message translates to:
  /// **'Twitter'**
  String get twitter;

  /// No description provided for @comunidad.
  ///
  /// In es, this message translates to:
  /// **'Comunidad'**
  String get comunidad;

  /// No description provided for @youtube.
  ///
  /// In es, this message translates to:
  /// **'YouTube'**
  String get youtube;

  /// No description provided for @twitch.
  ///
  /// In es, this message translates to:
  /// **'Twitch'**
  String get twitch;

  /// No description provided for @discord.
  ///
  /// In es, this message translates to:
  /// **'Discord'**
  String get discord;

  /// No description provided for @comunidad_hispano.
  ///
  /// In es, this message translates to:
  /// **'Comunidad no hit hispanohablante'**
  String get comunidad_hispano;

  /// No description provided for @desarrollador.
  ///
  /// In es, this message translates to:
  /// **'Desarrollador'**
  String get desarrollador;

  /// No description provided for @correo_electronico.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get correo_electronico;

  /// No description provided for @instagram.
  ///
  /// In es, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @paypal.
  ///
  /// In es, this message translates to:
  /// **'PayPal'**
  String get paypal;

  /// No description provided for @introduccion_1.
  ///
  /// In es, this message translates to:
  /// **'Aca encontraras las partidas, Jugadores y juegos registrados en la comunidad No Hit Hispanohablante.'**
  String get introduccion_1;

  /// No description provided for @introduccion_2.
  ///
  /// In es, this message translates to:
  /// **'Una partida No hit/hitless consiste en completar un juego de principio a fin sin recibir algún golpe de un enemigo o una trampa.'**
  String get introduccion_2;

  /// No description provided for @empezar.
  ///
  /// In es, this message translates to:
  /// **'Empezar'**
  String get empezar;

  /// No description provided for @lista_completa.
  ///
  /// In es, this message translates to:
  /// **'Lista completa'**
  String get lista_completa;

  /// No description provided for @jugadores_vacio.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron jugadores.'**
  String get jugadores_vacio;

  /// No description provided for @filtros.
  ///
  /// In es, this message translates to:
  /// **'Filtros'**
  String get filtros;

  /// No description provided for @nacionalidad.
  ///
  /// In es, this message translates to:
  /// **'Nacionalidad'**
  String get nacionalidad;

  /// No description provided for @generos.
  ///
  /// In es, this message translates to:
  /// **'Generos'**
  String get generos;

  /// No description provided for @limpiar_filtros.
  ///
  /// In es, this message translates to:
  /// **'Limpiar filtros'**
  String get limpiar_filtros;

  /// No description provided for @aplicar_filtros.
  ///
  /// In es, this message translates to:
  /// **'Aplicar filtros'**
  String get aplicar_filtros;

  /// No description provided for @favoritos.
  ///
  /// In es, this message translates to:
  /// **'Favoritos'**
  String get favoritos;

  /// No description provided for @guias.
  ///
  /// In es, this message translates to:
  /// **'Guias'**
  String get guias;

  /// No description provided for @jugadores_favoritos_vacio.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron jugadores marcados como favoritos.'**
  String get jugadores_favoritos_vacio;

  /// No description provided for @juegos_favoritos_vacio.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron juegos marcados como favoritos.'**
  String get juegos_favoritos_vacio;

  /// No description provided for @consultando_jugadores_favoritos.
  ///
  /// In es, this message translates to:
  /// **'Consultando jugadores favoritos'**
  String get consultando_jugadores_favoritos;

  /// No description provided for @consultando_juegos_favoritos.
  ///
  /// In es, this message translates to:
  /// **'Consultando juegos Favoritos'**
  String get consultando_juegos_favoritos;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
