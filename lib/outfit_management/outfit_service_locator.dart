import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/data/services/outfits_fetch_services.dart';
import 'core/data/services/outfits_save_services.dart';

final GetIt getIt = GetIt.instance;

void setupOutfitLocator() {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  getIt.registerLazySingleton<SupabaseClient>(() => supabaseClient);

  // Fix: Use named parameter syntax for OutfitFetchService
  getIt.registerLazySingleton<OutfitFetchService>(
          () => OutfitFetchService(client: supabaseClient));

  // This one is already correct
  getIt.registerLazySingleton<OutfitSaveService>(
          () => OutfitSaveService(client: supabaseClient));
}
