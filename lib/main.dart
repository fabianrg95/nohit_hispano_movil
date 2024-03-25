import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:no_hit/config/contants/environment.dart';
import 'package:no_hit/config/router/app_router.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:no_hit/infraestructure/enums/enums.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

late TextTheme styleTexto;
late Size size;

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await _definirVariablesEntorno();
  await _inicializarSupabase();
  await _inicializarStorageLocal();
  runApp(const ProviderScope(child: MyApp()));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    ref.read(themeNotifierProvider.notifier).cargarTemaSeleccionado();
    ref.read(introduccionProvider.notifier).cargarIntroduccionFinalizada();
    ref.read(nacionalidadProvider.notifier).loadData();
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = ref.watch(themeNotifierProvider);
    styleTexto = Theme.of(context).textTheme;
    size = MediaQuery.of(context).size;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: appTheme.getTheme(),
      routerConfig: appRouter,
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
      ],
    );
  }
}

Future<void> _definirVariablesEntorno() async {
  await dotenv.load(fileName: '.env');
}

Future<void> _inicializarSupabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://${Environment.supabaseProyecto}',
    anonKey: Environment.supabaseApiKey,
  );
}

Future<void> _inicializarStorageLocal() async {
  for (var almacenamiento in BoxLocal.values) {
    await GetStorage.init(almacenamiento.nombreAlmacenamiento);
  }
}
