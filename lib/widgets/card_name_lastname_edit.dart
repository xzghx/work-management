import 'package:flutter/material.dart';

import '../helpers/constants.dart';
import '../helpers/helper_methods.dart';
import '../helpers/my_colors.dart';
import '../responsive.dart';

class CardTwoFieldsAndEdit extends StatelessWidget {
  const CardTwoFieldsAndEdit({
    Key? key,
    required this.index,
    required this.name,
    this.lastName,
    this.code,
    this.mobile,
    required this.onEditClick,
    required this.context,
  }) : super(key: key);
  final String index;
  final String name;
  final String? lastName;
  final String? code;//codePersonely Ma
  final String? mobile;

  final void Function()? onEditClick;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          accentColor.withOpacity(0.3),
          Colors.white10,
          Colors.white10,
          Colors.white10,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(flex: 1, child: Text(index)),
                    const SizedBox(width: 2),
                    //name
                    Flexible(
                      flex: 5,
                      child: SizedBox(
                        width: 120,
                        child: Text(
                          "$name ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: Responsive.isMobile(context) ? 12 : 15),
                        ),
                      ),
                    ),
                    //lastName
                    Flexible(
                      flex: 2,
                      child: SizedBox(
                        width: lastName == null ? 0 : 120,
                        child: Text(
                          "${lastName ?? ' '} ",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    //code
                    Flexible(
                      flex: 2,
                      child: SizedBox(
                        width: code == null ? 0 : 120,
                        child: Text(
                          "${code ?? ' '} ",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    //mobile
                    Flexible(
                      flex: 2,
                      child: SizedBox(
                        width: mobile == null ? 0 : 120,
                        child: Text(
                          "${mobile ?? ' '} ",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    onEditClick != null
                        ? Expanded(
                            child: IconButton(
                                onPressed: onEditClick,
                                icon: Icon(
                                  Icons.edit_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                          )
                        : const SizedBox(),
                    // const SizedBox(width: 20),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CardTCenters extends StatelessWidget {
  const CardTCenters({
    Key? key,
    required this.index,
    required this.name,
    required this.onCenterSumClick,
    required this.onCenterDailyClick,
    required this.onIndividualsClick,
    required this.context,
  }) : super(key: key);
  final String index;
  final String name;
  final void Function()? onCenterSumClick;
  final void Function()? onCenterDailyClick;
  final void Function()? onIndividualsClick;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        decoration: getBoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //center name
              Expanded(
                child: TextButton(
                  onPressed: null,
                  child: Text(
                    name,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.caption!.color),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              // const SizedBox(height: 10),
              TextButton(
                  onPressed: onCenterSumClick,
                  child: const Text('گزارش جمع مرکز')),
/*              TextButton(
                  onPressed: onCenterDailyClick,
                  child: const Text('گزارش روزانه')),*/
              TextButton(
                  onPressed: onIndividualsClick,
                  child: const Text('گزارش فردی')),
            ],
          ),
        ),
      ),
    );
  }
}
