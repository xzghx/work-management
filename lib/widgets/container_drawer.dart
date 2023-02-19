import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../UI/Theme/my_theme_cubit.dart';
import '../UI/container/bloc/container_cubit.dart';
import '../helpers/my_colors.dart';
import '../helpers/my_custom_scrol_behavour.dart';

class ContainerDrawer extends StatelessWidget {
  ContainerDrawer({
    required this.onHomeClick,
    required this.onCenterClick,
    required this.onPartsClick,
    required this.onEmployeesClick,
    required this.onLogoutClick,
    required this.onEnterDataClick,
    required this.onAdminsClick,
    required this.onShiftClick,
    required this.onReportsClick,
    required this.onMonthShiftClick,
    required this.onProfileClick,
    required this.onVorodKhorojDetailClick,
    Key? key,
  }) : super(key: key);
  final void Function() onHomeClick;
  final void Function() onCenterClick;
  final void Function() onPartsClick;
  final void Function() onEmployeesClick;
  final void Function() onLogoutClick;
  final void Function() onEnterDataClick;
  final void Function() onAdminsClick;
  final void Function() onShiftClick;
  final void Function() onReportsClick;
  final void Function() onMonthShiftClick;
  final void Function() onProfileClick;
  final void Function() onVorodKhorojDetailClick;
  final ScrollController _c1 = ScrollController();
  final ScrollController _c2 = ScrollController();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<MyThemeCubit>().state.isDarkMode;
    return Drawer(
        child: ScrollConfiguration(
      behavior: MyCustomScrollBehavior(),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [accentColor.withOpacity(0.3), Colors.white10],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft)),
        child: ListView(
          controller: _c1,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Flexible(
            //   child:
            ListView(
              controller: _c2,
              shrinkWrap: true,
              children: [
                DrawerHeader(
                  decoration: _decoration(isDarkMode),
                  child: Image.asset("assets/images/logo.png"),
                ),
                DrawerListTile(
                  title: "خانه",
                  svgSrc: null,
                  //"assets/icons/menu_profile.svg",
                  icon: Icons.home,
                  press: () {
                    onHomeClick();
                  },
                  isSelected:
                      context.watch<ContainerCubit>().state.selectedTab ==
                          ContainerTab.home,
                ),
                //basic data entry
                ExpansionTile(
                  initiallyExpanded: false,
                  leading: Icon(
                    Icons.add_card_sharp,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: const Text("ورود اطلاعات پایه"),
                  children: [
                    DrawerListTile(
                      title: "تعریف شیفت",
                      svgSrc: "assets/icons/menu_profile.svg",
                      press: () {
                        onShiftClick();
                      },
                      isSelected:
                          context.watch<ContainerCubit>().state.selectedTab ==
                              ContainerTab.shift,
                    ),
                    DrawerListTile(
                      title: "تعریف مراکز",
                      svgSrc: "assets/icons/menu_profile.svg",
                      press: () {
                        onCenterClick();
                      },
                      isSelected:
                          context.watch<ContainerCubit>().state.selectedTab ==
                              ContainerTab.centers,
                    ),
                    DrawerListTile(
                      title: "تعریف بخشهای مراکز",
                      svgSrc: "assets/icons/menu_profile.svg",
                      press: () {
                        onPartsClick();
                      },
                      isSelected:
                          context.watch<ContainerCubit>().state.selectedTab ==
                              ContainerTab.parts,
                    ),
                    DrawerListTile(
                      title: "تعریف کارکنان",
                      svgSrc: "assets/icons/menu_profile.svg",
                      press: () {
                        onEmployeesClick();
                      },
                      isSelected:
                          context.watch<ContainerCubit>().state.selectedTab ==
                              ContainerTab.employees,
                    ),
                    DrawerListTile(
                      title: "تعریف مدیران",
                      svgSrc: "assets/icons/menu_profile.svg",
                      press: () {
                        onAdminsClick();
                      },
                      isSelected:
                          context.watch<ContainerCubit>().state.selectedTab ==
                              ContainerTab.admins,
                    ),
                  ],
                ),
                // Enter Exit Data
                ExpansionTile(
                  title: const Text("اطلاعات ورود و خروج"),
                  leading: Icon(
                    Icons.deblur,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  children: [
                    //دریافت داده
                    DrawerListTile(
                      title: "مشاهده و دریافت فایل",
                      svgSrc: null,
                      icon: Icons.bubble_chart,
                      press: () {
                        onEnterDataClick();
                        //Navigator.of(context).pushNamed(TestPage.route);
                      },
                      isSelected:
                          context.watch<ContainerCubit>().state.selectedTab ==
                              ContainerTab.files,
                    ),
                    //جزئیات ورود و خروج و اضافه و حذف و ویرایش
                    DrawerListTile(
                      title: "جزئیات اطلاعات ورود و خروج",
                      svgSrc: null,
                      icon: Icons.bubble_chart,
                      press: () {
                        onVorodKhorojDetailClick();
                        //Navigator.of(context).pushNamed(TestPage.route);
                      },
                      isSelected:
                          context.watch<ContainerCubit>().state.selectedTab ==
                              ContainerTab.dataDetail,
                    ),
                  ],
                ),
                // گزارشات
                DrawerListTile(
                  title: "گزارشات",
                  svgSrc: null,
                  icon: Icons.insert_chart_outlined_rounded,
                  press: () {
                    onReportsClick();
                    //Navigator.of(context).pushNamed(TestPage.route);
                  },
                  isSelected:
                      context.watch<ContainerCubit>().state.selectedTab ==
                          ContainerTab.reports,
                ),
                // شیفت ها
                DrawerListTile(
                  title: "ثبت شیفت ماه",
                  svgSrc: null,
                  icon: Icons.calendar_month,
                  press: () {
                    onMonthShiftClick();
                    //Navigator.of(context).pushNamed(TestPage.route);
                  },
                  isSelected:
                      context.watch<ContainerCubit>().state.selectedTab ==
                          ContainerTab.monthShifts,
                ),
              ],
            ),
            // ),
            //  profile
            DrawerListTile(
              title: "پروفایل",
              svgSrc: null,
              icon: Icons.person,
              press: () {
                onProfileClick();
              },
              isSelected: context.watch<ContainerCubit>().state.selectedTab ==
                  ContainerTab.changePassword,
            ),
            //log out
            DrawerListTile(
              title: "خروج",
              svgSrc: null,
              icon: Icons.directions_run_sharp,
              press: () {
                onLogoutClick();
              },
              isSelected: context.watch<ContainerCubit>().state.selectedTab ==
                  ContainerTab.logout,
            ),
          ],
        ),
      ),
    ));
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile(
      {Key? key,
      // For selecting those three line once press "Command+D"
      required this.title,
      required this.svgSrc,
      this.icon,
      required this.press,
      required this.isSelected // = false,
      })
      : super(key: key);

  final String title;
  final String? svgSrc;
  final IconData? icon;
  final VoidCallback press;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(height: 500,color: Colors.greenAccent,),
        ListTile(
          selected: isSelected,
          hoverColor: Colors.white30,
          selectedTileColor: accentColor.withOpacity(0.5),
          onTap: press,
          horizontalTitleGap: 0.0,
          leading: svgSrc != null
              ? SvgPicture.asset(
                  svgSrc!,
                  color: accentColor,
                  // color: Colors.white54,
                  height: 16,
                )
              : Icon(
                  icon ?? Icons.star,
                  color: Theme.of(context).colorScheme.secondary,
                ),
          title: Text(
            title,
            // style: const TextStyle(color: Colors.white54),
          ),
        ),
        const SizedBox(width: 200, child: Divider(height: 0))
      ],
    );
  }
}

_decoration(bool isDarkMode) {
  return BoxDecoration(
      gradient: LinearGradient(colors: [
    accentColor,
    isDarkMode ? convasColorDark : convasColorLight,
  ]));
}
