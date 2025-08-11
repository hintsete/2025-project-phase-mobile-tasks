part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  final AuthenticatedUser? user;

  const AuthState({this.user});

  @override
  List<Object?> get props => [user];
}

// Initial state: no user
class AuthInitial extends AuthState {
  const AuthInitial() : super(user: null);
}

// Loading states
class AuthLoadInProgress extends AuthState {
  const AuthLoadInProgress({AuthenticatedUser? user}) : super(user: user);
}

class AuthLoginInProgress extends AuthState {
  const AuthLoginInProgress({AuthenticatedUser? user}) : super(user: user);
}

class AuthRegisterInProgress extends AuthState {
  const AuthRegisterInProgress({AuthenticatedUser? user}) : super(user: user);
}

class AuthLogoutInProgress extends AuthState {
  const AuthLogoutInProgress({AuthenticatedUser? user}) : super(user: user);
}

// Success states
class AuthLoadSuccess extends AuthState {
  const AuthLoadSuccess(AuthenticatedUser user) : super(user: user);
}

class AuthLoginSuccess extends AuthState {
  const AuthLoginSuccess(AuthenticatedUser user) : super(user: user);
}

class AuthRegisterSuccess extends AuthState {
  const AuthRegisterSuccess(AuthenticatedUser user) : super(user: user);
}

class AuthLogoutSuccess extends AuthState {
  const AuthLogoutSuccess() : super(user: null);
}

// Failure states
class AuthLoadFailure extends AuthState {
  final String message;
  const AuthLoadFailure(this.message, {AuthenticatedUser? user})
      : super(user: user);

  @override
  List<Object?> get props => [message, user];
}

class AuthLoginFailure extends AuthState {
  final String message;
  const AuthLoginFailure(this.message, {AuthenticatedUser? user})
      : super(user: user);

  @override
  List<Object?> get props => [message, user];
}

class AuthRegisterFailure extends AuthState {
  final String message;
  const AuthRegisterFailure(this.message, {AuthenticatedUser? user})
      : super(user: user);

  @override
  List<Object?> get props => [message, user];
}

class AuthLogoutFailure extends AuthState {
  final String message;
  const AuthLogoutFailure(this.message, {AuthenticatedUser? user})
      : super(user: user);

  @override
  List<Object?> get props => [message, user];
}
