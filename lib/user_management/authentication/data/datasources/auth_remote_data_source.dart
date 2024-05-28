import '../../domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, User>> signInWithGoogle();
  Future<void> signOut();
  Future<bool> isUserSignedIn();
}
