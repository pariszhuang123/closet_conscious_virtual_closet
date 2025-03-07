import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/data/services/outfits_fetch_services.dart';
import 'core/data/services/outfits_save_services.dart';

final GetIt outfitLocator = GetIt.instance;

void setupOutfitLocator() {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  outfitLocator.registerLazySingleton<SupabaseClient>(() => supabaseClient);

  // Fix: Use named parameter syntax for OutfitFetchService
  outfitLocator.registerLazySingleton<OutfitFetchService>(
          () => OutfitFetchService(client: supabaseClient));

  // This one is already correct
  outfitLocator.registerLazySingleton<OutfitSaveService>(
          () => OutfitSaveService(client: supabaseClient));
}
