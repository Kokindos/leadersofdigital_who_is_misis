import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/screens/main_screen/area_state/layers_bar/cubit/choose_layers_state.dart';


class ChooseLayersCubit extends Cubit<ChooseLayersState> {
  Set<ChooseLayerState> layers = {};

  ChooseLayersCubit(super.initialState);

  void addLayer(ChooseLayerState chooseLayerState) {
    layers.add(chooseLayerState);
    emit(ChooseLayersState(layers));
  }

  void deleteLayer(ChooseLayerState chooseLayerState) {
    layers.remove(chooseLayerState);
    emit(ChooseLayersState(layers));
  }
}