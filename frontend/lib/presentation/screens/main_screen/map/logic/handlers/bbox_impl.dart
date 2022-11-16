import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/api/api.dart';
import 'package:frontend/data/storage/storage.dart';
import 'package:frontend/domain/configurator/configurator.dart';
import 'package:frontend/domain/models/geographic/polygones/land_model.dart';
import 'package:frontend/domain/models/geographic/polygones/poly_model.dart';
import 'package:frontend/presentation/screens/main_screen/area_state/context_menu/cubit/context_menu_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/area_state/context_menu/cubit/context_menu_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/area_state/layers_bar/cubit/choose_layers_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/area_state/layers_bar/cubit/choose_layers_state.dart';
import 'package:frontend/presentation/screens/main_screen/area_state/sidebar/cubit/sidebar_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/loader/cubit/loader_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/context_menu/show_context_menu_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/context_menu/show_context_menu_state.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/draw/layers_state.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/handlers/map_interface.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/zoom_bbox_cubit.dart';
import 'package:frontend/presentation/theme/app_colors.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart';

import '../draw/draw_cubit.dart';

class FillPolyContainer {
  final Annotation fill;
  final PolyModel polyModel;

  FillPolyContainer(this.fill, this.polyModel);
}

class BBoxImpl extends MapInterface {
  LatLng p1, p2;

  BBoxImpl(this.p1, this.p2);

  @override
  void dispose(BuildContext context) {
    // TODO: implement dispose
  }

  @override
  void init(BuildContext context) async {
    print('initBBoxLayer');
    DrawCubit drawCubit = context.read<DrawCubit>();


    Storage().lands = {};
    Storage().lands = await Api().getLands(lb: context.read<ZoomBBoxCubit>().state.lb, rt: context.read<ZoomBBoxCubit>().state.rt);

    drawCubit.layers = [];
    drawCubit.draw();

    context.read<ChooseLayersCubit>().stream.listen((event) async {
      print(event.state);
      drawCubit.layers = [];

      context.read<LoaderCubit>().load(LoaderState.inProgress);
      if (event.state.contains(ChooseLayerState.lands)) {

        Color color = Colors.grey;

        for (var h in Storage().lands.entries) {

          int t = Random().nextInt(100);

          if (t >= 60) {
            color = Colors.green;
          } else if (t >= 20) {
            color = Colors.yellow;
          } else if (t >= 0) {
            color = Colors.red;
          }

          drawCubit.layers.add(PolyLayerModel(geometry: h.value.geometry[0], fillColor: color, outlineColor: color, opacity: 0.3));
        }

        drawCubit.layers.add(PolyModelLayerModel(
            event: Storage().lands,
            fillColor: AppColors.dewberry400,
            onClick: (p, fill) {
              onMapPressed(context, annotation: fill, model: p);
            },
            outlineColor: AppColors.dewberry900,
            opacity: 0.1));
      }
      if (event.state.contains(ChooseLayerState.capitals)) {
        drawCubit.layers.add(PolyModelLayerModel(
            event: Storage().capitals,
            fillColor: AppColors.eggshellBlue400,
            onClick: (p, fill) {
              onMapPressed(context, annotation: fill, model: p);
            },
            outlineColor: AppColors.dewberry900,
            opacity: 0.3));
      }
      if (event.state.contains(ChooseLayerState.organizations)) {
        drawCubit.layers.add(PolyModelLayerModel(
            event: Storage().sanitaries,
            fillColor: AppColors.lightGray,
            onClick: (p, fill) {
              onMapPressed(context, annotation: fill, model: p);
            },
            outlineColor: AppColors.dewberry900,
            opacity: 0.3));
      }
      if (event.state.contains(ChooseLayerState.sanitaries)) {
        drawCubit.layers.add(PolyModelLayerModel(
            event: Storage().starts,
            fillColor: AppColors.gray,
            onClick: (p, fill) {
              onMapPressed(context, annotation: fill, model: p);
            },
            outlineColor: AppColors.dewberry900,
            opacity: 0.3));
      }

      context.read<LoaderCubit>().load(LoaderState.downloaded);

      drawCubit.draw();
    });


    context.read<ContextMenuCubit>().stream.listen((event) {
      if (lastContainer != null) {
        context.read<ShowContextMenuCubit>().push(ClosedShowContextMenuState());
        if (event == ContextMenuState.info) {
          print(lastContainer!.polyModel.geometry);
          context.read<SidebarCubit>().setCurrentArea(lastContainer!.polyModel);
        } else if (event == ContextMenuState.added) {
          drawCubit.layers = [];
          drawCubit.layers.add(UpdateFillLayerModel(fill: lastContainer!.fill as Fill, fillColor: Colors.blue, outlineColor: Colors.blue, opacity: 0.6));
          drawCubit.draw();
        } else if (event == ContextMenuState.considered) {
          drawCubit.layers = [];
          drawCubit.layers.add(UpdateFillLayerModel(fill: lastContainer!.fill as Fill, fillColor: Colors.yellow, outlineColor: Colors.yellow, opacity: 0.6));
          drawCubit.draw();
        } else if (event == ContextMenuState.deleted) {
          drawCubit.layers = [];
          drawCubit.layers.add(UpdateFillLayerModel(fill: lastContainer!.fill as Fill, fillColor: AppColors.dewberry400, outlineColor: AppColors.dewberry400, opacity: 0.1));
          drawCubit.draw();
        }
        context.read<ContextMenuCubit>().tapNone();
      }
    });
  }

  @override
  void onCameraMove(BuildContext context, CameraPosition cameraPosition) {
    // TODO: implement onCameraMove
  }

  Point<double>? lastClick;
  FillPolyContainer? lastContainer;

  @override
  void onMapPressed(BuildContext context,
      {PointAndLatLng? point, Annotation? annotation, PolyModel? model}) {

    if (point != null) {
      lastClick = point!.point;
    }

    print(model);
    if (annotation != null && model is LandModel) {
      lastContainer = FillPolyContainer(annotation, model);
      context.read<ShowContextMenuCubit>().push(OpenShowContextMenuState(lastClick!.x, lastClick!.y));
    }
  }
}
