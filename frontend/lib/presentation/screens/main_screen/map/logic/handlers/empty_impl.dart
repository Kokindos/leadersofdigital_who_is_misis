import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/api/api.dart';
import 'package:frontend/data/storage/storage.dart';
import 'package:frontend/domain/models/geographic/polygones/poly_model.dart';
import 'package:frontend/presentation/screens/main_screen/loader/cubit/loader_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/handlers/heatmap_impl.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/handlers/map_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/handlers/map_interface.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';

class EmptyImpl extends MapInterface {
  @override
  void dispose(BuildContext context) {
    // TODO: implement dispose
  }

  @override
  void init(BuildContext context) async {
    context.read<LoaderCubit>().load(LoaderState.inProgress);
    if (Storage().lands.isEmpty) Storage().lands = await Api().getLands();
    if (Storage().heatmap.isEmpty) Storage().heatmap = await Api().getHeatmap();
    if (Storage().sanitaries.isEmpty) Storage().sanitaries = await Api().getSanitary();
    if (Storage().organizations.isEmpty) Storage().organizations = await Api().getOrganizations();
    if (Storage().capitals.isEmpty) Storage().capitals = await Api().getCapital();
    if (Storage().starts.isEmpty) Storage().starts = await Api().getStartGrounds();

    Timer(Duration(seconds: 5), () async {
      dispose(context);
      context.read<LoaderCubit>().load(LoaderState.downloaded);
      context.read<MapCubit>().push(HeatMapImpl());
    });
  }

  @override
  void onCameraMove(BuildContext context, CameraPosition cameraPosition) {
    // TODO: implement onCameraMove
  }

  @override
  void onMapPressed(BuildContext context, {PointAndLatLng? point, Annotation? annotation, PolyModel? model}) {
    // TODO: implement onMapPressed
  }

}