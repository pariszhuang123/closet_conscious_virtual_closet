import 'package:get_it/get_it.dart';
import 'utilities/logger.dart';

final GetIt coreLocator = GetIt.instance;

void setupCoreServices() {
  // Registering the logger with a specific tag
  coreLocator.registerSingleton<CustomLogger>(CustomLogger('CoreLogger'), instanceName: 'CoreLogger');
  coreLocator.registerFactory(() => CustomLogger('OutfitWearBloc'), instanceName: 'OutfitWearBlocLogger');
  coreLocator.registerFactory(() => CustomLogger('MainCommonLogger'), instanceName: 'MainCommonLogger');
  coreLocator.registerFactory(() => CustomLogger('OutfitReviewBlocLogger'), instanceName: 'OutfitReviewBlocLogger');
  coreLocator.registerFactory(() => CustomLogger('OutfitReviewContainerLogger'), instanceName: 'OutfitReviewContainerLogger');
  coreLocator.registerFactory(() => CustomLogger('OutfitWearViewLogger'), instanceName: 'OutfitWearViewLogger');
  coreLocator.registerFactory(() => CustomLogger('OutfitsFetchServiceLogger'), instanceName: 'OutfitsFetchServiceLogger');
  coreLocator.registerFactory(() => CustomLogger('OutfitReviewViewLogger'), instanceName: 'OutfitReviewViewLogger');
  coreLocator.registerFactory(() => CustomLogger('OutfitSaveServiceLogger'), instanceName: 'OutfitSaveServiceLogger');
  coreLocator.registerFactory(() => CustomLogger('OutfitSaveServiceLogger'), instanceName: 'CreateOutfitItemBlocLogger');

}
