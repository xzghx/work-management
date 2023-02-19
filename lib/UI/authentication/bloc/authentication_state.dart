part of 'authentication_bloc.dart';

enum AuthenticationStatus { unknown, authenticated, unAuthenticated }

class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthenticationStatus.unknown,
    this.user = AdminUser.empty,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(AdminUser user)
      : this._(
          user: user,
          status: AuthenticationStatus.authenticated,
        );

  const AuthState.unAuthenticated()
      : this._(
          status: AuthenticationStatus.unAuthenticated,
        );

  final AuthenticationStatus status;
  final AdminUser user;

  @override
  List<Object?> get props => [status, user];
}
