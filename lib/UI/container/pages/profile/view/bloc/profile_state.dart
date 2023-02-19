part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final ProfileUser user;
  final bool isUpdating;
  final String message;
  final String newPassword;
  final String confirmedPassword;
  @override
  List<Object> get props => [
        user,
        isUpdating,
        message,
    newPassword,
    confirmedPassword,
      ];

  const ProfileState({
    required this.user,
    this.isUpdating = false,
    this.message = '',
    this.newPassword='',
    this.confirmedPassword ='',
  });

  ProfileState copyWith({
    ProfileUser? user,
    bool? isUpdating,
    String? message,
    String? newPassword,
    String? confirmedPassword,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isUpdating: isUpdating ?? this.isUpdating,
      message: message ?? '',
      newPassword: newPassword ?? this.newPassword,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,

    );
  }
}
