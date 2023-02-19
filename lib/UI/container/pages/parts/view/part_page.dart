import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../helpers/constants.dart';
import '../../../../../helpers/my_custom_scrol_behavour.dart';
import '../../../../../models/centers.dart';
import '../../../../../repositories/centers_repository.dart';
import '../../../../../repositories/error_logger_repository.dart';
import '../../../../../repositories/part_repository.dart';
import '../../../../../widgets/card_name_lastname_edit.dart';
import '../../../../authentication/bloc/authentication_bloc.dart';
import '../bloc/part_cubit.dart';
import 'add_or_edit_part.dart';

class PartsPage extends StatelessWidget {
  // static const String route = "/dataEntry/PartPage";

  const PartsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PartCubit(
        auth: BlocProvider.of<AuthBloc>(context),
        partRepo: PartRepository(
          errorLogger: RepositoryProvider.of<ErrorLoggerRepository>(context),
        ),
        centersRepo: CentersRepository(
          errorLogger: RepositoryProvider.of<ErrorLoggerRepository>(context),
        ),
      )..initialize(),
      child: const PartsPageView(),
    );
  }
}

class PartsPageView extends StatefulWidget {
  const PartsPageView({Key? key}) : super(key: key);

  @override
  State<PartsPageView> createState() => _PartsPageViewState();
}

class _PartsPageViewState extends State<PartsPageView> {
  // final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const HeaderCarteP(),
            SizedBox(
              height: height - 190,
              child: BlocConsumer<PartCubit, PartState>(
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
                            context.read<PartCubit>().findAll();
                          },
                          //to make list scrollable with mouse
                          child: ScrollConfiguration(
                            behavior: MyCustomScrollBehavior(),
                            child: ListView.builder(
                                // controller: controller,
                                physics: const AlwaysScrollableScrollPhysics(),
                                //add on more index for header
                                itemCount: state.parts.length + 1,
                                itemBuilder: (context, index) {
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
                                      name: state.parts[index].name,
                                      onEditClick: () async {
                                        // Navigator.of(context).push(
                                        //   //**DO NOT pass context to builder.It is not containing EditFooterCubit in context.
                                        //     MaterialPageRoute(builder: (_) => BlocProvider.value(
                                        //         value:BlocProvider.of<EditFooterCubit>(context) ,
                                        //         child: EditFooterDetailPage())
                                        //     ));
                                        context
                                            .read<PartCubit>()
                                            .setAddMode(false);
                                        //clear selected part and center before
                                        context
                                            .read<PartCubit>()
                                            .clearSelectedPartAndCenter();
                                        //go to page
                                        Navigator.of(context).pushNamed(
                                            AddOrEditPartPage.route,
                                            arguments:
                                                BlocProvider.of<PartCubit>(
                                                    context));
                                        //first get centers to be able to pre select  the selected value
                                        await context
                                            .read<PartCubit>()
                                            .findAllCenters();
                                        if (!mounted) return;
                                        context
                                            .read<PartCubit>()
                                            .findById(state.parts[index].id);
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          context.read<PartCubit>().clearSelectedPartAndCenter();
          context.read<PartCubit>().setAddMode(true);
          context.read<PartCubit>().findAllCenters();
          Navigator.of(context).pushNamed(AddOrEditPartPage.route,
              arguments: BlocProvider.of<PartCubit>(context));
        },
        tooltip: "افزودن مرکز جدید",
        child: const Icon(Icons.add),
      ),
    );
  }
}

class HeaderCarteP extends StatelessWidget {
  const HeaderCarteP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: const [
            /*   Expanded(
              //todo has ASSERT warning.
              child: SearchBox(
                initialValue: context.read<EmployeeCubit>().state.searchValue,
                onChange: (String? value) {
                  context.read<EmployeeCubit>().searchBoxChanged(value ?? '');
                },
                onSearch: () {
                  context.read<EmployeeCubit>().findAll();
                },
              ),
            ),*/

            CentersWidgetP(),

            // const Spacer(),
          ],
        ),
      ),
    );
  }
}

class CentersWidgetP extends StatelessWidget {
  const CentersWidgetP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartCubit, PartState>(
      buildWhen: (previous, current) {
        if (previous.filteredCenter != current.filteredCenter ||
            previous.centers != current.centers) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('انتخاب مرکز'),
            state.isLoadingCenters == true
                ? const CircularProgressIndicator()
                : DropdownButton<Centers>(
                    // key: UniqueKey(),
                    value: /*state.centers.firstWhere(
                        (c) => c.id == state.selectedEntity.idCenter,
                        ),*/

                        context.watch<PartCubit>().state.filteredCenter ==
                                Centers.empty
                            ? null
                            : context.watch<PartCubit>().state.filteredCenter,
                    items: state.centers
                        .map((Centers j) => DropdownMenuItem<Centers>(
                            value: j, child: Text(j.name)))
                        .toList(),
                    onChanged: (Centers? j) {
                      if (j != null) {
                        context
                            .read<PartCubit>()
                            .selectedFilterCenterChanged(j);

                        context
                            .read<PartCubit>()
                            .getPartsForFilteredCenter(j.id);
                      }
                    },
                  ),
          ],
        );
      },
    );
  }
}
