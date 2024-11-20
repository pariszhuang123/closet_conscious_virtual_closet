import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../application/usecases/sign_in_with_google.dart';
import '../../application/usecases/sign_in_with_apple.dart';
import '../../application/usecases/get_current_user.dart';
import '../../application/usecases/sign_out.dart';
import '../../application/usecases/delete_user_account.dart';
import '../../domain/entities/user.dart';
import '../../../../core/utilities/logger.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle _signInWithGoogle;
  final SignInWithApple _signInWithApple;
  final GetCurrentUser _getCurrentUser;
  final SignOut _signOut;
  final CustomLogger _logger = CustomLogger('AuthBloc');

  AuthBloc({
    required SignInWithGoogle signInWithGoogle,
    required SignInWithApple signInWithApple,
    required GetCurrentUser getCurrentUser,
    required SignOut signOut,
    required DeleteUserAccount deleteUserAccount,
  })  : _signInWithGoogle = signInWithGoogle,
        _signInWithApple = signInWithApple,
        _getCurrentUser = getCurrentUser,
        _signOut = signOut,
        super(Unauthenticated()) {
    _logger.i('AuthBloc initialized');
    on<SignInEvent>(_onSignIn);
    on<SignInWithAppleEvent>(_onSignInWithApple);
    on<SignOutEvent>(_onSignOut);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        message: 'Google Sign-In initiated',
        category: 'auth',
        level: SentryLevel.info,
      ));
      final user = await _signInWithGoogle();
      if (user != null) {
        _logger.i('User signed in: ${user.id}');
        emit(Authenticated(user));
      } else {
        _logger.w('Sign in failed');
        emit(Unauthenticated());
      }
    } catch (e, stackTrace) {
      _logger.e('Error during Google Sign-In: $e');
      await Sentry.captureException(e, stackTrace: stackTrace);
      emit(AuthError('Google Sign-In failed.'));
    }
  }

  Future<void> _onSignInWithApple(
      SignInWithAppleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        message: 'Apple Sign-In initiated',
        category: 'auth',
        level: SentryLevel.info,
      ));
      final user = await _signInWithApple();
      if (user != null) {
        _logger.i('User signed in with Apple: ${user.id}');
        emit(Authenticated(user));
      } else {
        _logger.w('Apple Sign-In failed');
        emit(Unauthenticated());
      }
    } catch (e, stackTrace) {
      _logger.e('Error during Apple Sign-In: $e');
      await Sentry.captureException(e, stackTrace: stackTrace);
      emit(AuthError('Apple Sign-In failed.'));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        message: 'Sign-out initiated',
        category: 'auth',
        level: SentryLevel.info,
      ));
      await _signOut();
      Sentry.configureScope((scope) {
        scope.setUser(null);
      });
      _logger.i('User signed out');
      emit(Unauthenticated());
    } catch (e, stackTrace) {
      _logger.e('Error during sign-out: $e');
      await Sentry.captureException(e, stackTrace: stackTrace);
      emit(AuthError('Failed to sign out.'));
    }
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    try {
      Sentry.addBreadcrumb(Breadcrumb(
        message: 'Checking authentication status',
        category: 'auth',
        level: SentryLevel.info,
      ));
      final user = _getCurrentUser();
      if (user != null) {
        _logger.i('User is authenticated: ${user.id}');
        Sentry.configureScope((scope) {
          scope.setUser(SentryUser(id: user.id));
        });
        emit(Authenticated(user));
      } else {
        _logger.i('User is not authenticated');
        emit(Unauthenticated());
      }
    } catch (e, stackTrace) {
      _logger.e('Error checking authentication status: $e');
      await Sentry.captureException(e, stackTrace: stackTrace);
      emit(AuthError('Failed to check authentication status.'));
    }
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
    _logger.d('State transition: ${transition.currentState} -> ${transition.nextState}');
  }

  String? get userId {
    final state = this.state;
    if (state is Authenticated) {
      return state.user.id;
    }
    return null;
  }
}
