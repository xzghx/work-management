import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../responsive.dart';
import '../../../widgets/container_drawer.dart';
import '../../../widgets/day_night_button.dart';
import '../../authentication/bloc/authentication_bloc.dart';
import '../../login/bloc/login_bloc.dart';
import '../../login/view/login_page.dart';
import '../bloc/container_cubit.dart';
import '../pages/profile/view/profile_page.dart';
import '../pages/reports/view/reports_page.dart';
import '../pages/vorod_khoroj_Search/view/vorod_khoroj_search.dart';
import 'container_pages_export.dart';

class ContainerPage extends StatelessWidget {
  static const String route = '/containerPage';

  const ContainerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ContainerCubit(loginBloc: BlocProvider.of<LoginBloc>(context)),
      child: const ViewE(),
    );
  }
}

class ViewE extends StatelessWidget {
  const ViewE({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (cur, prev) => cur.status != prev.status,
      listener: (context, state) {
        if (state.status == AuthenticationStatus.unAuthenticated) {
          Navigator.of(context).pushReplacementNamed(LoginPage.route);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            const DayNightButton(),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back))
          ],
        ),
        body: Row(
          children: [
            Responsive.isDesktop(context)
                ? Expanded(
                    flex: 2,
                    child: _getDrawer(context),
                  )
                : const SizedBox(),
            Expanded(flex: 8, child: SizedBox(child: _getContent(context))),
          ],
        ),
        drawer: !Responsive.isDesktop(context) ? _getDrawer(context) : null,
      ),
    );
  }

  _getDrawer(BuildContext context) {
    return ContainerDrawer(
      onHomeClick: () {
        context.read<ContainerCubit>().tabClicked(ContainerTab.home);
      },
      onCenterClick: () {
        context.read<ContainerCubit>().tabClicked(ContainerTab.centers);
      },
      onPartsClick: () {
        context.read<ContainerCubit>().tabClicked(ContainerTab.parts);
      },
      onEmployeesClick: () {
        context.read<ContainerCubit>().tabClicked(ContainerTab.employees);
      },
      onAdminsClick: () {
        context.read<ContainerCubit>().tabClicked(ContainerTab.admins);
      },
      onLogoutClick: () {
        context.read<ContainerCubit>().tabClicked(ContainerTab.logout);
      },
      onEnterDataClick: () {
        context.read<ContainerCubit>().tabClicked(ContainerTab.files);
      },
      onShiftClick: () {
        context.read<ContainerCubit>().tabClicked(ContainerTab.shift);
      },
      onReportsClick: () {
        context.read<ContainerCubit>().tabClicked(ContainerTab.reports);
      },
      onMonthShiftClick: () {
        context.read<ContainerCubit>().tabClicked(ContainerTab.monthShifts);
      },
      onProfileClick: () {
        context.read<ContainerCubit>().tabClicked(ContainerTab.changePassword);
      },
      onVorodKhorojDetailClick: () {
        context.read<ContainerCubit>().tabClicked(ContainerTab.dataDetail);
      },
    );
  }

  _getContent(BuildContext context) {
    switch (context.watch<ContainerCubit>().state.selectedTab) {
      case ContainerTab.home:
        return const ContainerHome();
      case ContainerTab.centers:
        return const CentersPage();
      case ContainerTab.parts:
        return const PartsPage();
      case ContainerTab.employees:
        return const EmployeesPage();
      case ContainerTab.admins:
        return const AdminUsersPage();
      case ContainerTab.shift:
        return const ShiftsPage();
      //----------
      case ContainerTab.files:
        return const FilesPage();
      case ContainerTab.reports:
        return const ReportsPage();
      case ContainerTab.monthShifts:
        return const MonthShiftPage();
      case ContainerTab.changePassword:
        return const ProfilePage();
      case ContainerTab.dataDetail:
        return const VorodKhorojSearch();
      case ContainerTab.logout:
        return const Text("logouts");
    }
  }
}
