import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'my_theme_state.dart';

class MyThemeCubit extends Cubit<MyThemeState> {
  MyThemeCubit() : super(const MyThemeState(isDarkMode: false));

  void toggleTheme() {
    bool currentMode =  state.isDarkMode ;
    emit(MyThemeState(isDarkMode: !currentMode));
  }
}
