import 'package:dartz/dartz.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user.dart';

class SignInWithGoogle extends UseCase<User, NoParams> {
  final AuthenticationRepository repository;

  SignInWithGoogle(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    try {
      final either = await repository.signInWithGoogle();
      return either.fold(
            (failure) => Left(failure),
            (user) => Right(user),
      );
    } catch (error) {
      return const Left(ServerFailure());
    }
  }
}




