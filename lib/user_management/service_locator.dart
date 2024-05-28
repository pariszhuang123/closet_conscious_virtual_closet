import 'package:get_it/get_it.dart';
import 'authentication/data/datasources/auth_remote_data_source.dart';
import 'authentication/data/datasources/auth_remote_data_source_impl.dart';
import 'authentication/data/repositories/authentication_repository_impl.dart';
import 'authentication/data/services/google_sign_in_service.dart';
import 'authentication/domain/repositories/authentication_repository.dart';
import 'authentication/application/usecases/sign_in_with_google.dart';
import 'authentication/application/usecases/sign_out.dart';
import 'authentication/presentation/bloc/authentication_bloc.dart';
import 'authentication/data/services/supabase_service.dart';

final GetIt locator = GetIt.instance;

void setupUserManagementLocator() {
  // Services
  locator.registerLazySingleton<GoogleSignInService>(() => GoogleSignInService());
  locator.registerLazySingleton<SupabaseService>(() => SupabaseService());

  // Data sources
  locator.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
          googleSignInService: locator<GoogleSignInService>(),
          supabaseService: locator<SupabaseService>(),
    ),
  );

  // Repository
  locator.registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImpl(remoteDataSource: locator()),
  );

  // Use Cases
  locator.registerLazySingleton(() => SignInWithGoogle(locator()));
  locator.registerLazySingleton(() => SignOut(locator()));

  // Blocs
  locator.registerFactory(() => AuthenticationBloc(
    signInWithGoogle: locator(),
    signOut: locator(),
  ));
}
