part of 'part_cubit.dart';

class PartState extends Equatable {
  final List<Part> parts;
  final List<Centers> centers;
  final Part selectedEntity;
  final Centers selectedCenter;

  final String message;
  final bool isLoading;
  final bool isLoadingCenters;
  final bool isUpdatingOrAddingUser; //is used both for Adding and Updating user
  final bool isAddMode;

//
  final Centers filteredCenter;

  const PartState({
    this.parts = const [],
    this.centers = const [],
    this.selectedEntity = Part.empty,
    this.selectedCenter = Centers.empty,
    this.isLoading = false,
    this.isLoadingCenters = false,
    this.isUpdatingOrAddingUser = false,
    this.isAddMode = false,
    this.message = '',
    //
    this.filteredCenter = Centers.empty,
  });

  PartState copyWith({
    List<Part>? parts,
    List<Centers>? centers,
    Part? selectedEntity,
    Centers? selectedCenter,
    bool? isLoading,
    bool? isLoadingCenters,
    bool? isUpdatingOrAddingUser,
    bool? isAddMode,
    String? message,
    //
    Centers? filteredCenter,
  }) {
    return PartState(
      parts: parts ?? this.parts,
      centers: centers ?? this.centers,
      selectedEntity: selectedEntity ?? this.selectedEntity,
      selectedCenter: selectedCenter ?? this.selectedCenter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingCenters: isLoadingCenters ?? this.isLoadingCenters,
      isUpdatingOrAddingUser:
          isUpdatingOrAddingUser ?? this.isUpdatingOrAddingUser,
      isAddMode: isAddMode ?? this.isAddMode,
      message: message ?? '',
      filteredCenter: filteredCenter ?? this.filteredCenter,
    );
  }

  @override
  List<Object> get props => [
        parts,
        centers,
        selectedEntity,
        selectedCenter,
        isLoading,
        isLoadingCenters,
        isUpdatingOrAddingUser,
        isAddMode,
        message,
        //
        filteredCenter,
      ];
}
