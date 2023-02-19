import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../UI/Theme/my_theme_cubit.dart';

///a button to change the them to light or dark
class DayNightButton extends StatelessWidget {
  const DayNightButton({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<MyThemeCubit, MyThemeState>(
      buildWhen: (cur, pre) => cur.isDarkMode != pre.isDarkMode,
      builder: (context, state) => IconButton(
        onPressed: () => context.read<MyThemeCubit>().toggleTheme(),
        icon: state.isDarkMode
            ? const Icon(
          Icons.nightlight_round_rounded,
          color: Colors.cyanAccent,
        )
            : const Icon(
          Icons.wb_sunny_rounded,
          color: Colors.yellow,
        ),
      ),
    );
  }
}
