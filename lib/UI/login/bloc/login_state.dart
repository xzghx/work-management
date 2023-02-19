part of 'login_bloc.dart';

class LoginState extends Equatable {
  final UserName userName;
  final Password password;
  final FormzStatus formzStatus;
  final String? message;

  const LoginState({
    this.userName = const UserName.pure(),
    this.password = const Password.pure(),
    this.formzStatus = FormzStatus.pure,
    this.message,
  });

  LoginState copyWith(
      {UserName? userName,
      Password? password,
      FormzStatus? formzStatus,
      String? message}) {
    return LoginState(
        userName: userName ?? this.userName,
        password: password ?? this.password,
        formzStatus: formzStatus ?? this.formzStatus,
        message: message);
  }

  @override
  List<Object?> get props => [userName, password, formzStatus, message];
}
