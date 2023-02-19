import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../helpers/constants.dart';
import '../../../../../helpers/my_custom_scrol_behavour.dart';
import '../../../../../repositories/admin_repository.dart';
import '../../../../../repositories/centers_repository.dart';
import '../../../../../repositories/error_logger_repository.dart';
import '../../../../../widgets/card_name_lastname_edit.dart';
import '../../../../authentication/bloc/authentication_bloc.dart';
import '../bloc/admin_cubit.dart';
import 'add__or_edit_admin_user.dart';

class AdminUsersPage extends StatelessWidget {
  static const String route = "/AdminUsers";

  const AdminUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCubit(
          auth: BlocProvider.of<AuthBloc>(context),
          centersRepo: CentersRepository(
              errorLogger:
                  RepositoryProvider.of<ErrorLoggerRepository>(context)),
          adminRepo: AdminRepository(
              errorLogger:
                  RepositoryProvider.of<ErrorLoggerRepository>(context)))
        ..getUsers(),
      child: AdminUsersPageView(),
    );
  }
}

class AdminUsersPageView extends StatelessWidget {
  AdminUsersPageView({Key? key}) : super(key: key);
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: BlocConsumer<AdminCubit, AdminState>(
          listenWhen: (prevState, currentState) =>
              prevState.isLoading != currentState.isLoading,
          listener: (context, state) {
            if (state.message.isNotEmpty) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return state.isLoading
                ? const CircularProgressIndicator()
                : RefreshIndicator(
                    onRefresh: () async {
                      context.read<AdminCubit>().getUsers();
                    },
                    //to make list scrollable with mouse
                    child: ScrollConfiguration(
                      behavior: MyCustomScrollBehavior(),
                      child: ListView.builder(
                          controller: controller,
                          physics: const AlwaysScrollableScrollPhysics(),
                          //add on more index for header
                          itemCount: state.users.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  CardTwoFieldsAndEdit(
                                    context: context,
                                    index: "ردیف",
                                    name: "نام",
                                    lastName: "نام خانوادگی",
                                    onEditClick: null,
                                  ),
                                ],
                              );
                            } else {
                              index = index - 1;
                              return CardTwoFieldsAndEdit(
                                index: index.toString(),
                                name: state.users[index].name,
                                lastName: state.users[index].lastName,
                                onEditClick: () {
                                  // Navigator.of(context).push(
                                  //   //**DO NOT pass context to builder.It is not containing EditFooterCubit in context.
                                  //     MaterialPageRoute(builder: (_) => BlocProvider.value(
                                  //         value:BlocProvider.of<EditFooterCubit>(context) ,
                                  //         child: EditFooterDetailPage())
                                  //     ));
                                  context.read<AdminCubit>().setAddMode(false);
                                  Navigator.of(context).pushNamed(
                                      AddOrEditAdminPage.route,
                                      arguments:
                                          BlocProvider.of<AdminCubit>(context));
                                  context
                                      .read<AdminCubit>()
                                      .getUser(state.users[index].id);
                                  context.read<AdminCubit>().getAccessTypes();
                                  context.read<AdminCubit>().getCenters();


                                },
                                context: context,
                              );
                            }
                          }),
                    ),
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          context.read<AdminCubit>().clearSelectedUser();
          context.read<AdminCubit>().setAddMode(true);
          context.read<AdminCubit>().getAccessTypes();
          context.read<AdminCubit>().getCenters();
          Navigator.of(context).pushNamed(AddOrEditAdminPage.route,
              arguments: BlocProvider.of<AdminCubit>(context));
        },
        tooltip: "افزودن کاربر جدید",
        child: const Icon(Icons.add),
      ),
    );
  }

/*Widget _getCard({
    required String index,
    required String name,
    required String lastName,
    onEditClick,
    BuildContext? context,
  }) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(index),
                const SizedBox(width: 20),
                Text(
                  "$name       $lastName",
                ),
              ],
            ),
            Row(
              children: [
                onEditClick != null
                    ? IconButton(
                        onPressed: onEditClick,
                        icon: Icon(
                          Icons.edit_rounded,
                          color: Theme.of(context!).colorScheme.primary,
                        ))
                    : const SizedBox(),
                // const SizedBox(width: 20),
              ],
            )
          ],
        ),
      ),
    );
  }*/
}
