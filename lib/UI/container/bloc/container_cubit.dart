import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../login/bloc/login_bloc.dart';

part 'container_state.dart';

class ContainerCubit extends Cubit<ContainerState> {
  final LoginBloc loginBloc;

  ContainerCubit({
    required this.loginBloc,
  }) : super(const ContainerState());

  void tabClicked(ContainerTab tab) {
    if (tab != ContainerTab.logout) {
      emit(ContainerState(selectedTab: tab));
    } else {
      loginBloc.add(const LogoutRequested());
    }
  }
}
