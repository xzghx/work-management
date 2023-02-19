import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/user_repository.dart';
import '../../authentication/bloc/authentication_bloc.dart';
import '../models/models.dart';

export '../../../repositories/user_repository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepo;
  final AuthBloc authBloc;

  LoginBloc({required this.userRepo, required this.authBloc})
      : super(const LoginState()) {
    on<LoginUserNameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  FutureOr<void> _onUsernameChanged(
      LoginUserNameChanged event, Emitter<LoginState> emit) {
    UserName userName = UserName.dirty(event.userName);
    emit(state.copyWith(
        userName: userName,
        formzStatus: Formz.validate([userName, state.password])));
  }

  FutureOr<void> _onPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    final Password password = Password.dirty(event.password);

    emit(state.copyWith(
        password: password,
        formzStatus: Formz.validate([password, state.userName])));
  }

  FutureOr<void> _onSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    if (state.formzStatus.isValidated) {
      emit(state.copyWith(formzStatus: FormzStatus.submissionInProgress));
      Map<String, dynamic> result =
          await userRepo.logIn(state.userName.value, state.password.value);
      if (result['user'] != AdminUser.empty) {
        authBloc.add(AuthenticationLoggedIn(result['user']));
        emit(state.copyWith(
          formzStatus: FormzStatus.submissionSuccess,
          message: result['message'],
        ));
      } else {
        emit(state.copyWith(
          formzStatus: FormzStatus.submissionFailure,
          message: result['message'],
        ));
      }
    }
  }

  FutureOr<void> _onLogoutRequested(
      LogoutRequested event, Emitter<LoginState> emit) async {
    String message = await userRepo.logOut(
      userId: authBloc.state.user.id,
      token: authBloc.state.user.token,
    );
    emit(state.copyWith(
      userName: const UserName.pure(),
      password: const Password.pure(),
      formzStatus: FormzStatus.pure,
      message: message,
    ));
    authBloc.add(AuthenticationLoggedOut(message));
  }
}
