import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final void Function() onSearch;
  final void Function(String? value) onChange;
  final String? initialValue;

  const SearchBox({
    Key? key,
    required this.onSearch,
    required this.onChange,
    this.initialValue ='',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLength: 30,
      onChanged: (String value) {
        onChange(value);
      },
      decoration: InputDecoration(
        counterText: "",
          hintText: 'جستوجوی نام، کدپرسنلی،...',
          suffixIcon: IconButton(
            onPressed: onSearch,
            icon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.secondary,
            ),
          )),
    );
  }
}
