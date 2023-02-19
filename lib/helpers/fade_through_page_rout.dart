import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class FadeThroughPageRoute extends PageRouteBuilder {
  FadeThroughPageRoute({
    required Widget page,
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation primaryAnimation,
            Animation secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> primaryAnimation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeThroughTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
        );
}
