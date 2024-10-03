import 'package:get_it/get_it.dart';
import 'utilities/logger.dart';
import 'data/services/core_fetch_services.dart';
import 'data/services/core_save_services.dart';

final GetIt coreLocator = GetIt.instance;

void setupCoreServices() {
  // Registering the logger with a specific tag
  coreLocator.registerSingleton<CustomLogger>(CustomLogger('CoreLogger'), instanceName: 'CoreLogger');

  coreLocator.registerFactory(() => CustomLogger('MainCommonLogger'), instanceName: 'MainCommonLogger');

  coreLocator.registerLazySingleton(() => CoreFetchService('your_bucket_name'));  // Register CoreFetchService
  coreLocator.registerLazySingleton(() => CoreSaveService());  // Register CoreSaveService

}
