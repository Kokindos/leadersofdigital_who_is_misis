import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/screens/main_screen/area_state/layers_bar/cubit/choose_layers_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/area_state/layers_bar/cubit/choose_layers_state.dart';
import 'package:frontend/presentation/screens/main_screen/area_state/layers_bar/widgets/list_view_element.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/draw/layers_state.dart';
import 'package:frontend/presentation/theme/app_colors.dart';

class LayersBar extends StatefulWidget {
  @override
  State<LayersBar> createState() => _LayersBarState();
}

class _LayersBarState extends State<LayersBar> {
  final Map<String, ChooseLayerState> layers = {
    "Земельные участки": ChooseLayerState.lands,
    "Объект капитального строительства" : ChooseLayerState.capitals,
    "Организации": ChooseLayerState.organizations,
    "Санитарно-защитные зоны": ChooseLayerState.sanitaries,
    "Стартовые площадки": ChooseLayerState.starts
  };

  final List<Color> colors = [
    AppColors.dewberry900,
    AppColors.eggshellBlue400,
    AppColors.black,
    AppColors.lightGray,
    AppColors.gray
  ];

  List<bool> active = List.generate(5, (index) => index == 0? true:false);

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
                      layers: layers.keys.toList(),
                      isChecked: active[index],
                      onPressed: (b) {
                        setState(() {
                          active[index] = !active[index];

                          if (active[index] == true) {
                            context.read<ChooseLayersCubit>().addLayer(layers[layers.keys.toList()[index]]!);
                          } else {
                            context.read<ChooseLayersCubit>().deleteLayer(layers[layers.keys.toList()[index]]!);
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
