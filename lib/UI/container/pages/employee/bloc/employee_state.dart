part of 'employee_cubit.dart';

class EmployeeState extends Equatable {
  final List<Employee> employees;
  final List<Part> parts;
  final List<Part> filterParts;
  final List<Centers> centers;
  final Employee selectedEmployee;
  final Part selectedPart;
  final Centers selectedCenter;

  final String message;
  final bool isLoading;
  final bool isLoadingCenters;
  final LoadState loadingPartsState;

  final bool isUpdatingOrAddingUser; //is used both for Adding and Updating user
  final bool isAddMode;

  final String searchValue;
  final Centers filterCenter;
  final Part filterPart;

  const EmployeeState({
    this.employees = const [],
    this.parts = const [],
    this.filterParts = const [],
    this.centers = const [],
    this.selectedEmployee = Employee.empty,
    this.selectedPart = Part.empty,
    this.selectedCenter = Centers.empty,
    this.isLoading = false,
    this.isLoadingCenters = false,
    this.loadingPartsState = LoadState.pure,
    this.isUpdatingOrAddingUser = false,
    this.isAddMode = false,
    this.message = '',
    this.searchValue = '',
    this.filterCenter = Centers.empty,
    this.filterPart = Part.empty,
  });

  EmployeeState copyWith({
    List<Employee>? employees,
    List<Part>? parts,
    List<Part>? filterParts,
    List<Centers>? centers,
    Employee? selectedEmployee,
    Part? selectedPart,
    Centers? selectedCenter,
    bool? isLoading,
    bool? isLoadingCenters,
    LoadState? loadingPartsState,
    bool? isUpdatingOrAddingUser,
    bool? isAddMode,
    String? message,
    String? searchValue,
    Centers? filterCenter,
    Part? filterPart,
  }) {
    return EmployeeState(
      employees: employees ?? this.employees,
      parts: parts ?? this.parts,
      filterParts: filterParts ?? this.filterParts,
      centers: centers ?? this.centers,
      selectedEmployee: selectedEmployee ?? this.selectedEmployee,
      selectedPart: selectedPart ?? this.selectedPart,
      selectedCenter: selectedCenter ?? this.selectedCenter,
      loadingPartsState: loadingPartsState ?? this.loadingPartsState,
      isLoading: isLoading ?? this.isLoading,
      isLoadingCenters: isLoadingCenters ?? this.isLoadingCenters,
      isUpdatingOrAddingUser:
      isUpdatingOrAddingUser ?? this.isUpdatingOrAddingUser,
      isAddMode: isAddMode ?? this.isAddMode,
      message: message ?? '',
      searchValue: searchValue ?? this.searchValue,
      filterCenter: filterCenter ?? this.filterCenter,
      filterPart: filterPart ?? this.filterPart,
    );
  }

  @override
  List<Object> get props =>
      [
        employees,
        parts,
        filterParts,
        centers,
        selectedEmployee,
        selectedPart,
        selectedCenter,
        isLoading,
        isLoadingCenters,
        loadingPartsState,
        isUpdatingOrAddingUser,
        isAddMode,
        message,
        searchValue,
        filterCenter,
        filterPart,
      ];
}
