import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:no_hit/config/contants/environment.dart';
import 'package:no_hit/config/router/app_router.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

late ColorScheme color;
late TextTheme styleTexto;
late Size size;

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await _definirVariablesEntorno();
  _definirLocalizacion();
  await _inicializarSupabase();
  timeDilation = 1.2;
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ref) {
    final AppTheme appTheme = ref.watch( themeNotifierProvider );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: appTheme.getTheme(),
      routerConfig: appRouter,
    );
  }
}

Future<void> _definirVariablesEntorno() async {
  await dotenv.load(fileName: '.env');
}

void _definirLocalizacion() {
  Intl.defaultLocale = 'es-CO';
  initializeDateFormatting('es-CO', null);
}

Future<void> _inicializarSupabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://${Environment.supabaseProyecto}',
    anonKey: Environment.supabaseApiKey,
  );
}
