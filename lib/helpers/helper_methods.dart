import 'package:flutter/material.dart';

import 'constants.dart';
import 'my_colors.dart';

showMySnackbar({required String content, required BuildContext context}) {
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(content)));
}

showMyGeneralDialog({
  required BuildContext context,
  required String content,
  required String title,
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 12,
          scrollable: true,
          title: Text(title),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Text(content),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("تایید")),
          ],
        );
      });
}

BoxDecoration getBorderDecoration(BuildContext context) {
  return BoxDecoration(
    border: Border.all(color: accentColor),
    borderRadius: BorderRadius.circular(20),
  );
}

BoxDecoration getBoxDecoration() {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        accentColor.withOpacity(0.5),
        Colors.white10,
        // Colors.white10,
        // Colors.white10,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
}

Future showMyModal(BuildContext context, Widget child) {
  return showModalBottomSheet(
      backgroundColor: accentColor,
      context: context,
      builder: (context) => Wrap(
            children: [
              const ListTile(
                leading: Icon(Icons.insert_comment_outlined),
                title: Text('نتیجه:'),
              ),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: child,
              ),
            ],
          ));
}

