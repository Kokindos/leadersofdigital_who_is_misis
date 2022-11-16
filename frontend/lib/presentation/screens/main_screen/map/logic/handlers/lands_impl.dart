import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/api/api.dart';
import 'package:frontend/data/storage/storage.dart';
import 'package:frontend/domain/models/geographic/polygones/poly_model.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/draw/layers_state.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/handlers/bbox_impl.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/draw/draw_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/handlers/heatmap_impl.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/zoom_bbox_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/topbars/cubit/top_bar_next_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/topbars/cubit/top_bar_state.dart';
import 'package:frontend/presentation/theme/app_colors.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'map_cubit.dart';
import 'map_interface.dart';


class LandsImpl implements MapInterface {

  PointAndLatLng? lastClick;
  PointAndLatLng? last1, last2;
  late StreamSubscription t;

  late DrawCubit drawCubit;
  @override
  void dispose(BuildContext context) {
    context.read<DrawCubit>().layers = [];
    context.read<DrawCubit>().draw();
    t.cancel();
  }

  @override
  void init(BuildContext context) {
    print('initLandLayer');

    drawCubit = context.read<DrawCubit>();
    drawCubit.layers.add(PolyModelLayerModel(event: Storage().lands, fillColor: AppColors.lightGray, onClick:  (_, fill) {
      onMapPressed(context, annotation: fill);
    }, outlineColor: AppColors.lightGray, opacity: 0.3));
    drawCubit.draw();

    t = context.read<TopBarCubit>().stream.listen((event) async {
      if (event is ChooseTopBarState) {
        if (last1 != null && last2 != null && event.isContinueEnabled == true && event.isBeginEnabled == false) {
          last2 = null;
          context.read<DrawCubit>().layers.removeLast();
          context.read<DrawCubit>().draw();
        }
      } else if (event is MainTopBarState) {
        if (last1 != null) {
          last1 = null;
          context.read<DrawCubit>().layers.removeLast();
          context.read<DrawCubit>().draw();
        }
      } else if (event is BboxTopBarState) {
        LatLng lb = LatLng(last1!.latLng.latitude < last2!.latLng.latitude? last1!.latLng.latitude : last2!.latLng.latitude, last1!.latLng.longitude < last2!.latLng.longitude? last1!.latLng.longitude : last2!.latLng.longitude);
        LatLng rt = LatLng(last1!.latLng.latitude > last2!.latLng.latitude? last1!.latLng.latitude : last2!.latLng.latitude, last1!.latLng.longitude > last2!.latLng.longitude? last1!.latLng.longitude : last2!.latLng.longitude);

        context.read<ZoomBBoxCubit>().push(ZoomBBoxState(context.read<ZoomBBoxCubit>().state.cameraPosition,lb, rt, true));
        context.read<MapCubit>().push(BBoxImpl(lb, rt));
        dispose(context);
      }
    });
  }

  @override
  void onCameraMove(BuildContext context, CameraPosition cameraPosition) {
    if (cameraPosition.zoom <= 12) {
      dispose(context);
      context.read<TopBarCubit>().paintMain();
      context.read<MapCubit>().push(HeatMapImpl());
    }
  }

  @override
  void onMapPressed(BuildContext context, {PointAndLatLng? point, Annotation? annotation, PolyModel? model}) async {
    if (point != null) {
      if (last1 == null) {
        last1 = point;
        print(last1!.latLng);
        context.read<TopBarCubit>().paintChoseAfterFirstPoint(point!.latLng);
        drawCubit.layers.add(DotLayerModel(geometry: point.latLng, fillColor: Colors.blue, outlineColor: AppColors.veryPeri900, opacity: 0.7));
        drawCubit.draw();

        return;
      } else if (last2 == null) {
        last2 = point;

        context.read<TopBarCubit>().paintChoseAfterSecondPoint(last1!.latLng, last2!.latLng);
        drawCubit.layers.add(DotLayerModel(geometry: point.latLng, fillColor: Colors.blue, outlineColor: AppColors.veryPeri900, opacity: 0.7));
        drawCubit.layers.add(PolyLayerModel(geometry: [
          LatLng(last1!.latLng.latitude, last1!.latLng.longitude),
          LatLng(last2!.latLng.latitude, last1!.latLng.longitude),
          LatLng(last2!.latLng.latitude, last2!.latLng.longitude),
          LatLng(last1!.latLng.latitude, last2!.latLng.longitude),
          LatLng(last1!.latLng.latitude, last1!.latLng.longitude),
        ], fillColor: Colors.blue, outlineColor: Colors.blue, opacity: 0.1
        ));
        drawCubit.draw();
      }

    }

    lastClick ??= point;

    if (lastClick != null && annotation != null) print(annotation);
  }

}