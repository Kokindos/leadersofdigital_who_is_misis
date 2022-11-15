import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/screens/main_screen/topbars/cubit/top_bar_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/topbars/widgets/choose_point_button.dart';
import 'package:frontend/presentation/theme/app_colors.dart';
import 'package:frontend/presentation/theme/app_fonts.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'cubit/top_bar_state.dart';

class ChooseTopBar extends StatefulWidget {
  ChooseTopBar({Key? key, required p1, required p2}) : super(key: key) {
    point1 = p1;
    point2 = p2;
  }

  late LatLng point1;
  late LatLng point2;

  @override
  State<ChooseTopBar> createState() => _ChooseTopBarState();
}

class _ChooseTopBarState extends State<ChooseTopBar> {
  @override
  Widget build(BuildContext context) {
    var currentState = context.read<TopBarCubit>().state as ChooseTopBarState;
    return Container(
      height: 60,
      color: AppColors.neutral800,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                currentState.isContinueEnabled
                    ? Text(
                        "Вы выбрали точку 1: ${widget.point1.latitude.toStringAsFixed(2)}, "
                        "${widget.point1.longitude.toStringAsFixed(2)}",
                        style:
                            AppFonts.heading3.copyWith(color: AppColors.white),
                      )
                    : Text(
                        "Вы выбрали точку 2: ${widget.point2.latitude.toStringAsFixed(2)}, "
                        "${widget.point2.longitude.toStringAsFixed(2)}",
                        style:
                            AppFonts.heading3.copyWith(color: AppColors.white),
                      ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 15,
            child: currentState.isContinueEnabled
                ? Row(
                    children: [
                      ChoosePointButton(
                          onPress: () => context
                              .read<TopBarCubit>()
                              .paintChoseAfterSecondPoint(
                                  widget.point1, widget.point2),
                          title: "Продолжить"),
                      const SizedBox(
                        width: 16,
                      ),
                      ChoosePointButton(
                          onPress: () => context
                              .read<TopBarCubit>()
                              .returnToPrevious(MainTopBarState()),
                          title: "Удалить"),
                    ],
                  )
                : Row(
                    children: [
                      ChoosePointButton(
                          onPress: () =>
                              context.read<TopBarCubit>().paintBbox(),
                          title: "Начать работу"),
                      const SizedBox(
                        width: 16,
                      ),
                      ChoosePointButton(
                          onPress: () =>
                              context.read<TopBarCubit>().returnToPrevious(
                                    ChooseTopBarState(
                                        p1: widget.point1,
                                        p2: widget.point2,
                                        isBeginEnabled: false,
                                        isContinueEnabled: true),
                                  ),
                          title: "Удалить"),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
