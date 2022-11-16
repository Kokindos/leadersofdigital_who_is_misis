import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/screens/main_screen/area_state/context_menu/cubit/context_menu_cubit.dart';
import 'package:frontend/presentation/theme/app_colors.dart';
import 'package:frontend/presentation/theme/app_fonts.dart';

class ContextMenu extends StatelessWidget {
   ContextMenu({super.key, required this.cnt});
  BuildContext cnt;


  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius:BorderRadius.circular(8) ,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(

          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: ()=>cnt.read<ContextMenuCubit>().tapAdd(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.done,
                          color: AppColors.veryPeri500,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text("Включить объект",
                            style: AppFonts.body2Medium
                                .copyWith(color: AppColors.veryPeri500)),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: ()=>cnt.read<ContextMenuCubit>().tapConsider(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.contact_support,
                          color: AppColors.veryPeri500,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text("На рассмотрение",
                            style: AppFonts.body2Medium
                                .copyWith(color: AppColors.veryPeri500)),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: ()=>cnt.read<ContextMenuCubit>().tapDelete(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.close,
                          color: AppColors.veryPeri500,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text("Исключить объект",
                            style: AppFonts.body2Medium
                                .copyWith(color: AppColors.veryPeri500)),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: ()=>cnt.read<ContextMenuCubit>().tapInfo(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.info,
                          color: AppColors.black,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          "Информация",
                          style: AppFonts.body2Regular,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
