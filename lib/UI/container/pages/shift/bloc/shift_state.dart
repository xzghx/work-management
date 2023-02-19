part of 'shift_cubit.dart';

class ShiftState extends Equatable {
  final List<Shift> shifts;
  final Shift selectedShift;

  final String message;
  final bool isLoading;
  final bool isUpdatingOrAdding; //is used both for Adding and Updating user
  final bool isAddMode;


  const ShiftState({
    this.shifts = const [],
    this.selectedShift = Shift.empty,
    this.isLoading = false,
    this.isUpdatingOrAdding = false,
    this.isAddMode = false,
    this.message = '',
  });

  ShiftState copyWith({
    List<Shift>? shifts,
    Shift? selectedShift,
    bool? isLoading,
    bool? isUpdatingOrAdding,
    bool? isAddMode,
    String? message,
  }) {
    return ShiftState(
        shifts: shifts ?? this.shifts,
        selectedShift: selectedShift ?? this.selectedShift,
        isLoading: isLoading ?? this.isLoading,
        isUpdatingOrAdding: isUpdatingOrAdding ?? this.isUpdatingOrAdding,
        isAddMode: isAddMode ?? this.isAddMode,
        message: message ?? '');
  }

  @override
  List<Object> get props => [
        shifts,
        selectedShift,
        isLoading,
        isUpdatingOrAdding,
        isAddMode,
        message,
      ];
}
