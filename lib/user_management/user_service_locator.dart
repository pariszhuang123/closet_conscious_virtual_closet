import 'package:get_it/get_it.dart';

import 'authentication/data/repositories/authentication_repository_impl.dart';
import 'authentication/data/services/google_sign_in_service.dart';
import 'authentication/data/services/apple_sign_in_service.dart';
import 'authentication/data/services/supabase_service.dart';

import 'authentication/domain/repositories/authentication_repository.dart';

import 'authentication/application/usecases/sign_in_with_google.dart';
import 'authentication/application/usecases/sign_in_with_apple.dart';
import 'authentication/application/usecases/get_current_user.dart';
import 'authentication/application/usecases/sign_out.dart';
import 'authentication/application/usecases/delete_user_account.dart';

import 'authentication/presentation/bloc/auth_bloc.dart';

import 'core/data/services/user_fetch_service.dart';
import 'user_update/presentation/bloc/version_bloc.dart';

GetIt locator = GetIt.instance;

void setupUserManagementLocator() {
  // Services
  locator.registerLazySingleton<GoogleSignInService>(() => GoogleSignInService());
  locator.registerLazySingleton<SupabaseService>(() => SupabaseService());
  locator.registerLazySingleton<AppleSignInService>(
          () => AppleSignInService(supabaseClient: locator<SupabaseService>().supabaseClient));

  // Repository
  locator.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(
        googleSignInService: locator<GoogleSignInService>(),
        supabaseService: locator<SupabaseService>(),
            appleSignInService: locator<AppleSignInService>(),
      ));

  // Use Cases
  locator.registerLazySingleton(() => SignInWithGoogle(locator()));
  locator.registerLazySingleton(() => SignInWithApple(locator()));
  locator.registerLazySingleton(() => GetCurrentUser(locator()));
  locator.registerLazySingleton(() => SignOut(locator()));
  locator.registerLazySingleton(() => DeleteUserAccount(locator()));
  // Blocs
  locator.registerLazySingleton(() => AuthBloc(
    signInWithGoogle: locator(),
    signInWithApple: locator(),
    getCurrentUser: locator(),
    signOut: locator(),
    deleteUserAccount: locator(),
  ));

  // User fetch service (which now also handles version checking)
  locator.registerLazySingleton(() => UserFetchSupabaseService());

  // VersionBloc, which uses the UserFetchSupabaseService
  locator.registerLazySingleton(() => VersionBloc(locator<UserFetchSupabaseService>()));
}
