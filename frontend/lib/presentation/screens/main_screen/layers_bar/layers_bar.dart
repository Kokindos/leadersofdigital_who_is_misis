import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/main_screen/layers_bar/widgets/list_view_element.dart';
import 'package:frontend/presentation/theme/app_colors.dart';

class LayersBar extends StatefulWidget {
  void Function(List<bool>)? onChanged;

  LayersBar({Key? key, this.onChanged}) : super(key: key);

  @override
  State<LayersBar> createState() => _LayersBarState();
}

class _LayersBarState extends State<LayersBar> {
  final List<String> layers = [
    "Земельные участки",
    "Объект капитального строительства",
    "Организации",
    "Санитарно-защитные зоны",
    "Стартовые площадки"
  ];
  final List<Color> colors = [
    AppColors.dewberry900,
    AppColors.eggshellBlue400,
    AppColors.black,
    AppColors.lightGray,
    AppColors.gray
  ];

  List<bool> active = List.generate(5, (index) => true);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      child: Container(
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
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.veryPeri400,
                        ),
                        height: 100,
                        width: 100,
                        child: Image.asset("assets/images/scheme.png"),
                      ),
                      Text("Схема"),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 100,
                        width: 100,
                        child: Image.asset("assets/images/ortho.png"),
                      ),
                      Text("Ортофотоплан"),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 100,
                        width: 100,
                        child: Image.asset("assets/images/topography.png"),
                      ),
                      const Text("Топография"),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Divider(),
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListViewElement(
                    color: colors[index],
                      index: index,
                      layers: layers,
                      isChecked: active[index],
                      onPressed: (b) {
                        setState(() {
                          active[index] = !active[index];

                          if (widget.onChanged != null) {
                            widget.onChanged!(active);
                          }
                        });
                      });
                },
                itemCount: layers.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
