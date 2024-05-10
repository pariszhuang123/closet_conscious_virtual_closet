import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, void>> signOut();

  // Sign in or sign up with Google
  Future<Either<Failure, User>> signInWithGoogle();
}

