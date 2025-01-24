import 'package:get_it/get_it.dart';
import 'core/data/services/item_fetch_service.dart';
import 'core/data/services/item_save_service.dart';

final GetIt itemLocator = GetIt.instance;

void setupItemLocator() {
  // Registering the logger with a specific tag
  itemLocator.registerLazySingleton(() => ItemFetchService());
  itemLocator.registerLazySingleton(() => ItemSaveService());

}
