import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../helpers/images.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  static const String route = "/login";

  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(
          Images.loginBg,
          fit: BoxFit.cover,
        ),
        /*   SvgPicture.asset(
          Images.loginSvg,
          fit: BoxFit.cover,
        ),*/
        Center(
          child: ClipRect(
            // <-- clips to the 200x200 [Container] below
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 2.0,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                width: size.width / 2 + 60,
                height: size.height / 2 + 60,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(color: Colors.white24, spreadRadius: 2)
                    ],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white24)),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: LoginForm(),
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
