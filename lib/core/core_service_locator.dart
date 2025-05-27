import 'package:get_it/get_it.dart';
import 'utilities/logger.dart';
import 'data/services/core_fetch_services.dart';
import 'data/services/core_save_services.dart';
import 'photo_library/usecase/photo_library_service.dart';

final GetIt coreLocator = GetIt.instance;

void setupCoreLocator() {
  // Registering the logger with a specific tag
  coreLocator.registerSingleton<CustomLogger>(CustomLogger('CoreLogger'), instanceName: 'CoreLogger');
  coreLocator.registerFactory(() => CustomLogger('MainCommonLogger'), instanceName: 'MainCommonLogger');

  coreLocator.registerLazySingleton(() => CoreFetchService());
  coreLocator.registerLazySingleton(() => CoreSaveService());

  coreLocator.registerLazySingleton<PhotoLibraryService>(
        () => PhotoLibraryService(coreLocator<CoreSaveService>()),
  );

}
