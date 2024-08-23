import 'package:fpdart/fpdart.dart';
import 'package:closet_conscious/core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
