part of 'my_theme_cubit.dart';
class MyThemeState extends Equatable {
  final bool isDarkMode;

  const MyThemeState({required this.isDarkMode});

  @override
  List<Object?> get props => [isDarkMode];
}
