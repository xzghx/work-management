import 'package:flutter/material.dart';

class PaginationButtons extends StatelessWidget {
  final void Function() onNextClick;
  final void Function() onPreviousClick;
  final String currentPage;
  final String totalPages;

  const PaginationButtons(
      {Key? key,
        required this.onNextClick,
        required this.onPreviousClick,
        required this.currentPage,
        required this.totalPages})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //arrow right
        IconButton(
          tooltip: 'صفحه بعد',
          onPressed: onNextClick,
          icon: Icon(
            Icons.arrow_circle_right_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Text("صفحه $currentPage از $totalPages"),
        //arrow left
        IconButton(
          tooltip: 'صفحه قبل',
          onPressed: onPreviousClick,
          icon: Icon(
            Icons.arrow_circle_left_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
