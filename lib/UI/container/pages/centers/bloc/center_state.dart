part of 'center_cubit.dart';

class CentersState extends Equatable {
  final List<Centers> centers;
  final Centers selectedCenter;

  final String message;
  final bool isLoading;
  final bool isUpdatingOrAddingUser; //is used both for Adding and Updating user
  final bool isAddMode;

  const CentersState({
    this.centers = const [],
    this.selectedCenter = Centers.empty,
    this.isLoading = false,
    this.isUpdatingOrAddingUser = false,
    this.isAddMode = false,
    this.message = '',
  });

  CentersState copyWith({
    List<Centers>? centers,
    Centers? selectedCenter,
    bool? isLoading,
    bool? isUpdatingOrAddingUser,
    bool? isAddMode,
    String? message,

  }) {
    return CentersState(
        centers: centers ?? this.centers,
        selectedCenter: selectedCenter ?? this.selectedCenter,
        isLoading: isLoading ?? this.isLoading,
        isUpdatingOrAddingUser: isUpdatingOrAddingUser ?? this.isUpdatingOrAddingUser,
        isAddMode: isAddMode ?? this.isAddMode,
        message: message ?? '');
  }

  @override
  List<Object> get props => [
        centers,
        selectedCenter,
        isLoading,
        isUpdatingOrAddingUser,
        isAddMode,
        message,
      ];
}
