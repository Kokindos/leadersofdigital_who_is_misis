import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/screens/main_screen/topbars/cubit/top_bar_next_cubit.dart';
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
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: currentState.isContinueEnabled
                  ? Text(
                "Вы выбрали точку 1: ${widget.point1.latitude.toStringAsPrecision(4)}, ${widget.point1.longitude.toStringAsPrecision(4)}",
                style: AppFonts.heading3
                    .copyWith(color: AppColors.white),
              )
                  : Text(
                "Вы выбрали точку 2: ${widget.point2.latitude.toStringAsPrecision(4)}, ${widget.point2.longitude.toStringAsPrecision(4)}",
                style: AppFonts.heading3
                    .copyWith(color: AppColors.white),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: currentState.isContinueEnabled
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppColors.white),
                              child: TextButton(
                                onPressed: () {
                                  context
                                      .read<TopBarCubit>()
                                      .paintChoseAfterSecondPoint(
                                          widget.point1, widget.point2);
                                },
                                child: const Text(
                                  "Продолжить",
                                  style: TextStyle(color: AppColors.gray),
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppColors.white),
                              child: TextButton(
                                onPressed: () {
                                  context
                                      .read<TopBarCubit>()
                                      .returnToPrevious(MainTopBarState());
                                },
                                child: const Text(
                                  "Удалить",
                                  style: TextStyle(color: AppColors.gray),
                                ),
                              )),
                        )
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: AppColors.white),
                            child: TextButton(
                              onPressed: () {
                                context.read<TopBarCubit>().paintBbox();
                              },
                              child: Text(
                                "Начать работу",
                                style: TextStyle(color: AppColors.gray),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: AppColors.white),
                            child: TextButton(
                              onPressed: () {
                                context.read<TopBarCubit>().returnToPrevious(
                                    ChooseTopBarState(
                                        p1: widget.point1,
                                        p2: widget.point2,
                                        isBeginEnabled: false,
                                        isContinueEnabled: true));
                              },
                              child: const Text(
                                "Удалить",
                                style: TextStyle(color: AppColors.gray),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
