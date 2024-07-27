import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/usecases/sign_in_with_google.dart';
import '../../application/usecases/get_current_user.dart';
import '../../application/usecases/sign_out.dart';
import '../../application/usecases/delete_user_account.dart';
import '../../domain/entities/user.dart';
import '../../../../core/utilities/logger.dart';


abstract class AuthEvent {}

class SignInEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

class DeleteAccountEvent extends AuthEvent {}

abstract class AuthState {}

class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class AuthLoading extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle _signInWithGoogle;
  final GetCurrentUser _getCurrentUser;
  final SignOut _signOut;
  final DeleteUserAccount _deleteUserAccount;
  final CustomLogger _logger = CustomLogger('AuthBloc');

  AuthBloc({
    required SignInWithGoogle signInWithGoogle,
    required GetCurrentUser getCurrentUser,
    required SignOut signOut,
    required DeleteUserAccount deleteUserAccount,
  })  : _signInWithGoogle = signInWithGoogle,
        _getCurrentUser = getCurrentUser,
        _signOut = signOut,
        _deleteUserAccount = deleteUserAccount,
      super(Unauthenticated()) {

    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      final user = await _signInWithGoogle();
      if (user != null) {
        _logger.i('User signed in: ${user.id}');
        emit(Authenticated(user));
      } else {
        _logger.w('Sign in failed');
        emit(Unauthenticated());
      }
    });

    on<SignOutEvent>((event, emit) async {
      emit(AuthLoading());
      await _signOut();
      _logger.i('User signed out');
      emit(Unauthenticated());
    });

    on<CheckAuthStatusEvent>((event, emit) async {
      final user = _getCurrentUser();
      if (user != null) {
        _logger.i('User is authenticated: ${user.id}');
        emit(Authenticated(user));
      } else {
        _logger.i('User is not authenticated');
        emit(Unauthenticated());
      }
    });

    on<DeleteAccountEvent>((event, emit) async {
      emit(AuthLoading());
      final user = _getCurrentUser();
      if (user != null) {
        final userId = user.id;
        try {
          // Log out the user to invalidate the current session
          await signOut();

          // Call the use case to delete the folder and user account
          await _deleteUserAccount(userId);

          _logger.i('User folder and account deleted successfully');
          emit(Unauthenticated());
        } catch (e) {
          _logger.e('Error deleting user folder and account: $e');
          emit(Authenticated(user)); // Revert to Authenticated state
        }
      } else {
        _logger.i('No user logged in');
        emit(Unauthenticated());
      }
    });
  }
}
