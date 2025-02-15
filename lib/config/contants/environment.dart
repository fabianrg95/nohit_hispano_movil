import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String supabaseProyecto =
      dotenv.env['supabase_proyect'] ?? 'no hay proyecto de supabase';
  static String supabaseApiKey =
      dotenv.env['supabase_api_key'] ?? 'no hay apikey de supabase';
}
