import 'package:get_it/get_it.dart';

import 'authentication/data/repositories/authentication_repository_impl.dart';
import 'authentication/data/services/google_sign_in_service.dart';
import 'authentication/data/services/supabase_service.dart';

import 'authentication/domain/repositories/authentication_repository.dart';

import 'authentication/application/usecases/sign_in_with_google.dart';
import 'authentication/application/usecases/get_current_user.dart';
import 'authentication/application/usecases/sign_out.dart';
import 'authentication/application/usecases/delete_user_account.dart';

import 'authentication/presentation/bloc/auth_bloc.dart';

GetIt locator = GetIt.instance;

void setupUserManagementLocator() {
  // Services
  locator.registerLazySingleton<GoogleSignInService>(() => GoogleSignInService());
  locator.registerLazySingleton<SupabaseService>(() => SupabaseService());

  // Repository
  locator.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(
        googleSignInService: locator<GoogleSignInService>(),
        supabaseService: locator<SupabaseService>(),
      ));

  // Use Cases
  locator.registerLazySingleton(() => SignInWithGoogle(locator()));
  locator.registerLazySingleton(() => GetCurrentUser(locator()));
  locator.registerLazySingleton(() => SignOut(locator()));
  locator.registerLazySingleton(() => DeleteUserAccount(locator()));
  // Blocs
  locator.registerLazySingleton(() => AuthBloc(
    signInWithGoogle: locator(),
    getCurrentUser: locator(),
    signOut: locator(),
    deleteUserAccount: locator(),
  ));
}
