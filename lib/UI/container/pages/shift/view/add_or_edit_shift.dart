import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shifter/UI/container/pages/shift/bloc/shift_cubit.dart';
import 'package:shifter/helpers/helper_methods.dart';
import 'package:shifter/helpers/images.dart';

import '../../../../../helpers/constants.dart';
import '../../../../../helpers/my_custom_scrol_behavour.dart';
import '../../../../../helpers/regular_exp_checker.dart';
import '../../../../../models/shift.dart';
import '../../../../../responsive.dart';
import '../../../../../widgets/my_text_form_field.dart';

class AddOrEditShiftPage extends StatelessWidget {
  static const String route = "/dataEntry/addEditShift";

  const AddOrEditShiftPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ViewD();
  }
}

class ViewD extends StatefulWidget {
  const ViewD({Key? key}) : super(key: key);

  @override
  State<ViewD> createState() => _ViewState();
}

class _ViewState extends State<ViewD> {
  final _formKey = GlobalKey<FormState>();

  //these controllers are needed to set the text field's texts from time picker.
  //because there is no other way to give value to text field with code.
  final TextEditingController _allowedStartController = TextEditingController();
  final TextEditingController _allowedEndController = TextEditingController();

  // Use the didChangeDependencies method which gets called after initState
  @override
  void didChangeDependencies() {
    //if it is edit mode, set prefilled form
    if (!context.read<ShiftCubit>().state.isAddMode) {
      String s =
          context.watch<ShiftCubit>().state.selectedShift.allowedStartTime;
      String e = context.watch<ShiftCubit>().state.selectedShift.allowedEndTime;
      _allowedStartController.text = s;
      _allowedEndController.text = e;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: context.read<ShiftCubit>().state.isAddMode
            ? const Text("تعریف شیفت جدید")
            : const Text("ویرایش شیفت"),
      ),
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          SvgPicture.asset(Images.shiftSvg, height: 500),
          BlocListener<ShiftCubit, ShiftState>(
            listenWhen: (prev, curr) =>
                prev.isUpdatingOrAdding == true &&
                curr.isUpdatingOrAdding == false,
            listener: (context, state) {
              if (!state.isUpdatingOrAdding) {
                showMyModal(context, Text(state.message));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: context.select<ShiftCubit, bool>(
                      (ShiftCubit c) => c.state.isLoading)
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
                                      //first row
                                      FirstRow(_formKey),
                                      const SizedBox(height: 24),
//----------------------------------------------------------------------
                                      //second row
                                      Row(
                                        children: [
                                          //empty space fot ui fit
                                          const Expanded(child: SizedBox()),
                                          const SizedBox(width: defaultPadding),
                                          //allowed start time
                                          IconButton(
                                              onPressed: () async {
                                                TimeOfDay? picked =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now(),
                                                );
                                                if (!mounted) return;
                                                if (picked != null) {
                                                  String time =
                                                      picked.format(context);
                                                  _allowedStartController.text =
                                                      time;
                                                  context
                                                      .read<ShiftCubit>()
                                                      .allowedStartTimeChanged(
                                                          time);
                                                }
                                              },
                                              icon:
                                                  const Icon(Icons.more_time)),
                                          MyTextFormField(
                                            controller: _allowedStartController,
                                            //if you have set controller so can not set initialValue. will raise error
                                            /*      initialValue: context
                                              .select<ShiftCubit, Shift>(
                                                  (ShiftCubit c) =>
                                                      c.state.selectedShift)
                                              .startTime,*/
                                            onChange: (String val) {
                                              context
                                                  .read<ShiftCubit>()
                                                  .allowedStartTimeChanged(val);
                                            },
                                            myDecoration: myDecoration(
                                                label: 'ورود مجاز'),
                                            formKey: _formKey,
                                            context: context,
                                            maxLen: 5,
                                            validator: (String? val) {
                                              if (val != null &&
                                                  ReqularExpChecker
                                                      .regExpTimePersian5
                                                      .hasMatch(val)) {
                                                return null;
                                              }
                                              return "لطفا در قالب 00:00 پر شود";
                                            },
                                          ),
                                          const SizedBox(width: defaultPadding),
                                          //allowed end time
                                          IconButton(
                                              onPressed: () async {
                                                TimeOfDay? picked =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now(),
                                                );
                                                if (!mounted) return;
                                                if (picked != null) {
                                                  String time =
                                                      picked.format(context);
                                                  _allowedEndController.text =
                                                      time;
                                                  context
                                                      .read<ShiftCubit>()
                                                      .allowedEndTimeChanged(
                                                          time);
                                                }
                                              },
                                              icon:
                                                  const Icon(Icons.more_time)),
                                          MyTextFormField(
                                            controller: _allowedEndController,
                                            /*          initialValue: context
                                              .select<ShiftCubit, Shift>(
                                                  (ShiftCubit c) =>
                                                      c.state.selectedShift)
                                              .endTime,*/
                                            onChange: (String val) {
                                              context
                                                  .read<ShiftCubit>()
                                                  .allowedEndTimeChanged(val);
                                            },
                                            myDecoration: myDecoration(
                                                label: 'خروج مجاز'),
                                            formKey: _formKey,
                                            context: context,
                                            maxLen: 5,
                                            validator: (String? val) {
                                              if (val != null &&
                                                  ReqularExpChecker.regExpTime5
                                                      .hasMatch(val)) {
                                                return null;
                                              }
                                              return "لطفا پر شود";
                                            },
                                          ),
                                          const SizedBox(width: defaultPadding),
                                          //today  radio
                                          Row(
                                            children: [
                                              const Text('امروز'),
                                              Checkbox(
                                                  value: context
                                                              .watch<
                                                                  ShiftCubit>()
                                                              .state
                                                              .selectedShift
                                                              .validEndForToday ==
                                                          1
                                                      ? true
                                                      : false,
                                                  onChanged: (bool? val) {
                                                    val = val ?? false;
                                                    //آیا بازه ی مجاز پایان امروزه یا فردا.
                                                    context
                                                        .read<ShiftCubit>()
                                                        .validEndIsTodayChanged(
                                                            val);
                                                  }),
                                            ],
                                          ),
                                          const SizedBox(width: defaultPadding),
                                          //tomorrow  radio
                                          Row(
                                            children: [
                                              const Text('فردا'),
                                              Checkbox(
                                                  value: context
                                                              .watch<
                                                                  ShiftCubit>()
                                                              .state
                                                              .selectedShift
                                                              .validEndForToday ==
                                                          0
                                                      ? true
                                                      : false,
                                                  onChanged: (bool? val) {
                                                    val = val ?? false;
                                                    //آیا بازه ی مجاز پایان امروزه یا فردا.
                                                    context
                                                        .read<ShiftCubit>()
                                                        .validEndIsTodayChanged(
                                                            !val);
                                                  }),
                                            ],
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 60),
                                      context.select<ShiftCubit, bool>(
                                              (ShiftCubit c) =>
                                                  c.state.isUpdatingOrAdding)
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
          )
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
              if (!formKey.currentState!.validate()) return;

              bool isAddMode = context.read<ShiftCubit>().state.isAddMode;
              if (!isAddMode) {
                context.read<ShiftCubit>().update();
              } else {
                context.read<ShiftCubit>().add();
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

class FirstRow extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const FirstRow(this.formKey, {Key? key}) : super(key: key);

  @override
  State<FirstRow> createState() => _FirstRowState();
}

class _FirstRowState extends State<FirstRow> {
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  // this method gets called after init state() and because we have watch which can change state while init state has not completed, error happens. to prevent error, we call these watch() methods after init state safely.
  @override
  void didChangeDependencies() {
    //if it is edit mode, set prefilled form
    if (!context.read<ShiftCubit>().state.isAddMode) {
      //todo  should i use watch?   make a delay to see
      String s = context.read<ShiftCubit>().state.selectedShift.startTime;
      String e = context.read<ShiftCubit>().state.selectedShift.endTime;
      _startTimeController.text = s;
      _endTimeController.text = e;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //name
        MyTextFormField(
          initialValue: context
              .select<ShiftCubit, Shift>(
                  (ShiftCubit c) => c.state.selectedShift)
              .name,
          onChange: (String val) {
            context.read<ShiftCubit>().nameChanged(val);
          },
          myDecoration: myDecoration(label: 'نام شیفت'),
          formKey: widget.formKey,
          context: context,
          maxLen: 20,
          validator: (String? val) {
            if (val != null && val.isNotEmpty) {
              return null;
            }
            return "لطفا پر شود";
          },
        ),
        const SizedBox(width: defaultPadding),
        //start time
        IconButton(
            onPressed: () async {
              TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (!mounted) return;
              if (picked != null) {
                String time = picked.format(context);
                _startTimeController.text = time;
                context.read<ShiftCubit>().startTimeChanged(time);
              }
            },
            icon: const Icon(Icons.more_time)),
        MyTextFormField(
          controller: _startTimeController,
          //if you have set controller so can not set initialValue. will raise error
          /*      initialValue: context
                                            .select<ShiftCubit, Shift>(
                                                (ShiftCubit c) =>
                                                    c.state.selectedShift)
                                            .startTime,*/
          onChange: (String val) {
            context.read<ShiftCubit>().startTimeChanged(val);
          },
          myDecoration: myDecoration(label: 'ساعت شروع'),
          formKey: widget.formKey,
          context: context,
          maxLen: 5,
          validator: (String? val) {
            if (val != null && ReqularExpChecker.regExpTime5.hasMatch(val)) {
              return null;
            }
            return "لطفا در قالب 00:00 پر شود";
          },
        ),
        const SizedBox(width: defaultPadding),
        //end time
        IconButton(
            onPressed: () async {
              TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (!mounted) return;
              if (picked != null) {
                String time = picked.format(context);
                _endTimeController.text = time;
                context.read<ShiftCubit>().endTimeChanged(time);
              }
            },
            icon: const Icon(Icons.more_time)),
        MyTextFormField(
          controller: _endTimeController,
          onChange: (String val) {
            context.read<ShiftCubit>().endTimeChanged(val);
          },
          myDecoration: myDecoration(label: 'ساعت پایان'),
          formKey: widget.formKey,
          context: context,
          maxLen: 5,
          validator: (String? val) {
            if (val != null && ReqularExpChecker.regExpTime5.hasMatch(val)) {
              return null;
            }
            return "لطفا پر شود";
          },
        ),
        const SizedBox(width: defaultPadding),
        //today end time radio
        Row(
          children: [
            const Text('امروز'),
            Checkbox(
                value:
                    context.watch<ShiftCubit>().state.selectedShift.endsToday ==
                            1
                        ? true
                        : false,
                onChanged: (bool? val) {
                  val = val ?? false;
                  //آیاساعت پایان امروزه یا فردا.
                  context.read<ShiftCubit>().endTimeIsTodayChanged(val);
                }),
          ],
        ),
        const SizedBox(width: defaultPadding),
        //tomorrow end time radio
        Row(
          children: [
            const Text('فردا'),
            Checkbox(
                value:
                    context.watch<ShiftCubit>().state.selectedShift.endsToday ==
                            0
                        ? true
                        : false,
                onChanged: (bool? val) {
                  val = val ?? false;
                  //آیا ساعت پایان امروزه یا فردا.
                  context.read<ShiftCubit>().endTimeIsTodayChanged(!val);
                }),
          ],
        ),
        /*   Expanded(
                                        child: CheckboxListTile(
                                            title: const Text(
                                                'آیا ساعت پایان تا فرداست؟'),
                                            value: context
                                                .watch<ShiftCubit>()
                                                .state
                                                .selectedShift
                                                .endsTomorrow,
                                            onChanged: (bool? val) {
                                              context
                                                  .read<ShiftCubit>()
                                                  .toggleEndsTomorrow();
                                            }),
                                      ),*/
      ],
    );
  }
}
