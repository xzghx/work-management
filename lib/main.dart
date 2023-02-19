import 'package:flutter/material.dart';

// import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'UI/Ui_exports.dart';
import 'UI/container/pages/vorod_khoroj_Search/bloc/vorod_khoroj_cubit.dart';
import 'UI/container/pages/vorod_khoroj_Search/view/vorod_khoroj_detail.dart';
import 'UI/container/print_cubit.dart';
import 'helpers/app_theme.dart';
import 'helpers/constants.dart';
import 'helpers/my_custom_scrol_behavour.dart';
import 'helpers/shared_axis_page_rout.dart';
import 'repositories/error_logger_repository.dart';
import 'responsive.dart';

void main() async {
  // timeDilation = 2; //slow down animations three times
  Bloc.observer = MyBlocObserver();
  // To load the .env file contents into dotenv.
  // NOTE: fileName defaults to .env and can be omitted in this case.
  // Ensure that the filename corresponds to the path in step 1 and 2.
  //await dotenv.load(fileName: "fonts/.env");
  //...runApp
  runApp(const MyApp());
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    debugPrint('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onClose(BlocBase bloc) {
    debugPrint('onClose -- ${bloc.runtimeType}');
    super.onClose(bloc);
  }
/*
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // print('onChange -- ${bloc.runtimeType}, $change');
  }*/
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ErrorLoggerRepository(),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(
              errorLogger:
                  RepositoryProvider.of<ErrorLoggerRepository>(context)),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => AuthBloc(
                  userRepo: RepositoryProvider.of<UserRepository>(context))),
          BlocProvider(
            create: (context) => LoginBloc(
                userRepo: RepositoryProvider.of<UserRepository>(context),
                authBloc: BlocProvider.of<AuthBloc>(context)),
          ),
          BlocProvider(
            create: (context) => MyThemeCubit(),
          ),
        ],
        child:
            BlocBuilder<MyThemeCubit, MyThemeState>(builder: (context, state) {
          return MaterialApp(
            scrollBehavior: MyCustomScrollBehavior(),
            home: const LoginPage(),
            // home: const HomePage(),
            // home: const TestPage(),
            title: 'Shifter',
            /*       routes: {
              LoginPage.route:(context)=>  const LoginPage(),
              HomePage.route:(context)=>  const HomePage(),
            },*/
            theme: state.isDarkMode
                ? AppTheme.darkTheme(context)
                : AppTheme.lightTheme(context),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: _router.onGenerateRoute,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('fa', ''), // Spanish, no country code
              // Locale('en', ''), // English, no country code
            ],
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }
}

class AppRouter {
  // final _counterBloc = CounterBloc();

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginPage.route:
        return SharedAxisPageRoute(page: const LoginPage());
      // return MaterialPageRoute(builder: (_) => const LoginPage());

      case ContainerPage.route:
        return SharedAxisPageRoute(page: const ContainerPage());
      case AddOrEditAdminPage.route:
        AdminCubit c = settings.arguments as AdminCubit;
        return SharedAxisPageRoute(
            page: BlocProvider.value(
                value: c, child: const AddOrEditAdminPage()));
      case AddOrEditCentersPage.route:
        CentersCubit c = settings.arguments as CentersCubit;
        return SharedAxisPageRoute(
            page: BlocProvider.value(
                value: c, child: const AddOrEditCentersPage()));
      case AddOrEditPartPage.route:
        PartCubit c = settings.arguments as PartCubit;
        return SharedAxisPageRoute(
            page:
                BlocProvider.value(value: c, child: const AddOrEditPartPage()));
      case AddOrEditEmployeePage.route:
        EmployeeCubit c = settings.arguments as EmployeeCubit;
        return SharedAxisPageRoute(
            page: BlocProvider.value(
                value: c, child: const AddOrEditEmployeePage()));
      case AddOrEditShiftPage.route:
        ShiftCubit c = settings.arguments as ShiftCubit;
        return SharedAxisPageRoute(
            page: BlocProvider.value(
                value: c, child: const AddOrEditShiftPage()));

      case CenterDailyPage.route:
        ReportCubit c = settings.arguments as ReportCubit;
        return SharedAxisPageRoute(
            page: BlocProvider.value(value: c, child: const CenterDailyPage()));

      case CenterSumPage.route:
        ReportCubit c = settings.arguments as ReportCubit;
        return SharedAxisPageRoute(
            page: BlocProvider.value(value: c, child: const CenterSumPage()));
      case CenterEmployees.route:
        List args = settings.arguments as List;
        ReportCubit c = args.first as ReportCubit;
        PrintCubit p = args.last as PrintCubit;
        return SharedAxisPageRoute(
            page: BlocProvider.value(
                value: c,
                child: BlocProvider.value(
                    value: p, child: const CenterEmployees())));
      case CenterEmployeeReport.route:
        List args = settings.arguments as List;
        ReportCubit r = args.first as ReportCubit;
        PrintCubit c = args.last as PrintCubit;
        return SharedAxisPageRoute(
            page: BlocProvider.value(
                value: r,
                child: BlocProvider.value(
                    value: c, child: const CenterEmployeeReport())));
      case VorodKhorojDetail.route:
        VorodKhorojCubit c = settings.arguments as VorodKhorojCubit;
        return SharedAxisPageRoute(
            page:
                BlocProvider.value(value: c, child: const VorodKhorojDetail()));
      default:
        return SharedAxisPageRoute(
          page: BlocProvider.value(
            value: MyThemeCubit(),
            child: const NotFound(),
          ),
        );
      /*  return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: MyThemeCubit(),
            child: const LoginPage(),
          ),
        );*/
    }
  }

  void dispose() {
    // _counterBloc.close();
  }
}

class NotFound extends StatelessWidget {
  const NotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              // width:500,
              // height: 500,
              child: SvgPicture.asset(
                fit: BoxFit.contain,
                notFound,
                height: Responsive.isDesktop(context) ? height * 0.7 : height,
              ),
            ),
          ),
          const Text(
            'صفحه مورد نظر پیدا نشد.',
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }
}
