import 'package:get_it/get_it.dart';
import 'utilities/logger.dart';

final GetIt coreLocator = GetIt.instance;

void setupCoreServices() {
  // Registering the logger with a specific tag
  coreLocator.registerSingleton<CustomLogger>(CustomLogger('CoreLogger'), instanceName: 'CoreLogger');
  coreLocator.registerFactory(() => CustomLogger('OutfitWearBloc'), instanceName: 'OutfitWearBlocLogger');
  coreLocator.registerFactory(() => CustomLogger('MainCommonLogger'), instanceName: 'MainCommonLogger');
  coreLocator.registerFactory(() => CustomLogger('MainCommonLogger'), instanceName: 'OutfitReviewBlocLogger');
}
