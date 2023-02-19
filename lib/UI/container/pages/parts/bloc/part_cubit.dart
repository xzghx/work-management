import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifter/models/centers.dart';

import '../../../../../models/part.dart';
import '../../../../../repositories/centers_repository.dart';
import '../../../../../repositories/part_repository.dart';
import '../../../../authentication/bloc/authentication_bloc.dart';

part 'part_state.dart';

///selectedCenter is in addOrEditPartPage which is user selected Center for adding new part
///filteredCenter is in parts list page to filter parts list based on filter
class PartCubit extends Cubit<PartState> {
  final AuthBloc auth;

  final PartRepository partRepo;
  final CentersRepository centersRepo;

  PartCubit({
    required this.auth,
    required this.partRepo,
    required this.centersRepo,
  }) : super(const PartState());

  ///IMPORTANT: centers must be loaded after part info loaded .
  ///centers must be loaded and we must be sure
  Future<void> findAllCenters() async {
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
    //set selected Center
    Centers? selectedCenter = centers.firstWhere(
        (c) => c.id == state.selectedEntity.idCenter,
        orElse: () => Centers.empty);
    if (selectedCenter == Centers.empty) {
      selectedCenter = null;
    }
    emit(state.copyWith(
      centers: centers,
      selectedCenter: selectedCenter,
      message: message,
      isLoadingCenters: false,
    ));
    return;
  }

  ///find all parts
  void findAll() async {
    emit(state.copyWith(
      isLoading: true,
    ));

    Map<String, dynamic> res = await partRepo.findAll(
      auth.state.user.id,
      auth.state.user.token,
      //selectedCenter is in addOrEditPartPage which is user selected Center for adding new part
      idCenter: state.filteredCenter.id,
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
    emit(state.copyWith(
      parts: parts,
      message: message,
      isLoading: false,
    ));
  }

  void findById(int id) async {
    String message;
    Part part;

    emit(state.copyWith(
      isLoading: true,
    ));

    Map<String, dynamic> res = await partRepo.findById(
        entityId: id,
        logUserId: auth.state.user.id,
        token: auth.state.user.token);
    if (res['message'].toString().isEmpty) {
      //map is like: user:[{a user}]
      part = res['entity'].isNotEmpty
          ? res['entity'].map((dynamic row) => Part.fromJson(row)).toList()[0]
          : Part.empty;
      message = res['message'];
    } else {
      part = Part.empty;
      message = res['message'];
    }

    //find selected center ***( so centers must be loaded before. so make sure.)
    int centerId = part.idCenter;
    Centers c = state.centers.firstWhere((element) => element.id == centerId);
    emit(state.copyWith(
      message: message,
      selectedEntity: part,
      selectedCenter: c,
      isLoading: false,
    ));
  }

  //save state of selected center's name changes(which has been selected from all center's list
  // or is being created
  // )
  void nameChanged(String name) {
    Part selectedPart = state.selectedEntity.copyWith(name: name);
    emit(state.copyWith(selectedEntity: selectedPart));
  }

  void selectedCenterChanged(Centers j) {
    Part selectedPart = state.selectedEntity.copyWith(idCenter: j.id);
    emit(state.copyWith(selectedEntity: selectedPart, selectedCenter: j));
  }

  //update selected user (which has been selected from all user's list)
  void update() async {
    emit(state.copyWith(
      isUpdatingOrAddingUser: true,
    ));
    //todo here
    String message = await partRepo.update(
        entity: state.selectedEntity,
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

    String message = await partRepo.add(
      entity: state.selectedEntity,
      logUserId: auth.state.user.id,
      token: auth.state.user.token,
    );

    emit(state.copyWith(
      message: message,
      isUpdatingOrAddingUser: false,
    ));
  }

  void clearSelectedPartAndCenter() {
    emit(state.copyWith(
      selectedCenter: Centers.empty,
      selectedEntity: Part.empty,
    ));
  }

  void setAddMode(bool isAddMode) {
    emit(state.copyWith(isAddMode: isAddMode));
  }

  void selectedFilterCenterChanged(Centers j) {
    emit(state.copyWith(filteredCenter: j));
  }

  void getPartsForFilteredCenter(int centerId) {
    findAll();
  }

  void initialize() async {
    await findAllCenters();

    emit(state.copyWith(
        filteredCenter:
            state.centers.isNotEmpty ? state.centers.first : Centers.empty));
    state.centers.isNotEmpty
        ? getPartsForFilteredCenter(state.centers.first.id)
        : null;
  }
}
