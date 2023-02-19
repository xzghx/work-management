import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../helpers/constants.dart';
import '../../../../../helpers/helper_methods.dart';
import '../../../../../helpers/images.dart';
import '../../../../../helpers/my_custom_scrol_behavour.dart';
import '../../../../../helpers/regular_exp_checker.dart';
import '../../../../../models/admin_users.dart';
import '../../../../../repositories/user_repository.dart';
import '../../../../../responsive.dart';
import '../../../../../widgets/my_text_form_field.dart';
import '../../../../authentication/bloc/authentication_bloc.dart';
import 'bloc/profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AdminUser u = context.read<AuthBloc>().state.user;
    return BlocProvider(
      create: (context) => ProfileCubit(
        token: context.read<AuthBloc>().state.user.token,
        userRepo: RepositoryProvider.of<UserRepository>(context),
        user: ProfileUser(
          id: u.id,
          name: u.name,
          lastName: u.lastName,
          userName: u.userName,
          mobile: u.mobile,
        ),
      ),
      child: Viewp(),
    );
  }
}

Widget _getConfirmButtons(GlobalKey<FormState> formKey, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ElevatedButton(
          onPressed: () {
            //check form validation and drop buttons to be filled
            if (!context.read<ProfileCubit>().validateProfileForm(formKey)) {
              showMySnackbar(
                  content: "لطفا تمامی ورودی ها را تکمیل نمایید",
                  context: context);
              return;
            }
            context.read<ProfileCubit>().updateProfileInfo();
          },
          child: const Text("ثبت تغییرات")),
      const SizedBox(width: 20),
      ElevatedButton(
          onPressed: () {
            context.read<ProfileCubit>().initialize();
          },
          child: const Text("انصراف")),
    ],
  );
}

Widget _getConfirmButtonsPassword(
    GlobalKey<FormState> formKey, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ElevatedButton(
          onPressed: () {
            //check form validation and drop buttons to be filled
            if (!context.read<ProfileCubit>().validatePasswordForm(formKey)) {
              showMySnackbar(
                  content: "لطفا رمز عبور را صحیح وارد نمایید",
                  context: context);
              return;
            }
            context.read<ProfileCubit>().updatePassword();
          },
          child: const Text("تغییر رمز ورود")),
      const SizedBox(width: 20),
      /*   ElevatedButton(
          onPressed: () {
            context.read<ProfileCubit>().initialize();
          },
          child: const Text("انصراف")),*/
    ],
  );
}

class Viewp extends StatelessWidget {
  final GlobalKey<FormState> _formKeyProfile = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyPassword = GlobalKey<FormState>();

  Viewp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          SvgPicture.asset(
            Images.employeeInfoSvg,
            fit: BoxFit.contain,
            height: 400,
          ),
          BlocListener<ProfileCubit, ProfileState>(
            listenWhen: (prev, curr) =>
                prev.isUpdating == true && curr.isUpdating == false ||
                prev.user != curr.user,
            listener: (context, state) {
              if (!state.isUpdating && state.message.isNotEmpty) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Center(
                child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKeyProfile,
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
                                          .select<ProfileCubit, ProfileUser>(
                                              (ProfileCubit c) => c.state.user)
                                          .name,
                                      onChange: (String val) {
                                        context
                                            .read<ProfileCubit>()
                                            .nameChanged(val);
                                      },
                                      myDecoration: myDecoration(label: 'نام'),
                                      formKey: _formKeyProfile,
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
                                    //last name
                                    MyTextFormField(
                                      initialValue: context
                                          .select<ProfileCubit, ProfileUser>(
                                              (ProfileCubit c) => c.state.user)
                                          .lastName,
                                      onChange: (String val) {
                                        context
                                            .read<ProfileCubit>()
                                            .lastNameChanged(val);
                                      },
                                      myDecoration:
                                          myDecoration(label: 'نام خانوادگی'),
                                      formKey: _formKeyProfile,
                                      context: context,
                                      maxLen: 30,
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
                                //mobile -  userName
                                Row(
                                  children: [
                                    //mobile
                                    MyTextFormField(
                                      initialValue: context
                                          .select<ProfileCubit, ProfileUser>(
                                              (ProfileCubit c) => c.state.user)
                                          .mobile,
                                      onChange: (String val) {
                                        context
                                            .read<ProfileCubit>()
                                            .mobileChanged(val);
                                      },
                                      myDecoration:
                                          myDecoration(label: 'موبایل'),
                                      formKey: _formKeyProfile,
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
                                    //userName
                                    MyTextFormField(
                                      initialValue: context
                                          .select<ProfileCubit, ProfileUser>(
                                              (ProfileCubit c) => c.state.user)
                                          .userName,
                                      onChange: (String val) {
                                        context
                                            .read<ProfileCubit>()
                                            .userNameChanged(val);
                                      },
                                      myDecoration:
                                          myDecoration(label: 'نام کاربری'),
                                      formKey: _formKeyProfile,
                                      context: context,
                                      maxLen: 15,
                                      validator: (String? val) {
                                        if (val != null &&
                                            ReqularExpChecker.regUserName
                                                .hasMatch(val)) {
                                          return null;
                                        }
                                        return "لطفا پر شود";
                                      },
                                    ),
                                    const SizedBox(width: defaultPadding),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                context.select<ProfileCubit, bool>(
                                        (ProfileCubit c) => c.state.isUpdating)
                                    ? const CircularProgressIndicator()
                                    : _getConfirmButtons(
                                        _formKeyProfile, context),
                                const SizedBox(height: 30),

                                //new password -  confirmed password
                                Form(
                                  key: _formKeyPassword,
                                  child: Row(
                                    children: [
                                      //new password
                                      MyTextFormField(
                                        initialValue: context
                                            .select<ProfileCubit, String>(
                                                (ProfileCubit c) =>
                                                    c.state.newPassword),
                                        onChange: (String val) {
                                          context
                                              .read<ProfileCubit>()
                                              .passwordChanged(val);
                                        },
                                        myDecoration: myDecoration(
                                            label: 'رمز عبور جدید'),
                                        formKey: _formKeyPassword,
                                        context: context,
                                        maxLen: 11,
                                        validator: (String? val) {
                                          if (val != null &&
                                              ReqularExpChecker.regExpPassword
                                                  .hasMatch(val)) {
                                            return null;
                                          }
                                          return "رمز عبور معتبر نیست";
                                        },
                                      ),
                                      const SizedBox(width: defaultPadding),
                                      // confirmed new password
                                      MyTextFormField(
                                        initialValue: context
                                            .select<ProfileCubit, String>(
                                                (ProfileCubit c) =>
                                                    c.state.confirmedPassword),
                                        onChange: (String val) {
                                          context
                                              .read<ProfileCubit>()
                                              .confirmedPasswordChanged(val);
                                        },
                                        myDecoration: myDecoration(
                                            label: 'تکرار رمز عبور'),
                                        formKey: _formKeyPassword,
                                        context: context,
                                        maxLen: 11,
                                        validator: (String? val) {
                                          if (val != null &&
                                              context
                                                  .read<ProfileCubit>()
                                                  .passwordsMatch()) {
                                            return null;
                                          }
                                          return "تکرار رمز عبور مطابقت ندارد";
                                        },
                                      ),
                                      const SizedBox(width: defaultPadding),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                context.select<ProfileCubit, bool>(
                                        (ProfileCubit c) => c.state.isUpdating)
                                    ? const CircularProgressIndicator()
                                    : _getConfirmButtonsPassword(
                                        _formKeyPassword, context),
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
}
