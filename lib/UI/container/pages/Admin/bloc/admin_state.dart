part of 'admin_cubit.dart';

class AdminState extends Equatable {
  final List<AdminUser> users;
  final AdminUser selectedUser;
  final List<Access> accessTypes;
  final List<Access> selectAccessTypes;

  final String message;
  final bool isLoading;
  final bool isLoadingAccess;
  final bool isUpdatingUser; //is used both for Adding and Updating user
  final bool isAddMode;

  final List<Centers> selectedCenters;
  final List<Centers> centers;
  final bool isLoadingCenters;

  const AdminState({
    this.users = const [],
    this.selectedUser = AdminUser.empty,
    this.accessTypes = const [],
    this.selectAccessTypes = const [],
    this.isLoading = false,
    this.isLoadingAccess = true,
    this.isUpdatingUser = false,
    this.isAddMode = false,
    this.message = '',
    this.selectedCenters = const [],
    this.centers = const [],
    this.isLoadingCenters = false,
  });

  AdminState copyWith({
    List<AdminUser>? users,
    AdminUser? selectedUser,
    List<Access>? accessType,
    List<Access>? selectAccessTypes,
    String? message,
    bool? isLoading,
    bool? isLoadingAccess,
    bool? isUpdatingUser,
    bool? isAddMode,
    List<Centers>? selectedCenters,
    List<Centers>? centers,
    bool? isLoadingCenters,
  }) {
    return AdminState(
      users: users ?? this.users,
      selectedUser: selectedUser ?? this.selectedUser,
      accessTypes: accessType ?? accessTypes,
      selectAccessTypes: selectAccessTypes ?? this.selectAccessTypes,
      isLoading: isLoading ?? this.isLoading,
      isLoadingAccess: isLoadingAccess ?? this.isLoadingAccess,
      isUpdatingUser: isUpdatingUser ?? this.isUpdatingUser,
      isAddMode: isAddMode ?? this.isAddMode,
      message: message ?? '',
      selectedCenters: selectedCenters ?? this.selectedCenters,
      centers: centers ?? this.centers,
      isLoadingCenters: isLoadingCenters ?? this.isLoadingCenters,
    );
  }

  @override
  List<Object> get props => [
        users,
        selectedUser,
        accessTypes,
        selectAccessTypes,
        isLoading,
        isLoadingAccess,
        isUpdatingUser,
        isAddMode,
        message,
        selectedCenters,
        centers,
        isLoadingCenters,
      ];
}
