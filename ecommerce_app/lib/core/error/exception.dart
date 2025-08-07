import 'package:equatable/equatable.dart';

class ServerException implements Exception{}
class CacheException implements Exception{}

class AuthenticationException extends Equatable implements Exception {
  final String message;

  const AuthenticationException({required this.message});

  @override
  List<Object?> get props => [message];

  factory AuthenticationException.passwordTooShort() {
    return const AuthenticationException(message: 'Password is too short');
  }

  factory AuthenticationException.emailAlreadyInUse() {
    return const AuthenticationException(message: 'Email is already in use');
  }

  factory AuthenticationException.invalidEmailAndPasswordCombination() {
    return const AuthenticationException(
        message: 'Invalid email and password combination');
  }

  factory AuthenticationException.tokenExpired() {
    return const AuthenticationException(message: 'Token has expired');
  }
}