import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/datasources/local_storage_impl.dart';
import 'package:no_hit/infraestructure/datasources/supabase_datasource_impl.dart';
import 'package:no_hit/infraestructure/repositories/local_repository_impl.dart';
import 'package:no_hit/infraestructure/repositories/supabase_repository_impl.dart';

final hitlessRepositoryProvider = Provider((ref) {
  return SupabaseRepositoryImpl(SupabaseDatasourceImpl());
});

final localRepositoryProvider = Provider((ref) {
  return LocalRepositoryImpl(LocalStorageImpl());
});
