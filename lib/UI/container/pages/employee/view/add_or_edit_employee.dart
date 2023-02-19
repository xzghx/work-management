import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../helpers/constants.dart';
import '../../../../../helpers/helper_methods.dart';
import '../../../../../helpers/images.dart';
import '../../../../../helpers/my_custom_scrol_behavour.dart';
import '../../../../../helpers/regular_exp_checker.dart';
import '../../../../../models/centers.dart';
import '../../../../../models/employee.dart';
import '../../../../../models/part.dart';
import '../../../../../responsive.dart';
import '../../../../../widgets/my_text_form_field.dart';
import '../bloc/employee_cubit.dart';

class AddOrEditEmployeePage extends StatelessWidget {
  static const String route = "/dataEntry/addEditEmployee";

  const AddOrEditEmployeePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ViewB();
  }
}

class ViewB extends StatefulWidget {
  const ViewB({Key? key}) : super(key: key);

  @override
  State<ViewB> createState() => _ViewState();
}

class _ViewState extends State<ViewB> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: context.read<EmployeeCubit>().state.isAddMode
            ? const Text("افزودن کارمند جدید")
            : const Text("ویرایش کارمند"),
      ),
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          SvgPicture.asset(
            Images.employeeInfoSvg,
            fit: BoxFit.contain,
            height: 400,
          ),
          BlocListener<EmployeeCubit, EmployeeState>(
            listenWhen: (prev, curr) =>
                prev.isUpdatingOrAddingUser == true &&
                curr.isUpdatingOrAddingUser == false,
            listener: (context, state) {
              if (!state.isUpdatingOrAddingUser) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: context.select<EmployeeCubit, bool>(
                      (EmployeeCubit c) => c.state.isLoading)
                  ? const CircularProgressIndicator()
                  : Center(
                      child: ScrollConfiguration(
                        behavior: MyCustomScrollBehavior(),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: SizedBox(
                              width: Responsive.isDesktop(context)
                                  ? width / 2
                                  : width - 20,
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 100),

                                      //name - last name
                                      Row(
                                        children: [
                                          //name
                                          MyTextFormField(
                                            initialValue: context
                                                .select<EmployeeCubit,
                                                        Employee>(
                                                    (EmployeeCubit c) => c
                                                        .state.selectedEmployee)
                                                .name,
                                            onChange: (String val) {
                                              context
                                                  .read<EmployeeCubit>()
                                                  .nameChanged(val);
                                            },
                                            myDecoration:
                                                myDecoration(label: 'نام'),
                                            formKey: _formKey,
                                            context: context,
                                            maxLen: 20,
                                            validator: (String? val) {
                                              if (val != null &&
                                                  ReqularExpChecker
                                                      .regExpNameReg
                                                      .hasMatch(val)) {
                                                return null;
                                              }
                                              return "لطفا پر شود";
                                            },
                                          ),
                                          const SizedBox(width: defaultPadding),
                                          //last name
                                          MyTextFormField(
                                            initialValue: context
                                                .select<EmployeeCubit,
                                                        Employee>(
                                                    (EmployeeCubit c) => c
                                                        .state.selectedEmployee)
                                                .lastName,
                                            onChange: (String val) {
                                              context
                                                  .read<EmployeeCubit>()
                                                  .lastNameChanged(val);
                                            },
                                            myDecoration: myDecoration(
                                                label: 'نام خانوادگی'),
                                            formKey: _formKey,
                                            context: context,
                                            maxLen: 30,
                                            validator: (String? val) {
                                              if (val != null &&
                                                  ReqularExpChecker
                                                      .regExpNameReg
                                                      .hasMatch(val)) {
                                                return null;
                                              }
                                              return "لطفا پر شود";
                                            },
                                          ),
                                          const SizedBox(width: defaultPadding),
                                        ],
                                      ),
                                      //codeMelli  - code personely
                                      Row(
                                        children: [
                                          //codeMelli
                                          MyTextFormField(
                                            initialValue: context
                                                .select<EmployeeCubit,
                                                        Employee>(
                                                    (EmployeeCubit c) => c
                                                        .state.selectedEmployee)
                                                .codeMelli,
                                            onChange: (String val) {
                                              context
                                                  .read<EmployeeCubit>()
                                                  .codeMelliChanged(val);
                                            },
                                            myDecoration:
                                                myDecoration(label: 'کدملی'),
                                            formKey: _formKey,
                                            context: context,
                                            maxLen: 10,
                                            validator: (String? val) {
                                              if (val != null &&
                                                  ReqularExpChecker
                                                      .regExpCodeMelli
                                                      .hasMatch(val)) {
                                                return null;
                                              }
                                              return "لطفا پر شود";
                                            },
                                          ),
                                          const SizedBox(width: defaultPadding),
                                          //code personely
                                          MyTextFormField(
                                            initialValue: context
                                                .select<EmployeeCubit,
                                                        Employee>(
                                                    (EmployeeCubit c) => c
                                                        .state.selectedEmployee)
                                                .codePersonely,
                                            onChange: (String val) {
                                              context
                                                  .read<EmployeeCubit>()
                                                  .codePersonelyChanged(val);
                                            },
                                            myDecoration: myDecoration(
                                                label: 'کد پرسنلی'),
                                            formKey: _formKey,
                                            context: context,
                                            maxLen: 50,
                                            validator: (String? val) {
                                              if (val != null &&
                                                  ReqularExpChecker
                                                      .regExpCodePersonely
                                                      .hasMatch(val)) {
                                                return null;
                                              }
                                              return "لطفا پر شود";
                                            },
                                          ),
                                          const SizedBox(width: defaultPadding),
                                        ],
                                      ),
                                      //start date,  end date
                                      Row(
                                        children: [
                                          //startDate
                                          MyTextFormField(
                                            initialValue: context
                                                .select<EmployeeCubit,
                                                        Employee>(
                                                    (EmployeeCubit c) => c
                                                        .state.selectedEmployee)
                                                .startDate,
                                            onChange: (String val) {
                                              context
                                                  .read<EmployeeCubit>()
                                                  .startDateChanged(val);
                                            },
                                            myDecoration: myDecoration(
                                                label: 'تاریخ شروع'),
                                            formKey: _formKey,
                                            context: context,
                                            maxLen: 10,
                                            validator: (String? val) {
                                              if (val != null &&
                                                  ReqularExpChecker
                                                      .regExpShamsiDate
                                                      .hasMatch(val)) {
                                                return null;
                                              }
                                              return "لطفا پر شود";
                                            },
                                          ),
                                          const SizedBox(width: defaultPadding),
                                          //endDate
                                          MyTextFormField(
                                            initialValue: context
                                                .select<EmployeeCubit,
                                                        Employee>(
                                                    (EmployeeCubit c) => c
                                                        .state.selectedEmployee)
                                                .endDate,
                                            onChange: (String val) {
                                              context
                                                  .read<EmployeeCubit>()
                                                  .endDateChanged(val);
                                            },
                                            myDecoration: myDecoration(
                                                label: 'تاریخ پایان'),
                                            formKey: _formKey,
                                            context: context,
                                            maxLen: 10,
                                            validator: (String? val) {
                                              // if (val != null &&
                                              //     ReqularExpChecker
                                              //         .regExpShamsiDate
                                              //         .hasMatch(val)) {
                                              return null;
                                              // }
                                              // return "لطفا پر شود";
                                            },
                                          ),
                                          const SizedBox(width: defaultPadding),
                                        ],
                                      ),
                                      //mobile
                                      Row(
                                        children: [
                                          //mobile
                                          MyTextFormField(
                                            initialValue: context
                                                .select<EmployeeCubit,
                                                        Employee>(
                                                    (EmployeeCubit c) => c
                                                        .state.selectedEmployee)
                                                .mobile,
                                            onChange: (String val) {
                                              context
                                                  .read<EmployeeCubit>()
                                                  .mobileChanged(val);
                                            },
                                            myDecoration:
                                                myDecoration(label: 'موبایل'),
                                            formKey: _formKey,
                                            context: context,
                                            maxLen: 11,
                                            validator: (String? val) {
                                              if (val != null &&
                                                  ReqularExpChecker.regExpMobile
                                                      .hasMatch(val)) {
                                                return null;
                                              }
                                              return "لطفا پر شود";
                                            },
                                          ),
                                          const SizedBox(width: defaultPadding),
                                          //id Dar Markaz
                                          MyTextFormField(
                                            initialValue: context
                                                .select<EmployeeCubit,
                                                Employee>(
                                                    (EmployeeCubit c) => c
                                                    .state.selectedEmployee)
                                                .idEmployeeDarMarkaz,
                                            onChange: (String val) {
                                              context
                                                  .read<EmployeeCubit>()
                                                  .idEmployeeDarMarkazChanged(val);
                                            },
                                            myDecoration:
                                            myDecoration(label: 'کدپرسنلی در ستاد'),
                                            formKey: _formKey,
                                            context: context,
                                            maxLen: 11,
                                            validator: (String? val) {
                                              if (val != null &&
                                                  ReqularExpChecker.regExpCodePersonely
                                                      .hasMatch(val)) {
                                                return null;
                                              }
                                              return "لطفا پر شود";
                                            },
                                          ),
                                          const SizedBox(width: defaultPadding),
                                        ],
                                      ),
                                      //center and part
                                      Row(
                                        children: [
                                          !context
                                                  .watch<EmployeeCubit>()
                                                  .state
                                                  .isLoadingCenters
                                              ? const Expanded(
                                                  child: CentersWidget())
                                              : const CircularProgressIndicator(),
                                          const SizedBox(width: defaultPadding),
                                          context
                                                      .watch<EmployeeCubit>()
                                                      .state
                                                      .loadingPartsState ==
                                                  LoadState.loaded
                                              ? const Expanded(
                                                  flex: 1, child: PartsWidget())
                                              : const SizedBox(),
                                        ],
                                      ),

                                      const SizedBox(height: 60),
                                      context.select<EmployeeCubit, bool>(
                                              (EmployeeCubit c) => c
                                                  .state.isUpdatingOrAddingUser)
                                          ? const CircularProgressIndicator()
                                          : _getConfirmButtons(_formKey),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getConfirmButtons(GlobalKey<FormState> formKey) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              //check form validation and drop buttons to be filled
              if (!context.read<EmployeeCubit>().validateForm(formKey)) {
                showMySnackbar(
                    content: "لطفا تمامی ورودی ها را تکمیل نمایید",
                    context: context);
                return;
              }

              bool isAddMode = context.read<EmployeeCubit>().state.isAddMode;
              if (!isAddMode) {
                context.read<EmployeeCubit>().update();
              } else {
                context.read<EmployeeCubit>().add();
              }
            },
            child: const Text("ثبت تغییرات")),
        const SizedBox(width: 20),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<EmployeeCubit>().clearSelectedValues();
              context.read<EmployeeCubit>().initialize();
            },
            child: const Text("انصراف")),
      ],
    );
  }
}

