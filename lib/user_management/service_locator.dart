import 'package:get_it/get_it.dart';
import 'authentication/data/services/google_sign_in_service.dart';
import 'authentication/presentation/bloc/authentication_bloc.dart';

final GetIt locator = GetIt.instance;

void setupUserManagementLocator() {
  // Services
  locator.registerLazySingleton<GoogleSignInService>(() => GoogleSignInService());

  // Blocs
  locator.registerFactory(() => AuthenticationBloc(locator<GoogleSignInService>()));
}
