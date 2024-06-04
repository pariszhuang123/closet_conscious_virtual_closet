import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/usecases/sign_in_with_google.dart';
import '../../application/usecases/get_current_user.dart';
import '../../application/usecases/sign_out.dart';
import '../../domain/entities/user.dart';

abstract class AuthEvent {}

class SignInEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

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

  AuthBloc({
    required SignInWithGoogle signInWithGoogle,
    required GetCurrentUser getCurrentUser,
    required SignOut signOut,
  })  : _signInWithGoogle = signInWithGoogle,
        _getCurrentUser = getCurrentUser,
        _signOut = signOut,
        super(Unauthenticated()) {

    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      final user = await _signInWithGoogle();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });

    on<SignOutEvent>((event, emit) async {
      emit(AuthLoading());
      await _signOut();
      emit(Unauthenticated());
    });

    on<CheckAuthStatusEvent>((event, emit) async { // Handle the new event
      final user = _getCurrentUser();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });
  }
}
