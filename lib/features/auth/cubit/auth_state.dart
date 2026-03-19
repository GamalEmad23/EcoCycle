part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
final class AuthSuccess extends AuthState {}
final class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});
  
}


final class LoginInitial extends AuthState {}
final class LoginLoading extends AuthState {}
final class LoginSuccess extends AuthState {}
final class LoginFailure extends AuthState {
  final String message;

  LoginFailure({required this.message});
  
}

final class ResetPasswordInitial extends AuthState {}
final class ResetPasswordLoading extends AuthState {}
final class ResetPasswordSuccess extends AuthState {}
final class ResetPasswordFailure extends AuthState {
  final String message;

  ResetPasswordFailure({required this.message});
  
}

final class googleLoginInitial extends AuthState {}
final class googleLoginLoading extends AuthState {}
final class googleLoginSuccess extends AuthState {}
final class googleLoginFailure extends AuthState {
  final String message;

  googleLoginFailure({required this.message});
  
}
