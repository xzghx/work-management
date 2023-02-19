import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/admin_users.dart';
import '../../../repositories/user_repository.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthBloc extends Bloc<AuthenticationEvent, AuthState> {
  // final UserRepository _userRepository;

  AuthBloc({required UserRepository userRepo})
      :
        // _userRepository = userRepo,
        super(const AuthState.unknown()) {
    on<AuthenticationLoggedIn>(_onAuthenticationLoggedIn);

    on<AuthenticationLoggedOut>(_onAuthenticationLoggedOut);
  }

  void _onAuthenticationLoggedIn(
    AuthenticationLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final user = event.user;
    return emit(AuthState.authenticated(user));
  }

  void _onAuthenticationLoggedOut(
      AuthenticationLoggedOut event,
    Emitter<AuthState> emit,
  ) {
    return emit(const AuthState.unAuthenticated());
  }
}
