import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/api/api.dart';
import 'package:frontend/data/storage/storage.dart';
import 'package:frontend/presentation/screens/main_screen/bloc/polygon_loader_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/map/map_modes/bbox_impl.dart';
import 'package:frontend/presentation/screens/main_screen/map/map_modes/draw_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/map/map_modes/heatmap_impl.dart';
import 'package:frontend/presentation/screens/main_screen/map/map_modes/layers_state.dart';
import 'package:frontend/presentation/screens/main_screen/map/map_modes/zoom_bbox_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/topbars/cubit/top_bar_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/topbars/cubit/top_bar_state.dart';
import 'package:frontend/presentation/theme/app_colors.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'map_cubit.dart';
import 'map_interface.dart';


class LandsImpl implements MapInterface {

  PointAndLatLng? lastClick;
  PointAndLatLng? last1, last2;

  late StreamSubscription t;

  @override
  void dispose(BuildContext context) {
    context.read<DrawCubit>().layers = [];
    context.read<DrawCubit>().draw();
    t.cancel();
  }

  @override
  void init(BuildContext context) {
    print('initLandLayer');
    context.read<DrawCubit>().layers.add(FillLayerModel(event: Storage().lands, fillColor: AppColors.dewberry400, onClick:  (_, fill) {
      onMapPressed(context, annotation: fill);
    }, outlineColor: AppColors.dewberry900, opacity: 0.3));
    context.read<DrawCubit>().draw();

    t = context.read<TopBarCubit>().stream.listen((event) {
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
        // context.read<PolygonLoaderCubit>().load(DownloadedState.inProgress);
        // dispose(context);
        // Storage().lands = await Api().getLands(lb: lb, rt: rt);
        // context.read<DrawCubit>().layers.add(FillLayerModel(event: Storage().lands, fillColor: AppColors.dewberry400, onClick:  (_, fill) {
        //   onMapPressed(context, annotation: fill);
        // }, outlineColor: AppColors.dewberry900, opacity: 0.3));
        // context.read<DrawCubit>().draw();
        // context.read<PolygonLoaderCubit>().load(DownloadedState.downloaded);

        context.read<ZoomBBoxCubit>().push(ZoomBBoxState(context.read<ZoomBBoxCubit>().state.cameraPosition,lb, rt, true));
        dispose(context);
        context.read<MapCubit>().push(BBoxImpl());
      }
    });
  }

  @override
  void onCameraMove(BuildContext context, CameraPosition cameraPosition) {
    if (cameraPosition.zoom < 13) {
      dispose(context);
      context.read<MapCubit>().push(HeatMapImpl());
    }
  }

  @override
  void onMapPressed(BuildContext context, {PointAndLatLng? point, Annotation? annotation}) async {
    if (point != null) {
      context.read<DrawCubit>().layers.add(DotLayerModel(geometry: point!.latLng, fillColor: AppColors.veryPeri900, outlineColor: AppColors.veryPeri900, opacity: 1));
      context.read<DrawCubit>().draw();

      if (last1 == null) {
        last1 = point;
        print(last1!.latLng);
        context.read<TopBarCubit>().paintChoseAfterFirstPoint(point!.latLng);
        return;
      } else if (last2 == null) {
        last2 = point;
        context.read<TopBarCubit>().paintChoseAfterSecondPoint(last1!.latLng, last2!.latLng);
      }

    }

    lastClick ??= point;

    if (lastClick != null && annotation != null) print(annotation);
  }

}