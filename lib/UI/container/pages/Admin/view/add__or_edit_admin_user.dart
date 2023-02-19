import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../../../../helpers/constants.dart';
import '../../../../../helpers/my_custom_scrol_behavour.dart';
import '../../../../../helpers/regular_exp_checker.dart';
import '../../../../../models/admin_users.dart';
import '../../../../../models/centers.dart';
import '../../../../../responsive.dart';
import '../../../../../widgets/my_multi_select_box.dart';
import '../../../../../widgets/my_text_form_field.dart';
import '../bloc/admin_cubit.dart';

class AddOrEditAdminPage extends StatelessWidget {
  static const String route = "/AdminUsers/AddOrEditAdmin";

  const AddOrEditAdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const View();
  }
}

class View extends StatefulWidget {
  const View({Key? key}) : super(key: key);

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    AdminUser user = context
        .select<AdminCubit, AdminUser>((AdminCubit c) => c.state.selectedUser);
    return Scaffold(
      appBar: AppBar(
        title: context.read<AdminCubit>().state.isAddMode
            ? const Text("عضویت کاربر جدید")
            : const Text("ویرایش کاربر"),
      ),
      body: BlocListener<AdminCubit, AdminState>(
        listenWhen: (prev, curr) =>
            prev.isUpdatingUser == true && curr.isUpdatingUser == false,
        listener: (context, state) {
          if (!state.isUpdatingUser) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: context
                  .select<AdminCubit, bool>((AdminCubit c) => c.state.isLoading)
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
                                      _getName(user, _formKey, context),
                                      const SizedBox(width: defaultPadding),
                                      _getLastName(user, _formKey, context),
                                      // const Expanded(flex: 1, child: SizedBox()),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      // const Expanded(flex: 1, child: SizedBox()),
                                      _getMobile(user, _formKey, context),
                                      const SizedBox(width: defaultPadding),

                                      const Expanded(child: AccessInput()),
                                      // const Expanded(flex: 1, child: SizedBox()),
                                    ],
                                  ),
                                  Row(
                                    children:const [
                                       Expanded(flex: 1, child: SizedBox()),
                                        SizedBox(width: defaultPadding),

                                        Expanded(child: AccessCentersInput()),
                                      // const Expanded(flex: 1, child: SizedBox()),
                                    ],
                                  ),
                                  const SizedBox(height: 60),
                                  context.select<AdminCubit, bool>(
                                          (AdminCubit c) =>
                                              c.state.isUpdatingUser)
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
    );
  }

  Widget _getConfirmButtons(GlobalKey<FormState> formKey) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;

              bool isAddMode = context.read<AdminCubit>().state.isAddMode;
              if (!isAddMode) {
                context.read<AdminCubit>().updateUser();
              } else {
                context.read<AdminCubit>().addUser();
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

Widget _getLastName(
    AdminUser user, GlobalKey<FormState> formKey, BuildContext context) {
  return MyTextFormField(
    formKey: formKey,
    initialValue: user.lastName,
    onChange: (String val) {
      context.read<AdminCubit>().lastNameChanged(val);
    },
    myDecoration: myDecoration(label: 'نام خانوادگی'),
    context: context,
    maxLen: 20,
    validator: (String? val) {
      if (val != null && ReqularExpChecker.regExpNameReg.hasMatch(val)) {
        return null;
      }
      return "لطفا پر شود";
    },
  );
}

Widget _getName(AdminUser user, formKey, BuildContext context) {
  return MyTextFormField(
    initialValue: user.name,
    onChange: (String val) {
      context.read<AdminCubit>().nameChanged(val);
    },
    myDecoration: myDecoration(label: 'نام'),
    formKey: formKey,
    context: context,
    maxLen: 20,
    validator: (String? val) {
      if (val != null && ReqularExpChecker.regExpNameReg.hasMatch(val)) {
        return null;
      }
      return "لطفا پر شود";
    },
  );
}

Widget _getMobile(
    AdminUser user, GlobalKey<FormState> formKey, BuildContext context) {
  return MyTextFormField(
    formKey: formKey,
    initialValue: user.mobile,
    onChange: (String val) {
      context.read<AdminCubit>().mobilChanged(val);
    },
    myDecoration: myDecoration(label: 'موبایل'),
    context: context,
    maxLen: 11,
    validator: (String? val) {
      if (val != null && ReqularExpChecker.regExpMobile.hasMatch(val)) {
        return null;
      }
      return "موبایل صحیح نیست";
    },
  );
}

class AccessInput extends StatelessWidget {
  const AccessInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      buildWhen: (previous, current) {
        if (previous.selectAccessTypes != current.selectAccessTypes ||
            previous.accessTypes != current.accessTypes) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('دسترسی های کاربر:'),
            state.isLoadingAccess == true
                ? const CircularProgressIndicator()
                : GetMultiSelectBox<Access>(
                    initialValue:
                        state.selectedUser.getAccessesAsList(state.accessTypes),
                    items: state.accessTypes
                        .map((e) => MultiSelectItem<Access>(e, e.title))
                        .toList(),
                    confirm: (List<Access> values) {
                      BlocProvider.of<AdminCubit>(context).accessChanged(
                          accesses: values.isEmpty ? [] : values);
                    },
                    searchHint: 'جستوجو دسترسی',
                    buttonText: const Text('انتخاب کنید'),
                  )
          ],
        );
      },
    );
  }
}

class AccessCentersInput extends StatelessWidget {
  const AccessCentersInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      buildWhen: (previous, current) {
        if (previous.selectedCenters != current.selectedCenters ||
            previous.centers != current.centers) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('دسترسی به مراکز:'),
            state.isLoadingCenters == true
                ? const CircularProgressIndicator()
                : GetMultiSelectBox<Centers>(
              initialValue:
              state.selectedUser.getAccessesCentersAsList(state.centers),
              items: state.centers
                  .map((e) => MultiSelectItem<Centers>(e, e.name))
                  .toList(),
              confirm: (List<Centers> values) {

                BlocProvider.of<AdminCubit>(context).accessToCenterChanged(

                    accessCenters: values.isEmpty ? [] : values);
              },
              searchHint: 'جستوجو مرکز',
              buttonText: const Text('انتخاب کنید'),
            )
          ],
        );
      },
    );
  }
}
