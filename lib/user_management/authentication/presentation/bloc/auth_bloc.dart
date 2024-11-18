import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  })
      : _signInWithGoogle = signInWithGoogle,
        _signInWithApple = signInWithApple,
        _getCurrentUser = getCurrentUser,
        _signOut = signOut,
        super(Unauthenticated()) {
    on<SignInEvent>(_onSignIn);
    on<SignInWithAppleEvent>(_onSignInWithApple);
    on<SignOutEvent>(_onSignOut);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await _signInWithGoogle();
    if (user != null) {
      _logger.i('User signed in: ${user.id}');
      emit(Authenticated(user)); // Simply emit the Authenticated state
    } else {
      _logger.w('Sign in failed');
      emit(Unauthenticated()); // Emit Unauthenticated if sign in fails
    }
  }

  Future<void> _onSignInWithApple(SignInWithAppleEvent event,
      Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await _signInWithApple();
    if (user != null) {
      _logger.i('User signed in with Apple: ${user.id}');
      emit(Authenticated(user));
    } else {
      _logger.w('Apple Sign-In failed');
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      // Add a breadcrumb to track sign-out initiation
      Sentry.addBreadcrumb(Breadcrumb(
        message: 'Sign-out initiated',
        category: 'auth',
        level: SentryLevel.info,
      ));

      // Perform the sign-out
      await _signOut();

      // Log the user out of Sentry
      Sentry.configureScope((scope) {
        scope.setUser(null); // Clear user context
      });

      _logger.i('User signed out');
      Sentry.addBreadcrumb(Breadcrumb(
        message: 'User signed out successfully',
        category: 'auth',
        level: SentryLevel.info,
      ));

      emit(Unauthenticated()); // Always emit Unauthenticated after signing out
    } catch (e, stackTrace) {
      _logger.e('Error during sign-out: $e');
      // Capture exception in Sentry
      await Sentry.captureException(e, stackTrace: stackTrace);
      // Optionally, you can re-emit an error state if needed
      emit(AuthError('Failed to sign out.'));
    }
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event,
      Emitter<AuthState> emit) async {
    try {
      // Add breadcrumb for auth status check
      Sentry.addBreadcrumb(Breadcrumb(
        message: 'Checking authentication status',
        category: 'auth',
        level: SentryLevel.info,
      ));

      final user = _getCurrentUser();
      if (user != null) {
        _logger.i('User is authenticated: ${user.id}');

        // Set the user context in Sentry
        Sentry.configureScope((scope) {
          scope.setUser(SentryUser(id: user.id));
        });

        Sentry.addBreadcrumb(Breadcrumb(
          message: 'User authenticated successfully',
          category: 'auth',
          level: SentryLevel.info,
        ));
        emit(Authenticated(user));
      } else {
        _logger.i('User is not authenticated');
        emit(Unauthenticated());
      }
    } catch (e, stackTrace) {
      _logger.e('Error checking authentication status: $e');
      // Capture exception in Sentry
      await Sentry.captureException(e, stackTrace: stackTrace);
      emit(AuthError('Failed to check authentication status.'));
    }
  }

// Getter to expose the user ID if authenticated
  String? get userId {
    final state = this.state;
    if (state is Authenticated) {
      return state.user.id;
    }
    return null;
  }
}