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
import '../bloc/center_cubit.dart';

class AddOrEditCentersPage extends StatelessWidget {
  static const String route = "/dataEntry/addEditCenters";

  const AddOrEditCentersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ViewA();
  }
}

class ViewA extends StatefulWidget {
  const ViewA({Key? key}) : super(key: key);

  @override
  State<ViewA> createState() => _ViewState();
}

class _ViewState extends State<ViewA> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: context.read<CentersCubit>().state.isAddMode
            ? const Text("افزودن مرکز جدید")
            : const Text("ویرایش مرکز"),
      ),
      body:Stack(
alignment: Alignment.bottomLeft,
        children: [
          SvgPicture.asset(
            Images.centerSvg,
            fit: BoxFit.fitWidth,
            height: 500,
          ),
          BlocListener<CentersCubit, CentersState>(
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
              child: context.select<CentersCubit, bool>(
                      (CentersCubit c) => c.state.isLoading)
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
                                Row(
                                  children: [
                                    // const Expanded(flex: 1, child: SizedBox()),
                                    MyTextFormField(
                                      initialValue: context
                                          .select<CentersCubit, Centers>(
                                              (CentersCubit c) =>
                                          c.state.selectedCenter)
                                          .name,
                                      onChange: (String val) {
                                        context
                                            .read<CentersCubit>()
                                            .nameChanged(val);
                                      },
                                      myDecoration:
                                      myDecoration(label: 'نام'),
                                      formKey: _formKey,
                                      context: context,
                                      maxLen: 20,
                                      validator: (String? val) {
                                        if (val != null &&
                                            ReqularExpChecker.regExpNameReg
                                                .hasMatch(val)) {
                                          return null;
                                        }
                                        return "لطفا پر شود";
                                      },
                                    ),
                                    const SizedBox(width: defaultPadding),
                                  ],
                                ),
                                const SizedBox(height: 60),
                                context.select<CentersCubit, bool>(
                                        (CentersCubit c) =>
                                    c.state.isUpdatingOrAddingUser)
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
      )

    );
  }

  Widget _getConfirmButtons(GlobalKey<FormState> formKey) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;

              bool isAddMode = context.read<CentersCubit>().state.isAddMode;
              if (!isAddMode) {
                context.read<CentersCubit>().update();
              } else {
                context.read<CentersCubit>().add();
              }
            },
            child: const Text("ثبت تغییرات")),
        const SizedBox(width: 20),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("انصراف")),
      ],
    );
  }
}
