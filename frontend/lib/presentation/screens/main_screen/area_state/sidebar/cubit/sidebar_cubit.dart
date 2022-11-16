import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/geographic/polygones/poly_model.dart';

class SidebarCubit extends Cubit<PolyModel?> {
  SidebarCubit(super.initialState);

  void setCurrentArea(PolyModel? areaModel) {
    emit(areaModel);
  }



}