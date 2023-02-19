part of 'container_cubit.dart';

enum ContainerTab {
  home,
  centers,
  parts,
  employees,
  files,
  admins,
  shift,
  reports,
  monthShifts,
  logout,
  changePassword,
  dataDetail, //Details of user vorod and khoroj
}

class ContainerState extends Equatable {
  final ContainerTab selectedTab;

  const ContainerState({this.selectedTab = ContainerTab.home});

  @override
  List<Object> get props => [selectedTab];
}
