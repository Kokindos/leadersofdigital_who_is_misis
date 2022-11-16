import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/api/api.dart';
import 'package:frontend/data/storage/storage.dart';
import 'package:frontend/domain/models/geographic/polygones/poly_model.dart';
import 'package:frontend/domain/models/information/section_model.dart';
import 'package:frontend/presentation/screens/main_screen/loader/cubit/loader_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/draw/draw_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/draw/layers_state.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/handlers/lands_impl.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/handlers/map_cubit.dart';
import 'package:frontend/presentation/theme/app_colors.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'map_interface.dart';

class HeatMapImpl implements MapInterface {

  late DrawCubit drawCubit;


  @override
  void dispose(BuildContext context) {
    // TODO: implement dispose
  }

  @override
  void init(BuildContext context) async {
    drawCubit = context.read<DrawCubit>();
    drawCubit.layers.add(SectionLayerModel(event: Storage().heatmap, opacity: 0.1));
    drawCubit.draw();
  }

  @override
  void onCameraMove(BuildContext context, CameraPosition cameraPosition) {
    print(cameraPosition.zoom);
    if (cameraPosition.zoom > 12) {
      dispose(context);
      context.read<MapCubit>().push(LandsImpl());
    }
  }

  @override
  void onMapPressed(BuildContext context, {PointAndLatLng? point, Annotation? annotation, PolyModel? model}) {

  }

}