part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

@immutable
class GoogleSignInRequested extends AuthenticationEvent {}

@immutable
class SignOutRequested extends AuthenticationEvent {}
