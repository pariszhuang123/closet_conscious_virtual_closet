import 'package:get_it/get_it.dart';
import 'data/datasources/network_info.dart';
import 'domain/repositories/connectivity_repository.dart';
import 'data/repositories/connectivity_repository_impl.dart';
import 'presentation/blocs/connectivity_bloc.dart';

final GetIt locator = GetIt.instance;

void setupConnectivityLocator() {
  // Services
  locator.registerLazySingleton(() => NetworkChecker());

  // Repositories
  locator.registerLazySingleton<ConnectivityRepository>(() =>
      ConnectivityRepositoryImpl(locator<NetworkChecker>()));

  // Blocs
  locator.registerFactory(() => ConnectivityBloc(locator<ConnectivityRepository>()));
}
