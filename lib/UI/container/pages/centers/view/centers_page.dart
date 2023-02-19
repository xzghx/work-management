import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../helpers/constants.dart';
import '../../../../../helpers/images.dart';
import '../../../../../helpers/my_custom_scrol_behavour.dart';
import '../../../../../repositories/centers_repository.dart';
import '../../../../../repositories/error_logger_repository.dart';
import '../../../../../responsive.dart';
import '../../../../../widgets/card_name_lastname_edit.dart';
import '../../../../authentication/bloc/authentication_bloc.dart';
import '../bloc/center_cubit.dart';
import 'add_or_edit_center.dart';

class CentersPage extends StatelessWidget {
  // static const String route = "/dataEntry/CentersPage";

  const CentersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CentersCubit(
          auth: BlocProvider.of<AuthBloc>(context),
          centersRepo: CentersRepository(
              errorLogger:
                  RepositoryProvider.of<ErrorLoggerRepository>(context)))
        ..getCenters(),
      child: CentersPageView(),
    );
  }
}

class CentersPageView extends StatelessWidget {
  CentersPageView({Key? key}) : super(key: key);
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SvgPicture.asset(
            Images.centersSvg,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: BlocConsumer<CentersCubit, CentersState>(
              listenWhen: (prevState, currentState) =>
                  prevState.isLoading != currentState.isLoading,
              listener: (context, state) {
                if (state.message.isNotEmpty) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return state.isLoading
                    ? const CircularProgressIndicator()
                    : RefreshIndicator(
                        onRefresh: () async {
                          context.read<CentersCubit>().getCenters();
                        },
                        //to make list scrollable with mouse
                        child: ScrollConfiguration(
                          behavior: MyCustomScrollBehavior(),
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          Responsive.isDesktop(context)
                                              ? 6
                                              : 3),
                              controller: controller,
                              physics: const AlwaysScrollableScrollPhysics(),
                              //add on more index for header
                              // itemCount: state.centers.length + 1,
                              itemCount: state.centers.length,
                              itemBuilder: (context, index) {
                                /*    if (index == 0) {
                                return Column(
                                  children: [
                                    CardTwoFieldsAndEdit(
                                      index: "ردیف",
                                      name: "نام",
                                      context: context,
                                      onEditClick: null,
                                    ),
                                  ],
                                );
                              } else {
                                index = index - 1;*/
                                return CardTwoFieldsAndEdit(
                                  index: index.toString(),
                                  name: state.centers[index].name,
                                  onEditClick: () {
                                    // Navigator.of(context).push(
                                    //   //**DO NOT pass context to builder.It is not containing EditFooterCubit in context.
                                    //     MaterialPageRoute(builder: (_) => BlocProvider.value(
                                    //         value:BlocProvider.of<EditFooterCubit>(context) ,
                                    //         child: EditFooterDetailPage())
                                    //     ));
                                    context
                                        .read<CentersCubit>()
                                        .setAddMode(false);
                                    Navigator.of(context).pushNamed(
                                        AddOrEditCentersPage.route,
                                        arguments:
                                            BlocProvider.of<CentersCubit>(
                                                context));
                                    context
                                        .read<CentersCubit>()
                                        .getCenter(state.centers[index].id);
                                  },
                                  context: context,
                                );
                              }),
                        ),
                      );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          context.read<CentersCubit>().clearSelectedCenter();
          context.read<CentersCubit>().setAddMode(true);
          Navigator.of(context).pushNamed(AddOrEditCentersPage.route,
              arguments: BlocProvider.of<CentersCubit>(context));
        },
        tooltip: "افزودن مرکز جدید",
        child: const Icon(Icons.add),
      ),
    );
  }
}
