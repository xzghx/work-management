import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/centers.dart';
import '../../../../../repositories/centers_repository.dart';
import '../../../../authentication/bloc/authentication_bloc.dart';

part 'center_state.dart';

class CentersCubit extends Cubit<CentersState> {
  final AuthBloc auth;

  final CentersRepository centersRepo;

  CentersCubit({required this.auth, required this.centersRepo})
      : super(const CentersState());

  void getCenters() async {
    emit(state.copyWith(
      isLoading: true,
    ));

    Map<String, dynamic> res =
        await centersRepo.findAll(auth.state.user.id, auth.state.user.token);
    List<Centers> centers = [];
    String message = '';
    if (res['message'].toString().isEmpty) {
      centers = List<Centers>.from(
          res['entities'].map((dynamic row) => Centers.fromJson(row)));
      message = res['message'];
    } else {
      message = res['message'];
    }
    emit(state.copyWith(
      centers: centers,
      message: message,
      isLoading: false,
    ));
  }

  void getCenter(int id) async {
    String message;
    Centers center;

    emit(state.copyWith(
      isLoading: true,
    ));

    Map<String, dynamic> res = await centersRepo.findById(
        entityId: id,
        logUserId: auth.state.user.id,
        token: auth.state.user.token);
    if (res['message'].toString().isEmpty) {
      //map is like: user:[{a user}]
      center = res['entity'].isNotEmpty
          ? res['entity']
              .map((dynamic row) => Centers.fromJson(row))
              .toList()[0]
          : Centers.empty;
      message = res['message'];
    } else {
      center = Centers.empty;
      message = res['message'];
    }

    emit(state.copyWith(
      message: message,
      selectedCenter: center,
      isLoading: false,
    ));
  }

  //save state of selected center's name changes(which has been selected from all center's list)
  void nameChanged(String name) {
    Centers c = state.selectedCenter.copyWith(name: name);
    emit(state.copyWith(selectedCenter: c));
  }

  //update selected user (which has been selected from all user's list)
  void update() async {
    emit(state.copyWith(
      isUpdatingOrAddingUser: true,
    ));
    //todo here
    String message = await centersRepo.update(
        entity: state.selectedCenter,
        logUserId: auth.state.user.id,
        token: auth.state.user.token);

    emit(state.copyWith(
      message: message,
      isUpdatingOrAddingUser: false,
    ));
  }

  void add() async {
    emit(state.copyWith(
      isUpdatingOrAddingUser: true,
    ));

    String message = await centersRepo.add(
      entity: state.selectedCenter,
      logUserId: auth.state.user.id,
      token: auth.state.user.token,
    );

    emit(state.copyWith(
      message: message,
      isUpdatingOrAddingUser: false,
    ));
  }

  //clear selected user. this functionality is need to clear
  //it to not showing user data when adding new user.
  void clearSelectedCenter() {
    emit(state.copyWith(selectedCenter: Centers.empty));
  }

  void setAddMode(bool isAddMode) {
    emit(state.copyWith(isAddMode: isAddMode));
  }
}
