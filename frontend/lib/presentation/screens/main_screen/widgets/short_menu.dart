import 'package:flutter/material.dart';
import 'package:frontend/presentation/theme/app_colors.dart';
import 'package:frontend/presentation/theme/app_fonts.dart';

class ShortMenu extends StatelessWidget {
  const ShortMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius:BorderRadius.circular(8) ,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.done,
                      color: AppColors.veryPeri500,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text("Включить объект",
                        style: AppFonts.body2Medium
                            .copyWith(color: AppColors.veryPeri500)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.contact_support,
                    color: AppColors.veryPeri500,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text("На рассмотрение",
                      style: AppFonts.body2Medium
                          .copyWith(color: AppColors.veryPeri500)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.close,
                    color: AppColors.veryPeri500,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Исключить объект",
                      style: AppFonts.body2Medium
                          .copyWith(color: AppColors.veryPeri500)),
                ],
              ),
            ),
            const Divider(
              color: AppColors.gray,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Изменить",
                    style: AppFonts.body2Regular,
                  ),
                  const Icon(
                    Icons.edit_location_alt_rounded,
                    color: AppColors.black,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Удалить",
                    style: AppFonts.body2Regular,
                  ),
                  const Icon(
                    Icons.done,
                    color: AppColors.black,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Добавить объект",
                    style: AppFonts.body2Regular,
                  ),
                  const Icon(
                    Icons.add_location_alt,
                    color: AppColors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
