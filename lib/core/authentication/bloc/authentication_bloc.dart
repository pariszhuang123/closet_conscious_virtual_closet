import 'package:bloc/bloc.dart';
import 'package:closet_conscious/core/authentication/services/google_sign_in_service.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final GoogleSignInService _googleSignInService;

  AuthenticationBloc(
      this._googleSignInService,
      ) : super(AuthenticationInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onGoogleSignInRequested(
      GoogleSignInRequested event,
      Emitter<AuthenticationState> emit,
      ) async {
    emit(AuthenticationLoading());
    try {
      await _googleSignInService.signIn();
      emit(AuthenticationSuccess());
    } catch (e) {
      emit(AuthenticationFailure(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
      SignOutRequested event,
      Emitter<AuthenticationState> emit,
      ) async {
    emit(AuthenticationLoading());
    try {
      await _googleSignInService.signOut();
      emit(AuthenticationInitial());
    } catch (e) {
      emit(AuthenticationFailure(e.toString()));
    }
  }
}
