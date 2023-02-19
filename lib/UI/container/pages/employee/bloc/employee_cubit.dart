import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/centers.dart';
import '../../../../../models/employee.dart';
import '../../../../../models/part.dart';
import '../../../../../repositories/centers_repository.dart';
import '../../../../../repositories/employee_repository.dart';
import '../../../../../repositories/part_repository.dart';
import '../../../../authentication/bloc/authentication_bloc.dart';

part 'employee_state.dart';

enum LoadState {
  pure,
  loading,
  loaded,
}

class EmployeeCubit extends Cubit<EmployeeState> {
  final AuthBloc auth;

  final EmployeeRepository employeeRep;
  final CentersRepository centersRepo;
  final PartRepository partsRepo;

  EmployeeCubit({
    required this.auth,
    required this.employeeRep,
    required this.centersRepo,
    required this.partsRepo,
  }) : super(const EmployeeState());

  Future findAllCenters() async {
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
    //set Centers List
    //set selected Center and part
    Part? selectedPart;
    Centers? selectedCenter = centers.firstWhere(
        (c) => c.id == state.selectedEmployee.idCenter,
        orElse: () => Centers.empty);
    //because findAllCenters is called before findEmployee by id, so selectedCenter is always empty
    //and when employee is fetched, then the selected Center changes and it's ok
    if (selectedCenter == Centers.empty) {
      selectedCenter == Centers.empty;
      selectedPart = Part.empty;
    }
    emit(state.copyWith(
      centers: centers,
      selectedPart: selectedPart,
      selectedCenter: selectedCenter,
      message: message,
      isLoadingCenters: false,
    ));
    return;
  }

  void initialize() async {
    await findAllCenters();
    emit(state.copyWith(filterCenter: state.centers.first));
    await getPartsForFilteredCenter(state.centers.first.id);
    emit(state.copyWith(filterPart: state.filterParts.first));
    findAll();
  }

  ///find all employees
  void findAll() async {
    emit(state.copyWith(
      isLoading: true,
    ));

    Map<String, dynamic> res = await employeeRep.findAllFiltered(
      logUserId: auth.state.user.id,
      token: auth.state.user.token,
      idCenter: state.filterCenter.id,
      idPart: state.filterPart.id,
      search: state.searchValue,
    );
    List<Employee> employees = [];
    String message = '';
    if (res['message'].toString().isEmpty) {
      employees = List<Employee>.from(
          res['entities'].map((dynamic row) => Employee.fromJson(row)));
      message = res['message'];
    } else {
      message = res['message'];
    }
    emit(state.copyWith(
      employees: employees,
      message: message,
      isLoading: false,
    ));
  }

  ///find Employee by id
  Future<void> findById(int id) async {
    String message;
    Employee employee;

    emit(state.copyWith(
      isLoading: true,
    ));

    Map<String, dynamic> res = await employeeRep.findById(
        entityId: id,
        logUserId: auth.state.user.id,
        token: auth.state.user.token);
    if (res['message'].toString().isEmpty) {
      //map is like: user:[{a user}]
      employee = res['entity'].isNotEmpty
          ? res['entity']
              .map((dynamic row) => Employee.fromJson(row))
              .toList()[0]
          : Employee.empty;
      message = res['message'];
    } else {
      employee = Employee.empty;
      message = res['message'];
    }
    //find selected center ***( so centers must be loaded before. so make sure.)
    int centerId = employee.idCenter;
    Centers c = state.centers.firstWhere((element) => element.id == centerId,
        orElse: () => Centers.empty);
    emit(state.copyWith(
      message: message,
      selectedEmployee: employee,
      selectedCenter: c,
      isLoading: false,
    ));

    getPartsForSelectedCenter(centerId);
    return;
  }

  /// so then the selected Part must get reset.
  void selectedCenterChanged(Centers j) {
    Employee current = state.selectedEmployee.copyWith(
      idCenter: j.id,
    );

    emit(state.copyWith(
      selectedEmployee: current,
      selectedCenter: j,
      selectedPart: Part.empty,
      //do not change selectedEmployee's idPart here.
      //selectedEmployee's idPart will get changed in selectedPartChanged
    ));
  }

  /// so then the selected Part must get reset.
  void selectedFilterCenterChanged(Centers j) {
    emit(state.copyWith(
      filterCenter: j,
      //todo not sure
      // filterPart: Part.empty,
      selectedPart: Part.empty,
    ));
  }

  void selectedPartChanged(Part j) {
    Employee current = state.selectedEmployee.copyWith(idPart: j.id);
    emit(state.copyWith(selectedEmployee: current, selectedPart: j));
  }

  void selectedFilterPartChanged(Part j) {
    emit(state.copyWith(filterPart: j));
  }

