import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../application/usecases/sign_in_with_google.dart';
import '../../application/usecases/sign_out.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SignInWithGoogle signInWithGoogle;
  final SignOut signOut;

  AuthenticationBloc({
    required this.signInWithGoogle,
    required this.signOut,
  }) : super(AuthenticationInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onGoogleSignInRequested(
      GoogleSignInRequested event,
      Emitter<AuthenticationState> emit,
      ) async {
    emit(AuthenticationLoading());
    final result = await signInWithGoogle(NoParams());
    result.fold(
          (failure) => emit(AuthenticationFailure(failure.toString())),
          (user) => emit(AuthenticationSuccess(user)),
    );
  }

  Future<void> _onSignOutRequested(
      SignOutRequested event,
      Emitter<AuthenticationState> emit,
      ) async {
    emit(AuthenticationLoading());
    final result = await signOut(NoParams());
    result.fold(
          (failure) => emit(AuthenticationFailure(failure.toString())),
          (_) => emit(AuthenticationInitial()),
    );
  }
}
