import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/shift.dart';
import '../../../../../repositories/shift_repository.dart';
import '../../../../authentication/bloc/authentication_bloc.dart';

part 'shift_state.dart';

class ShiftCubit extends Cubit<ShiftState> {
  final AuthBloc auth;

  final ShiftRepository shiftRepo;

  ShiftCubit({required this.auth, required this.shiftRepo})
      : super(const ShiftState());

  void getShifts() async {
    emit(state.copyWith(
      isLoading: true,
    ));

    Map<String, dynamic> res =
        await shiftRepo.findAll(auth.state.user.id, auth.state.user.token);
    List<Shift> shifts = [];
    String message = '';
    if (res['message'].toString().isEmpty) {
      shifts = List<Shift>.from(
          res['entities'].map((dynamic row) => Shift.fromJson(row)));
      message = res['message'];
    } else {
      message = res['message'];
    }
    emit(state.copyWith(
      shifts: shifts,
      message: message,
      isLoading: false,
    ));
  }

  void getShift(int id) async {
    String message;
    Shift shift;

    emit(state.copyWith(
      isLoading: true,
    ));

    Map<String, dynamic> res = await shiftRepo.findById(
        entityId: id,
        logUserId: auth.state.user.id,
        token: auth.state.user.token);
    if (res['message'].toString().isEmpty) {
      //map is like: user:[{a user}]
      shift = res['entity'].isNotEmpty
          ? res['entity'].map((dynamic row) => Shift.fromJson(row)).toList()[0]
          : Shift.empty;
      message = res['message'];
    } else {
      shift = Shift.empty;
      message = res['message'];
    }

    emit(state.copyWith(
      message: message,
      selectedShift: shift,
      isLoading: false,
    ));
  }

  //save state of selected center's name changes(which has been selected from all center's list)
  void nameChanged(String name) {
    Shift c = state.selectedShift.copyWith(name: name);
    emit(state.copyWith(selectedShift: c));
  }

  //update selected user (which has been selected from all user's list)
  void update() async {
    emit(state.copyWith(
      isUpdatingOrAdding: true,
    ));

    String message = await shiftRepo.update(
        entity: state.selectedShift,
        logUserId: auth.state.user.id,
        token: auth.state.user.token);

    emit(state.copyWith(
      message: message,
      isUpdatingOrAdding: false,
    ));
  }

  void add() async {
    emit(state.copyWith(
      isUpdatingOrAdding: true,
    ));

    String message = await shiftRepo.add(
      entity: state.selectedShift,
      logUserId: auth.state.user.id,
      token: auth.state.user.token,
    );

    emit(state.copyWith(
      message: message,
      isUpdatingOrAdding: false,
    ));
  }

  //clear selected user. this functionality is need to clear
  //it to not showing user data when adding new user.
  void clearSelectedShift() {
    emit(state.copyWith(selectedShift: Shift.empty));
  }

  void setAddMode(bool isAddMode) {
    emit(state.copyWith(isAddMode: isAddMode));
  }

  void startTimeChanged(String val) {
    Shift selectedShift = state.selectedShift.copyWith(startTime: val);
    emit(state.copyWith(selectedShift: selectedShift));
  }

  void endTimeChanged(String val) {
    Shift selectedShift = state.selectedShift.copyWith(endTime: val);
    emit(state.copyWith(selectedShift: selectedShift));
  }

  void allowedStartTimeChanged(String val) {
    Shift selectedShift = state.selectedShift.copyWith(allowedStartTime: val);
    emit(state.copyWith(selectedShift: selectedShift));
  }

  void allowedEndTimeChanged(String val) {
    Shift selectedShift = state.selectedShift.copyWith(allowedEndTime: val);
    emit(state.copyWith(selectedShift: selectedShift));
  }

  void toggleEndsTomorrow() {
    bool currentState = state.selectedShift.endsToday == 1 ? true : false;
    currentState = !currentState;
    Shift selectedShift =
        state.selectedShift.copyWith(endsToday: currentState ? 1 : 0);
    emit(state.copyWith(selectedShift: selectedShift));
  }

  // VALID duration for employees to show card
  void validEndIsTodayChanged(bool val) {
    Shift selectedShift =
        state.selectedShift.copyWith(validEndForToday: val ? 1 : 0);
    emit(state.copyWith(selectedShift: selectedShift));
  }

  /// END TIME of shift is today or tomorrow. for example a shift time starts 7:00 and ends
  ///8:00. this 8:00 is today 8 or is tomorrow 8?  so shift's endsTomorrow property is for this purpose.
  void endTimeIsTodayChanged(bool val) {
    Shift selectedShift = state.selectedShift.copyWith(endsToday: val ? 1 : 0);
    emit(state.copyWith(selectedShift: selectedShift));
  }
}
