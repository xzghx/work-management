import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../helpers/constants.dart';
import '../../../../../helpers/images.dart';
import '../../../../../helpers/my_custom_scrol_behavour.dart';
import '../../../../../helpers/regular_exp_checker.dart';
import '../../../../../models/centers.dart';
import '../../../../../responsive.dart';
import '../../../../../widgets/my_text_form_field.dart';
import '../bloc/part_cubit.dart';

class AddOrEditPartPage extends StatelessWidget {
  static const String route = "/dataEntry/addEditPart";

  const AddOrEditPartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ViewC();
  }
}

class ViewC extends StatefulWidget {
  const ViewC({Key? key}) : super(key: key);

  @override
  State<ViewC> createState() => _ViewState();
}

class _ViewState extends State<ViewC> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  //watch must not be used in initState
  //and can be used inside  didChangeDependencies
  @override
  void didChangeDependencies() {
    //note that read can not help
    _nameController.text = context.watch<PartCubit>().state.selectedEntity.name;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        context.read<PartCubit>().state.centers.isNotEmpty
            ? context.read<PartCubit>().getPartsForFilteredCenter(
                context.read<PartCubit>().state.centers.first.id)
            : null;
        return Future(() => true);
      },
      child: Scaffold(
          appBar: AppBar(
            title: context.read<PartCubit>().state.isAddMode
                ? const Text("افزودن بخش جدید")
                : const Text("ویرایش بخش"),
          ),
          body: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              SvgPicture.asset(
                Images.partsSvg,
                fit: BoxFit.contain,
                height: 500,
              ),
              BlocListener<PartCubit, PartState>(
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
                  child: context.select<PartCubit, bool>(
                          (PartCubit c) => c.state.isLoading)
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
                                          BlocBuilder<PartCubit, PartState>(
                                            buildWhen: (prev, cur) {
                                              if (prev.isLoadingCenters !=
                                                  cur.isLoadingCenters) {
                                                return true;
                                              } else if (prev.selectedEntity !=
                                                  cur.selectedEntity) {
                                                return true;
                                              }
                                              return false;
                                            },
                                            builder: (context, state) {
                                              return Row(
                                                children: [
                                                  // const Expanded(flex: 1, child: SizedBox()),
                                                  MyTextFormField(
                                                    controller: _nameController,
                                                    onChange: (String val) {
                                                      context
                                                          .read<PartCubit>()
                                                          .nameChanged(val);
                                                    },
                                                    myDecoration: myDecoration(
                                                        label: 'نام'),
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
                                                  const SizedBox(
                                                      width: defaultPadding),

                                                  /*    context
                                                    .watch<PartCubit>()
                                                    .*/
                                                  !state.isLoadingCenters
                                                      ? const Flexible(
                                                          flex: 1,
                                                          child:
                                                              CentersWidgett())
                                                      : const CircularProgressIndicator(),
                                                ],
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 60),
                                          context.select<PartCubit, bool>(
                                                  (PartCubit c) => c.state
                                                      .isUpdatingOrAddingUser)
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
          )),
    );
  }

  Widget _getConfirmButtons(GlobalKey<FormState> formKey) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;

              bool isAddMode = context.read<PartCubit>().state.isAddMode;
              if (!isAddMode) {
                context.read<PartCubit>().update();
              } else {
                context.read<PartCubit>().add();
              }
            },
            child: const Text("ثبت تغییرات")),
        const SizedBox(width: 20),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<PartCubit>().clearSelectedPartAndCenter();
            },
            child: const Text("انصراف")),
      ],
    );
  }
}

class CentersWidgett extends StatelessWidget {
  const CentersWidgett({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartCubit, PartState>(
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
                    // key: UniqueKey(),
                    value: /*state.centers.firstWhere(
                            (c) => c.id == state.selectedEntity.idCenter,
                            ),*/

                        context.watch<PartCubit>().state.selectedCenter ==
                                Centers.empty
                            ? null
                            : context.watch<PartCubit>().state.selectedCenter,
                    items: state.centers
                        .map((Centers j) => DropdownMenuItem<Centers>(
                            value: j,
                            child: SizedBox(
                                width: 200,
                                child: Text(j.name,
                                    overflow: TextOverflow.ellipsis))))
                        .toList(),
                    onChanged: (Centers? j) {
                      if (j != null) {
                        context.read<PartCubit>().selectedCenterChanged(j);
                      }
                    },
                  ),
          ],
        );
      },
    );
  }
}
