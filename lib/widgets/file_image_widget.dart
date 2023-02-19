import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/images.dart';
import '../responsive.dart';

class FileImageWidget extends StatelessWidget {
  final double height;
  const FileImageWidget({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return     SvgPicture.asset(
      fit: BoxFit.fitWidth,
      Images.filesSvg,
      height: Responsive.isDesktop(context) ? height * 0.7 : height,
    ) ;
  }
}
