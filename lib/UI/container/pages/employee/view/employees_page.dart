import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../helpers/constants.dart';
import '../../../../../helpers/images.dart';
import '../../../../../helpers/my_custom_scrol_behavour.dart';
import '../../../../../models/centers.dart';
import '../../../../../models/part.dart';
import '../../../../../repositories/centers_repository.dart';
import '../../../../../repositories/employee_repository.dart';
import '../../../../../repositories/error_logger_repository.dart';
import '../../../../../repositories/part_repository.dart';
import '../../../../../widgets/card_name_lastname_edit.dart';
import '../../../../../widgets/search_box.dart';
import '../../../../authentication/bloc/authentication_bloc.dart';
import '../bloc/employee_cubit.dart';
import 'add_or_edit_employee.dart';

class EmployeesPage extends StatelessWidget {
  // static const String route = "/dataEntry/PartPage";

  const EmployeesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeCubit(
        auth: BlocProvider.of<AuthBloc>(context),
        employeeRep: EmployeeRepository(
          errorLogger: RepositoryProvider.of<ErrorLoggerRepository>(context),
        ),
        centersRepo: CentersRepository(
          errorLogger: RepositoryProvider.of<ErrorLoggerRepository>(context),
        ),
        partsRepo: PartRepository(
          errorLogger: RepositoryProvider.of<ErrorLoggerRepository>(context),
        ),
      )..initialize(),
      child: const EmployeesPageView(),
    );
  }
}

class EmployeesPageView extends StatefulWidget {
  const EmployeesPageView({Key? key}) : super(key: key);

  @override
  State<EmployeesPageView> createState() => _EmployeesPageViewState();
}

class _EmployeesPageViewState extends State<EmployeesPageView> {
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(),
      body:
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SvgPicture.asset(
            Images.employeesSvg,
            fit: BoxFit.contain,
            height: 200,
          ),
          Column(
            children: [
              const Flexible(
                  flex: 1,
                  child:  HeaderCarte()),
              SizedBox(
                height: height - 180,
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: BlocConsumer<EmployeeCubit, EmployeeState>(
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
                          context.read<EmployeeCubit>().findAll();
                        },
                        //to make list scrollable with mouse
                        child: ScrollConfiguration(
                          behavior: MyCustomScrollBehavior(),
                          child: ListView.builder(
                              controller: controller,
                              physics: const AlwaysScrollableScrollPhysics(),
                              //add on more index for header
                              itemCount: state.employees.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Column(
                                    children: [
                                      CardTwoFieldsAndEdit(
                                        index: "ردیف",
                                        name: "نام",
                                        lastName: 'نام خانوادگی',
                                        code: 'شماره کارت',
                                        mobile: 'موبایل',
                                        context: context,
                                        onEditClick: null,
                                      ),
                                    ],
                                  );
                                } else {
                                  index = index - 1;
                                  return CardTwoFieldsAndEdit(
                                    index: index.toString(),
                                    name: state.employees[index].name,
                                    lastName: state.employees[index].lastName,
                                    code: state.employees[index].codePersonely,
                                    mobile: state.employees[index].mobile,
                                    onEditClick: () async {
                                      // Navigator.of(context).push(
                                      //   //**DO NOT pass context to builder.It is not containing EditFooterCubit in context.
                                      //     MaterialPageRoute(builder: (_) => BlocProvider.value(
                                      //         value:BlocProvider.of<EditFooterCubit>(context) ,
                                      //         child: EditFooterDetailPage())
                                      //     ));
                                      context
                                          .read<EmployeeCubit>()
                                          .setAddMode(false);
                                      //clear selected center, part and other fields
                                      context
                                          .read<EmployeeCubit>()
                                          .clearSelectedValues();

                                      Navigator.of(context).pushNamed(
                                          AddOrEditEmployeePage.route,
                                          arguments:
                                          BlocProvider.of<EmployeeCubit>(
                                              context));

                                      await context
                                          .read<EmployeeCubit>()
                                          .findAllCenters();

                                      if (!mounted) return;
                                      context.read<EmployeeCubit>().findById(
                                          state.employees[index].id);
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
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          context.read<EmployeeCubit>().clearSelectedValues();
          context.read<EmployeeCubit>().setAddMode(true);
          context.read<EmployeeCubit>().findAllCenters();
          Navigator.of(context).pushNamed(AddOrEditEmployeePage.route,
              arguments: BlocProvider.of<EmployeeCubit>(context));
        },
        tooltip: "افزودن کارمند جدید",
        child: const Icon(Icons.add),
      ),
    );
  }
}

class HeaderCarte extends StatelessWidget {
  const HeaderCarte({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Flexible(
              flex: 1,
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
            ),
            const SizedBox(width: 8),
            const CentersWidgetE(),
            const PartsWidgetE(),
            IconButton(
                onPressed: () {
                  context.read<EmployeeCubit>().findAll();
                },
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.secondary,
                )),

            // const Spacer(),
          ],
        ),
      ),
    );
  }
}

class CentersWidgetE extends StatelessWidget {
  const CentersWidgetE({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeCubit, EmployeeState>(
      buildWhen: (previous, current) {
        if (previous.filterCenter != current.filterCenter ||
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

                        context.watch<EmployeeCubit>().state.filterCenter ==
                                Centers.empty
                            ? null
                            : context.watch<EmployeeCubit>().state.filterCenter,
                    items: state.centers
                        .map((Centers j) => DropdownMenuItem<Centers>(
                            value: j, child: Text(j.name)))
                        .toList(),
                    onChanged: (Centers? j) {
                      if (j != null) {
                        context
                            .read<EmployeeCubit>()
                            .selectedFilterCenterChanged(j);

                        context
                            .read<EmployeeCubit>()
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

class PartsWidgetE extends StatelessWidget {
  const PartsWidgetE({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeCubit, EmployeeState>(
      buildWhen: (previous, current) {
        if (previous.filterPart != current.filterPart ||
            previous.filterParts != current.filterParts) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('انتخاب بخش'),
            //checking list is loaded or not is done before calling this widget
            // state.isLoadingCenters == true
            //     ? const CircularProgressIndicator()
            //     :
            DropdownButton<Part>(
              // key: UniqueKey(),
              value: /*state.centers.firstWhere(
                        (c) => c.id == state.selectedEntity.idCenter,
                        ),*/

                  context.watch<EmployeeCubit>().state.filterPart == Part.empty
                      ? null
                      :
                      //after re fetching centers list, selected part must be null
                      context.watch<EmployeeCubit>().state.filterPart,
              items: state.filterParts
                  .map((Part j) =>
                      DropdownMenuItem<Part>(value: j, child: Text(j.name)))
                  .toList(),
              onChanged: (Part? j) {
                if (j != null) {
                  context.read<EmployeeCubit>().selectedFilterPartChanged(j);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
