import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../repositories/user_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileUser user;
  final String token;
  final UserRepository userRepo;

  ProfileCubit(
      {required this.user, required this.userRepo, required this.token})
      : super(ProfileState(user: user));

  void initialize() {
    //todo
  }

  void nameChanged(String val) {
    ProfileUser changed = state.user.copyWith(name: val);
    emit(state.copyWith(user: changed));
  }

  void lastNameChanged(String val) {
    ProfileUser changed = state.user.copyWith(lastName: val);
    emit(state.copyWith(user: changed));
  }

  void mobileChanged(String val) {
    ProfileUser changed = state.user.copyWith(mobile: val);
    emit(state.copyWith(user: changed));
  }

  void userNameChanged(String val) {
    ProfileUser changed = state.user.copyWith(userName: val);
    emit(state.copyWith(user: changed));
  }

  void passwordChanged(String val) {
    emit(state.copyWith(newPassword: val));
  }

  void confirmedPasswordChanged(String val) {
    emit(state.copyWith(confirmedPassword: val));
  }

  void updateProfileInfo() async {
    emit(state.copyWith(isUpdating: true));
    String message = await userRepo.updateProfile(state.user, token);
    emit(state.copyWith(isUpdating: false, message: message));
  }

  void updatePassword() async {
    emit(state.copyWith(isUpdating: true));
    String message = await userRepo.updatePassword(
      id: state.user.id,
      userName: state.user.userName,
      newPassword: state.newPassword,
      mobile: state.user.mobile,
      token: token,
    );
    emit(state.copyWith(isUpdating: false, message: message));
  }

  bool validateProfileForm(GlobalKey<FormState> formKey) {
    return formKey.currentState!.validate();
  }

  bool validatePasswordForm(GlobalKey<FormState> formKey) {
    return formKey.currentState!.validate();
  }

  bool passwordsMatch() {
    return state.newPassword.toString() == state.confirmedPassword.toString();
  }
}

class ProfileUser extends Equatable {
  final int id;
  final String name;
  final String lastName;
  final String userName;
  final String mobile;

  ProfileUser.fromJson(Map<String, dynamic> map)
      : id = map['id'] ?? 0,
        name = map['name'] ?? '',
        lastName = map['lastName'] ?? '',
        userName = map['userName'] ?? '',
        mobile = map['mobile'] ?? '';

  const ProfileUser({
    required this.id,
    required this.name,
    required this.lastName,
    required this.userName,
    required this.mobile,
  });

  // Empty user which represents an unauthenticated user.
  static const empty = ProfileUser(
    id: 0,
    name: '',
    lastName: '',
    userName: '',
    mobile: '',
  );

  ProfileUser copyWith({
    int? id,
    String? name,
    String? lastName,
    String? userName,
    String? mobile,
  }) {
    return ProfileUser(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      userName: userName ?? this.userName,
      mobile: mobile ?? this.mobile,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        lastName,
        userName,
        mobile,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'userName': userName,
      'mobile': mobile,
    };
  }
}
