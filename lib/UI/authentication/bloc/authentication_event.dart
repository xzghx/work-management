part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationLoggedIn extends AuthenticationEvent {
  final AdminUser user;

  const AuthenticationLoggedIn(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthenticationLoggedOut  extends AuthenticationEvent {
  final String message;
  const AuthenticationLoggedOut(this.message);
  @override
  List<Object?> get props => [message];
}
