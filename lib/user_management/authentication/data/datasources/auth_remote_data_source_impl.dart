import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/user.dart';
import '../../../../core/error/failures.dart';
import 'auth_remote_data_source.dart';
import '../services/google_sign_in_service.dart';
import '../services/supabase_service.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final GoogleSignInService googleSignInService;
  final SupabaseService supabaseService;
  final Logger logger = Logger();

  AuthRemoteDataSourceImpl({
    required this.googleSignInService,
    required this.supabaseService,
  });

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      logger.i('Starting Google Sign In process');
      await googleSignInService.signIn();
      logger.i('Google Sign In successful, checking Supabase sign-in status');

      final isSignedIn = supabaseService.isUserSignedIn();

      if (isSignedIn) {
        logger.i('User is signed in to Supabase, retrieving session');
        final session = supabaseService.getCurrentSession();
        if (session != null) {
          final user = User(
            id: session.user.id,
            name: session.user.userMetadata?['name'] ?? '',
            email: session.user.email!,
            // Add other user details as necessary
          );
          logger.i('User successfully retrieved from Supabase');
          return Right(user);
        } else {
          logger.e('Supabase session is null');
          return const Left(ServerFailure());
        }
      } else {
        logger.e('User is not signed in to Supabase');
        return const Left(ServerFailure());
      }
    } catch (error) {
      logger.e('Error signing in with Google: $error');
      return const Left(ServerFailure());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await googleSignInService.signOut();
      await supabaseService.signOut();
      logger.i('User signed out successfully');
    } catch (error) {
      logger.e('Error signing out: $error');
      rethrow;
    }
  }

  @override
  Future<bool> isUserSignedIn() async {
    return supabaseService.isUserSignedIn();
  }
}
