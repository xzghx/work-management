import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../helpers/constants.dart';

//not using now. default home has been set to file page.
class ContainerHome extends StatelessWidget {
  static const String route = '/container/home';
  const ContainerHome({Key? key}) : super(key: key);

  @override
  Widget
  build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        fit: BoxFit.contain,
        home,
        // height: Responsive.isDesktop(context) ? height * 0.7 : height,
      ),
    );
  }
}