class CentersWidget extends StatelessWidget {
  const CentersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeCubit, EmployeeState>(
      buildWhen: (previous, current) {
        if (previous.selectedCenter != current.selectedCenter ||
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
                    isExpanded: true,
                    // key: UniqueKey(),
                    value: /*state.centers.firstWhere(
                        (c) => c.id == state.selectedEntity.idCenter,
                        ),*/

                        context.watch<EmployeeCubit>().state.selectedCenter ==
                                Centers.empty
                            ? null
                            : context
                                .watch<EmployeeCubit>()
                                .state
                                .selectedCenter,
                    items: state.centers
                        .map((Centers j) => DropdownMenuItem<Centers>(
                            value: j,
                            child: Text(
                              j.name,
                              overflow: TextOverflow.ellipsis,
                            )))
                        .toList(),
                    onChanged: (Centers? j) {
                      if (j != null) {
                        context.read<EmployeeCubit>().selectedCenterChanged(j);
                        //after selecting a center, get this center's parts
                        context
                            .read<EmployeeCubit>()
                            .getPartsForSelectedCenter(j.id);
                      }
                    },
                  ),
          ],
        );
      },
    );
  }
}

class PartsWidget extends StatelessWidget {
  const PartsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeCubit, EmployeeState>(
      buildWhen: (previous, current) {
        if (previous.selectedPart != current.selectedPart ||
            previous.parts != current.parts) {
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
              isExpanded: true,
              // key: UniqueKey(),
              value: /*state.centers.firstWhere(
                        (c) => c.id == state.selectedEntity.idCenter,
                        ),*/

                  context.watch<EmployeeCubit>().state.selectedPart ==
                          Part.empty
                      ? null
                      :
                      //after re fetching centers list, selected part must be null
                      context.watch<EmployeeCubit>().state.selectedPart,
              items: state.parts
                  .map((Part j) =>
                      DropdownMenuItem<Part>(value: j, child: Text(j.name)))
                  .toList(),
              onChanged: (Part? j) {
                if (j != null) {
                  context.read<EmployeeCubit>().selectedPartChanged(j);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
