import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/main_screen/layers_bar/widgets/list_view_element.dart';
import 'package:frontend/presentation/theme/app_colors.dart';

class LayersBar extends StatelessWidget {
  LayersBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<String> layers = [
      "Земельные участки",
      "Объект капитального строительства",
      "Организации",
      "Санитарно-защитные зоны",
      "Стартовые площадки"
    ];
    return Container(
      color: AppColors.white,
      width: 450,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.veryPeri400,
                        ),
                        height: 100,
                        width: 100,
                      ),
                      Text("Схема"),
                    ],
                  ),
                ),
                GestureDetector(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.veryPeri400,
                        ),
                        height: 100,
                        width: 100,
                      ),
                      Text("Ортофотоплан"),
                    ],
                  ),
                ),
                GestureDetector(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.veryPeri400,
                        ),
                        height: 100,
                        width: 100,
                      ),
                      const Text("Топография"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListViewElement(index: index, layers: layers);
              },
              itemCount: layers.length,
            ),
          ],
        ),
      ),
    );
  }
}
