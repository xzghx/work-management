import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class MyContainerTransition extends StatelessWidget {
  final Widget startWidget;
  final Widget   detailWidget;

  const MyContainerTransition({
    Key? key,
    required this.startWidget,
    required this.detailWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
     // closedColor: Colors.blue,
      //openColor: Colors.yellow,
     // closedElevation: 10.0,
       openElevation: 15.0,
  /*    closedShape: const RoundedRectangleBorder(
       // borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),*/
      transitionType: ContainerTransitionType.fade,
      transitionDuration: const Duration(milliseconds: 500),
      openBuilder: (context, action) {
        return detailWidget;
      },
      closedBuilder: (context, action) {
        return   startWidget;
      },
    );
  }
}
