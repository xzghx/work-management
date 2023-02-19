import 'package:flutter/material.dart';

import '../helpers/my_colors.dart';
import '../models/drop_down_base.dart';

InputDecoration myDecoration({required String label}) {
  return InputDecoration(
    labelText: label,
    contentPadding: const EdgeInsets.all(10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: accentColor),
    ),
  );
}

class MyTextFormField extends StatelessWidget {
  final int flex;
  final bool useExpanded;
  final BuildContext context;
  final GlobalKey<FormState>? formKey;
  final InputDecoration? myDecoration;
  final Function(String val)? onChange;
  final String? Function(String? val)? validator;
  final bool enable;
  final int? maxLen;
  final String? initialValue;
  final TextEditingController? controller;
  // late final TextInputType? textInputType;

  //todo consider input type
  const MyTextFormField({
    Key? key,
    this.flex = 1,
    this.useExpanded = true,
    required this.context,
    this.formKey,
    this.myDecoration,
    this.onChange,
    this.validator,
    this.enable = true,
    this.maxLen,
    this.initialValue,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return useExpanded
        ? Expanded(
            flex: flex,
            child: TextFormField(
              controller: controller,
              enabled: enable,
              initialValue: initialValue,
              maxLength: maxLen,
              // The validator receives the text that the user has entered.
              validator: validator,
              // keyboardType: textInputType,
              onChanged: (String val) {
                onChange != null ? onChange!(val) : null;
                formKey?.currentState!.validate();
              },
              decoration: myDecoration,
            ),
          )
        : TextFormField(
            enabled: enable,
            initialValue: initialValue,
            maxLength: maxLen,
            // The validator receives the text that the user has entered.
            validator: validator,
            // keyboardType: textInputType,
            onChanged: (String val) {
              onChange != null ? onChange!(val) : null;
              formKey?.currentState!.validate();
            },
            decoration: myDecoration,
          );
  }
}
/*   MyTextFormField({
     required BuildContext context,
    required formKey,
    required myDecoration,
    onChange,
    validator,
    enable = true,
    maxLen,
    initialValue,
  }) {

 return Expanded(
   child: TextFormField(
     enabled: enable,
     initialValue: initialValue,
     maxLength: maxLen,
     // The validator receives the text that the user has entered.
     validator: validator,

     onChanged: (String val) {
       onChange != null ? onChange!(val) : null;
       formKey.currentState!.validate();
     },
     decoration: myDecoration,
   ),
 ) ;

}*/

DropdownButton getDropButton({
  required List<DropDownBase> customList,
  required BuildContext ctx,
  required void Function(DropDownBase?) onSelect,
  DropDownBase? initialSelectedValue,
}) {
  return DropdownButton<DropDownBase>(
    // Initial Value
    value: initialSelectedValue,
    // Down Arrow Icon
    icon: const Icon(Icons.keyboard_arrow_down),
    // Array list of items
    items: customList.map((DropDownBase city) {
      return DropdownMenuItem<DropDownBase>(
        value: city,
        child: Text(city.title),
      );
    }).toList(),
    // After selecting the desired option,it will
    // change button value to selected value
    onChanged: onSelect,
  );
}
