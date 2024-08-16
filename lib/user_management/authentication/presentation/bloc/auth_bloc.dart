import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/usecases/sign_in_with_google.dart';
import '../../application/usecases/get_current_user.dart';
import '../../application/usecases/sign_out.dart';
import '../../application/usecases/delete_user_account.dart';
import '../../domain/entities/user.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/config/supabase_config.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle _signInWithGoogle;
  final GetCurrentUser _getCurrentUser;
  final SignOut _signOut;
  final CustomLogger _logger = CustomLogger('AuthBloc');

  AuthBloc({
    required SignInWithGoogle signInWithGoogle,
    required GetCurrentUser getCurrentUser,
    required SignOut signOut,
    required DeleteUserAccount deleteUserAccount,
  })  : _signInWithGoogle = signInWithGoogle,
        _getCurrentUser = getCurrentUser,
        _signOut = signOut,
        super(Unauthenticated()) {
    on<SignInEvent>(_onSignIn);
    on<SignOutEvent>(_onSignOut);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<DeleteAccountEvent>(_onDeleteAccount);
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await _signInWithGoogle();
    if (user != null) {
      _logger.i('User signed in: ${user.id}');
      emit(Authenticated(user));
    } else {
      _logger.w('Sign in failed');
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _signOut();
    _logger.i('User signed out');
    emit(Unauthenticated());
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    final user = _getCurrentUser();
    if (user != null) {
      _logger.i('User is authenticated: ${user.id}');
      emit(Authenticated(user));
    } else {
      _logger.i('User is not authenticated');
      emit(Unauthenticated());
    }
  }

  Future<void> _onDeleteAccount(DeleteAccountEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = _getCurrentUser();
    if (user != null) {
      final userId = user.id;
      try {
        // Call the HTTP function to delete the folder and user account
        await _deleteUserAccountFromServer(userId);

        // Log out the user to invalidate the current session
        await _signOut();

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
  }

  Future<void> _deleteUserAccountFromServer(String userId) async {
    final url = Uri.parse('https://nfzsvyypwbbwsutqfhuy.supabase.co/functions/v1/deleteUserFolderAndAccount');

    final session = SupabaseConfig.client.auth.currentSession;
    _logger.i('Current session: ${session?.toJson()}');

    final accessToken = session?.accessToken;

    if (accessToken == null) {
      _logger.e('No access token available');
      throw Exception('No access token available');
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Use Supabase access token
        },
        body: jsonEncode({'userId': userId}),
      );

      _logger.i('Response status code: ${response.statusCode}');
      _logger.i('Response body: ${response.body}');

      if (response.statusCode == 200) {
        _logger.i('User folder and account deleted successfully');
      } else {
        final error = jsonDecode(response.body)['error'];
        _logger.e('Failed to delete user folder and account: $error');
        throw Exception('Failed to delete user folder and account: $error');
      }
    } catch (e) {
      _logger.e('Exception caught while deleting user folder and account: $e');
      throw Exception('Failed to delete user folder and account: $e');
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
