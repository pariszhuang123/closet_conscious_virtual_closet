import '../../domain/repositories/authentication_repository.dart';

class DeleteUserAccount {
  final AuthRepository repository;

  DeleteUserAccount(this.repository);

  Future<void> call(String userId) async {
    await repository.deleteUserFolderAndAccount(userId);
  }
}
