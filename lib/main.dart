import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:no_hit/config/contants/environment.dart';
import 'package:no_hit/config/router/app_router.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await _definirVariablesEntorno();
  _definirLocalizacion();
  await _inicializarSupabase();
  timeDilation = 1.2;
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      routerConfig: appRouter,
    );
  }
}

Future<String> consultar() async {
  final supabase = Supabase.instance.client;
  final juegos = await supabase.from('juegos').select('*');
  return juegos.toString();
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
