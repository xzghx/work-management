import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../helpers/constants.dart';
import '../../../../../helpers/my_custom_scrol_behavour.dart';
import '../../../../../repositories/error_logger_repository.dart';
import '../../../../../repositories/shift_repository.dart';
import '../../../../../widgets/card_name_lastname_edit.dart';
import '../../../../authentication/bloc/authentication_bloc.dart';
import '../../../view/container_pages_export.dart';
import '../bloc/shift_cubit.dart';
import 'add_or_edit_shift.dart';

class ShiftsPage extends StatelessWidget {
  // static const String route = "/dataEntry/CentersPage";

  const ShiftsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShiftCubit(
        auth: BlocProvider.of<AuthBloc>(context),
        shiftRepo: ShiftRepository(
            errorLogger: RepositoryProvider.of<ErrorLoggerRepository>(context)),
      )..getShifts(),
      child: ShiftsPageView(),
    );
  }
}

class ShiftsPageView extends StatelessWidget {
  ShiftsPageView({Key? key}) : super(key: key);
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: BlocConsumer<ShiftCubit, ShiftState>(
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
                      context.read<ShiftCubit>().getShifts();
                    },
                    //to make list scrollable with mouse
                    child: ScrollConfiguration(
                      behavior: MyCustomScrollBehavior(),
                      child: ListView.builder(
                          controller: controller,
                          physics: const AlwaysScrollableScrollPhysics(),
                          //add on more index for header
                          itemCount: state.shifts.length + 1,
                          itemBuilder: (context, index) {
                            //if list is empty, show empty image
                            if (state.shifts.isEmpty) {
                              return const Empty();
                            }
                            if (index == 0) {
                              return Column(
                                children: [
                                  CardTwoFieldsAndEdit(
                                    index: "ردیف",
                                    name: "نام",
                                    context: context,
                                    onEditClick: null,
                                  ),
                                ],
                              );
                            } else {
                              index = index - 1;
                              return CardTwoFieldsAndEdit(
                                index: index.toString(),
                                name: state.shifts[index].name,
                                onEditClick: () {
                                  // Navigator.of(context).push(
                                  //   //**DO NOT pass context to builder.It is not containing EditFooterCubit in context.
                                  //     MaterialPageRoute(builder: (_) => BlocProvider.value(
                                  //         value:BlocProvider.of<EditFooterCubit>(context) ,
                                  //         child: EditFooterDetailPage())
                                  //     ));
                                  context.read<ShiftCubit>().setAddMode(false);
                                  Navigator.of(context).pushNamed(
                                      AddOrEditShiftPage.route,
                                      arguments:
                                          BlocProvider.of<ShiftCubit>(context));
                                  context
                                      .read<ShiftCubit>()
                                      .getShift(state.shifts[index].id);
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
          context.read<ShiftCubit>().clearSelectedShift();
          context.read<ShiftCubit>().setAddMode(true);
          Navigator.of(context).pushNamed(AddOrEditShiftPage.route,
              arguments: BlocProvider.of<ShiftCubit>(context));
        },
        tooltip: "تعریف شیفت جدید",
        child: const Icon(Icons.add),
      ),
    );
  }
}
