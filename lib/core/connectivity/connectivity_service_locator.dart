import 'package:get_it/get_it.dart';
import 'data/datasources/network_info.dart';
import 'domain/repositories/connectivity_repository.dart';
import 'data/repositories/connectivity_repository_impl.dart';
import 'presentation/blocs/connectivity_bloc.dart';
import 'application/connectivity_use_case.dart';

final GetIt locator = GetIt.instance;

void setupConnectivityLocator() {
  // Register the ConnectivityStreamController
  locator.registerLazySingleton<ConnectivityStreamController>(() => BroadcastStreamController());

  // Register NetworkChecker with a ConnectivityStreamController dependency
  locator.registerLazySingleton(() => NetworkChecker(locator<ConnectivityStreamController>()));

  // Repositories
  locator.registerLazySingleton<ConnectivityRepository>(() =>
      ConnectivityRepositoryImpl(locator<NetworkChecker>()));

  // Use Cases
  locator.registerLazySingleton(() => ConnectivityUseCase(locator<ConnectivityRepository>()));

  // Blocs
  locator.registerFactory(() => ConnectivityBloc(locator<ConnectivityUseCase>()));
}