  void getPartsForSelectedCenter(int idCenter) async {
    emit(state.copyWith(
      loadingPartsState: LoadState.loading,
    ));

    Map<String, dynamic> res = await partsRepo.findAll(
      auth.state.user.id,
      auth.state.user.token,
      idCenter: idCenter,
    );
    List<Part> parts = [];
    String message = '';
    if (res['message'].toString().isEmpty) {
      parts = List<Part>.from(
          res['entities'].map((dynamic row) => Part.fromJson(row)));
      message = res['message'];
    } else {
      message = res['message'];
    }
    //set Centers List
    //set selected Center
    Part? selectedPart = parts.firstWhere(
        (c) => c.id == state.selectedEmployee.idPart,
        orElse: () => Part.empty);
    if (selectedPart == Part.empty) {
      selectedPart = Part.empty;
    }
    emit(state.copyWith(
      parts: parts,
      selectedPart: selectedPart,
      message: message,
      loadingPartsState: LoadState.loaded,
    ));
  }

  Future<void> getPartsForFilteredCenter(int idCenter) async {
    emit(state.copyWith(
      loadingPartsState: LoadState.loading,
    ));

    Map<String, dynamic> res = await partsRepo.findAll(
      auth.state.user.id,
      auth.state.user.token,
      idCenter: idCenter,
    );
    List<Part> parts = [];
    String message = '';
    if (res['message'].toString().isEmpty) {
      parts = List<Part>.from(
          res['entities'].map((dynamic row) => Part.fromJson(row)));
      message = res['message'];
    } else {
      message = res['message'];
    }
    //set Centers List
    //set selected Center
    Part? selectedPart = parts.first;
    if (selectedPart == Part.empty) {
      selectedPart = Part.empty;
    }
    emit(state.copyWith(
      filterParts: parts,
      filterPart: selectedPart,
      message: message,
      loadingPartsState: LoadState.loaded,
    ));
  }

  bool validateForm(GlobalKey<FormState> formKey) {
    if (!formKey.currentState!.validate()) return false;
    if (state.selectedEmployee.idPart == 0) return false;
    if (state.selectedEmployee.idCenter == 0) return false;

    return true;
  }

  void searchBoxChanged(String s) {
    emit(state.copyWith(searchValue: s));
  }

  //update selected user (which has been selected from all user's list)
  void update() async {
    emit(state.copyWith(
      isUpdatingOrAddingUser: true,
    ));

    String message = await employeeRep.update(
        entity: state.selectedEmployee,
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

    String message = await employeeRep.add(
      entity: state.selectedEmployee,
      logUserId: auth.state.user.id,
      token: auth.state.user.token,
    );

    emit(state.copyWith(
      message: message,
      isUpdatingOrAddingUser: false,
    ));
  }

  void clearSelectedValues() {
    emit(state.copyWith(
      loadingPartsState: LoadState.pure,
      parts: [],
      //clear fetched parts which is for selected center
      selectedCenter: Centers.empty,
      selectedPart: Part.empty,
      selectedEmployee: Employee.empty,
    ));
  }

  void setAddMode(bool isAddMode) {
    emit(state.copyWith(isAddMode: isAddMode));
  }

  //save state of selected center's name changes(which has been selected from all center's list
  // or is being created
  // )
  void nameChanged(String name) {
    Employee current = state.selectedEmployee.copyWith(name: name);
    emit(state.copyWith(selectedEmployee: current));
  }

  void lastNameChanged(String val) {
    Employee current = state.selectedEmployee.copyWith(lastName: val);
    emit(state.copyWith(selectedEmployee: current));
  }

  void codeMelliChanged(String val) {
    Employee current = state.selectedEmployee.copyWith(codeMelli: val);
    emit(state.copyWith(selectedEmployee: current));
  }

  void codePersonelyChanged(String val) {
    Employee current = state.selectedEmployee.copyWith(codePersonely: val);
    emit(state.copyWith(selectedEmployee: current));
  }

  void startDateChanged(String val) {
    Employee current = state.selectedEmployee.copyWith(startDate: val);
    emit(state.copyWith(selectedEmployee: current));
  }

  void endDateChanged(String val) {
    Employee current = state.selectedEmployee.copyWith(endDate: val);
    emit(state.copyWith(selectedEmployee: current));
  }

  void mobileChanged(String val) {
    Employee current = state.selectedEmployee.copyWith(mobile: val);
    emit(state.copyWith(selectedEmployee: current));
  }

  void idEmployeeDarMarkazChanged(String val) {
    Employee current =
        state.selectedEmployee.copyWith(idEmployeeDarMarkaz: val);
    emit(state.copyWith(selectedEmployee: current));
  }
}
