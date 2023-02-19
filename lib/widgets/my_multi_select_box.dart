import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class GetMultiSelectBox<T> extends StatelessWidget {
  final List<T>  initialValue;
  final List<MultiSelectItem<T>> items;
  final void Function(List<T>) confirm;
  final String searchHint;
  final Text? buttonText;

  const GetMultiSelectBox(
      {Key? key,
      required this.initialValue,
      required this.items,
      required this.confirm,
      required this.searchHint,
      required this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField<T>(
/*      unselectedColor: context.read<MyThemeCubit>().state.isDarkMode
          ? chipUnselectedDark
          : null,
      selectedColor: context.read<MyThemeCubit>().state.isDarkMode
          ? chipSelectedDark.withOpacity(0.5)
          : null,*/

      confirmText: const Text('تایید'),
      cancelText: const Text('لغو'),
      title: const Text('انتخاب کنید'),
      searchHint: searchHint,
      buttonText: buttonText,
      searchable: true,
      initialValue: initialValue,
      items: items,
      listType: MultiSelectListType.CHIP,
      onConfirm: (values) {
        confirm(values);
      },
    );
  }
}
