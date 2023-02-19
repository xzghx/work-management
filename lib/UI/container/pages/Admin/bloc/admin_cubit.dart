import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/admin_users.dart';
import '../../../../../models/centers.dart';
import '../../../../../models/my_response.dart';
import '../../../../../repositories/admin_repository.dart';
import '../../../../../repositories/centers_repository.dart';
import '../../../../authentication/bloc/authentication_bloc.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AuthBloc auth;
  final AdminRepository adminRepo;
  final CentersRepository centersRepo;

  AdminCubit({
    required this.auth,
    required this.adminRepo,
    required this.centersRepo,
  }) : super(const AdminState());

  void getUsers() async {
    emit(state.copyWith(
      isLoading: true,
    ));

    Map<String, dynamic> res =
        await adminRepo.findAll(auth.state.user.id, auth.state.user.token);
    List<AdminUser> users = [];
    String message = '';
    if (res['message'].toString().isEmpty) {
      users = List<AdminUser>.from(
          res['entities'].map((dynamic row) => AdminUser.fromJson(row)));
      message = res['message'];
    } else {
      message = res['message'];
    }
    emit(state.copyWith(
      users: users,
      message: message,
      isLoading: false,
    ));
  }

  void getUser(int id) async {
    String message;
    AdminUser user;

    emit(state.copyWith(
      isLoading: true,
    ));

    Map<String, dynamic> res = await adminRepo.findById(
        entityId: id,
        logUserId: auth.state.user.id,
        token: auth.state.user.token);
    if (res['message'].toString().isEmpty) {
      //map is like: user:[{a user}]
      user = res['entity']?.isNotEmpty
          ? res['entity']
              .map((dynamic row) => AdminUser.fromJson(row))
              .toList()[0]
          : AdminUser.empty;
      message = res['message'];
    } else {
      user = AdminUser.empty;
      message = res['message'];
    }

    emit(state.copyWith(
      message: message,
      selectedUser: user,
      isLoading: false,
    ));
  }

  void getAccessTypes() async {
    List<Access> access = [];
    String mes = '';
    emit(state.copyWith(
      isLoadingAccess: true,
    ));

    MyResponse res = await adminRepo.getAccessTypes(
        auth.state.user.id, auth.state.user.token);

    // await Future.delayed(Duration(milliseconds: 600));
    if (res.status == 0) {
      mes = res.message;
      access = res.serverResponse.isNotEmpty
          ? List<Access>.from(
              res.serverResponse['accessTypes'].map(
                (dynamic row) => Access.fromJson(row),
              ),
            )
          : [];
    } else {
      mes = res.message;
    }
    emit(state.copyWith(
      message: mes,
      accessType: access,
      isLoadingAccess: false,
    ));
  }

  void getCenters() async {
    emit(state.copyWith(
      isLoadingCenters: true,
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
      message: message,
      centers: centers,
      isLoadingCenters: false,
    ));
  }

  void accessChanged({required List<Access> accesses}) {
    String star = AdminUser.mapAccessToStaredIds(accesses);
    AdminUser selectedUser = state.selectedUser.copyWith(accessIds: star);
    emit(state.copyWith(
      // to save it in state for later saving in server
      selectedUser: selectedUser,
      selectAccessTypes: accesses, //to show selected accesses in ui
    ));
  }

  void accessToCenterChanged({required List<Centers> accessCenters}) {
    String star = AdminUser.mapAccessToStaredIds(accessCenters);
    AdminUser selectedUser =
        state.selectedUser.copyWith(centersAccessIds: star);
    emit(state.copyWith(
      // to save it in state for later saving in server
      selectedUser: selectedUser,
      selectedCenters: accessCenters, //to show selected accesses in ui
    ));
  }

  //save state of selected user's name changes(which has been selected from all user's list)
  void nameChanged(String name) {
    AdminUser selectedUser = state.selectedUser.copyWith(name: name);
    emit(state.copyWith(selectedUser: selectedUser));
  }

  //save state of selected user's last name changes (which has been selected from all user's list)
  void lastNameChanged(String lastName) {
    AdminUser selectedUser = state.selectedUser.copyWith(lastName: lastName);
    emit(state.copyWith(selectedUser: selectedUser));
  }

  void mobilChanged(String mobile) {
    AdminUser selectedUser = state.selectedUser.copyWith(mobile: mobile);
    emit(state.copyWith(selectedUser: selectedUser));
  }

  //update selected user (which has been selected from all user's list)
  void updateUser() async {
    emit(state.copyWith(
      isUpdatingUser: true,
    ));

    String message = await adminRepo.update(
        entity: state.selectedUser,
        logUserId: auth.state.user.id,
        token: auth.state.user.token);

    emit(state.copyWith(
      message: message,
      isUpdatingUser: false,
    ));
  }

  void addUser() async {
    emit(state.copyWith(
      isUpdatingUser: true,
    ));

    String message = await adminRepo.add(
      entity: state.selectedUser,
      logUserId: auth.state.user.id,
      token: auth.state.user.token,
    );

    emit(state.copyWith(
      message: message,
      isUpdatingUser: false,
    ));
  }

  //clear selected user. this functionality is need to clear
  //it to not showing user data when adding new user.
  void clearSelectedUser() {
    emit(state.copyWith(selectedUser: AdminUser.empty));
  }

  void setAddMode(bool isAddMode) {
    emit(state.copyWith(isAddMode: isAddMode));
  }
}
