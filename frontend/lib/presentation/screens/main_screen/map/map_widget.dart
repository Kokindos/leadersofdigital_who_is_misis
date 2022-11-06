import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/storage/storage.dart';
import 'package:frontend/domain/models/area_model.dart';
import 'package:frontend/domain/models/capital_model.dart';
import 'package:frontend/domain/models/dot_model.dart';
import 'package:frontend/domain/models/land_model.dart';
import 'package:frontend/domain/models/sanitary_model.dart';
import 'package:frontend/domain/models/start_model.dart';
import 'package:frontend/presentation/screens/main_screen/bloc/layers_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/bloc/polygon_loader_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/bloc/sidebar_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/map/controller_extensions/on_click_handler.dart';
import 'package:frontend/presentation/screens/main_screen/map/plus_minus.dart';
import 'package:frontend/presentation/screens/main_screen/widgets/context_menu.dart';
import 'package:frontend/presentation/theme/app_colors.dart';
import 'package:frontend/presentation/widgets/small_button.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

extension Hasher on FillOptions {}

class FillOptionContainer {
  final FillOptions fillOptions;

  const FillOptionContainer(this.fillOptions);

  @override
  bool operator ==(Object o) {
    if (o is FillOptions &&
        o.fillColor == fillOptions.fillColor &&
        fillOptions.geometry == o.geometry) {
      return true;
    }

    if (o is FillOptionContainer &&
        o.fillOptions.fillColor == fillOptions.fillColor &&
        fillOptions.geometry == o.fillOptions.geometry) {
      return true;
    }

    return false;
  }

  @override
  // TODO: implement hashCode
  int get hashCode =>
      fillOptions.fillColor.hashCode + fillOptions.geometry.hashCode;
}

class MapWidget extends StatefulWidget {
  MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  MapboxMapController? controller;

  bool onDrawed = false;

  OverlayEntry? shortMenu;
  bool isShortMenuActive = false;

  Point<double>? point;

  @override
  void initState() {
    super.initState();
    context.read<PolygonLoaderCubit>().stream.listen((event) {
      if (controller != null) {
        if (event == DownloadedState.downloaded) {
          putLayerOnMap<LandModel>(Storage().lands, AppColors.dewberry400,
              AppColors.dewberry900, 0.3);
          putLayerOnMap<CapitalModel>(Storage().capitals,
              AppColors.eggshellBlue400, AppColors.eggshellBlue900, 1);
          putLayerOnMap<SanitaryModel>(
              Storage().sanitaries, AppColors.lightGray, AppColors.gray, 0.3);
          putLayerOnMap<StartModel>(
              Storage().starts, AppColors.lightGray, AppColors.gray, 0.3);
          putCirleLayerOnMap(Storage().organizations);

        }
      }
    });

    context.read<LayersCubit>().stream.listen((event) {
      if (controller != null) {
        if (context.read<PolygonLoaderCubit>().downloaded ==
            DownloadedState.downloaded) {
          controller!.clearFills();
          controller!.onFillTapped.clear();

          if (event[0])
            putLayerOnMap<LandModel>(Storage().lands, AppColors.dewberry400,
                AppColors.dewberry900, 0.3);
          if (event[2]) {
            putCirleLayerOnMap(Storage().organizations);
          }
          if (event[3])
            putLayerOnMap<CapitalModel>(Storage().capitals,
                AppColors.eggshellBlue400, AppColors.eggshellBlue900, 1);
          if (event[4])
            putLayerOnMap<SanitaryModel>(
                Storage().sanitaries, AppColors.lightGray, AppColors.gray, 0.3);
          if (event[1])
            putLayerOnMap<StartModel>(
                Storage().starts, AppColors.lightGray, AppColors.gray, 0.3);
        }
      }
    });

    context.read<SidebarCubit>().stream.listen((event) {
      if (controller! != null) {
        if (event == null) {
          OnClickHandler.close();
        }
      }
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  void onCameraZoomPlus() {
    controller!.animateCamera(
        CameraUpdate.zoomTo(controller!.cameraPosition!.zoom + 1));
  }

  void onCameraZoomMinus() {
    controller!.animateCamera(
        CameraUpdate.zoomTo(controller!.cameraPosition!.zoom - 1));
  }

  void putLayerOnMap<T>(
      Map<int, AreaModel> event, Color fillColor, Color outlineColor,
      [double? opacity]) async {
    Map<FillOptionContainer, AreaModel> mapPolygons = {};

    for (var e in event.entries) {
      mapPolygons[FillOptionContainer(FillOptions(
          geometry: [e.value.geometry[0]],
          fillColor: fillColor.toHexTriplet(),
          fillOutlineColor: outlineColor.toHexTriplet(),
          fillOpacity: opacity ?? fillColor.opacity))] = e.value;
    }

    List l =
        await drawFills(mapPolygons.keys.toList(), fillColor, outlineColor);

    controller!.onFillTapped.add((argument) async {
      FillOptionContainer c = FillOptionContainer(argument.options);
      if (mapPolygons.containsKey(c)) {
        await Timer(Duration(milliseconds: 100), () {});
        onFillClick<T>(mapPolygons[c]!, argument, point!);
      }
    });
  }

  void onFillClick<T>(AreaModel model, Fill fill, Point<num> p) {
    String? color = fill.options.fillColor;
    OnClickHandler.choose(fill, onChoose: (f) {
      if (OnClickHandler.isChosen) {
        OnClickHandler.close();
      }

      controller!.updateFill(
          fill,
          fill.options.copyWith(
              FillOptions(fillColor: AppColors.veryPeri400.toHexTriplet())));
      _showShortMenu(Point<double>(p.x.toDouble(), p.y.toDouble()));
      context.read<SidebarCubit>().setCurrentArea(model);
    }, onClose: (f) {
      controller!
          .updateFill(f, fill.options.copyWith(FillOptions(fillColor: color)));
      _hideShortMenu();
    });
  }

  void putCirleLayerOnMap(Map<int, DotModel> event) async {
    List<CircleOptions> f = [];
    for (var element in event.values) {
      f.add(CircleOptions(
          circleRadius: 2,
          circleColor: AppColors.black.toHexTriplet(),
          geometry: element.location));
    }
    controller!.addCircles(f);

  }

  Future<List<Fill>> drawFills(List<FillOptionContainer> fillOptions,
      Color fillColor, Color outlineColor,
      [double? opacity]) async {
    final List<FillOptions> f = List.generate(
        fillOptions.length, (index) => fillOptions[index].fillOptions);
    return await controller!.addFills(f);
  }

  void _showShortMenu(Point<double> click) {
    isShortMenuActive = true;
    setState(() {});
    OverlayState? overlayState = Overlay.of(context);
    shortMenu = OverlayEntry(
        builder: (_) => Positioned(
            top: click.y,
            left: click.x,
            child: PointerInterceptor(
              child: ContextMenu(cnt: context),
            )));

    overlayState?.insert(shortMenu!);
  }

  void _hideShortMenu() {
    if (isShortMenuActive) {
      isShortMenuActive = false;
      setState(() {});
      shortMenu?.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapboxMap(
          cameraTargetBounds: CameraTargetBounds(LatLngBounds(
            northeast: const LatLng(56.28408249081925, 38.17401410295989),
            southwest: const LatLng(55.37949118840644, 36.75537470776375),
          )),
          compassEnabled: false,
          zoomGesturesEnabled: isShortMenuActive ? false : true,
          scrollGesturesEnabled: isShortMenuActive ? false : true,
          accessToken:
              'pk.eyJ1IjoicGl0dXNhbm9uaW1vdXMiLCJhIjoiY2twcHk5M2VtMDZvZjJ2bzEzMHNhNDM1diJ9.8BLcJknh8FvUVLJRZbHJDQ',
          styleString:
              'mapbox://styles/pitusanonimous/ckpq0eydh0tk318mr0dcw773k',
          initialCameraPosition: const CameraPosition(
            zoom: 12.0,
            target: LatLng(55.75110596550744, 37.609532416801954),
          ),
          onMapCreated: (MapboxMapController c) {
            controller = c;

            controller!.onFeatureTapped.add((id, p, coordinates) {
              point = p;
            });
          },
          onMapClick: (p, l) {
            _hideShortMenu();
            context.read<SidebarCubit>().setCurrentArea(null);
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PointerInterceptor(
                  child: PlusMinusWidget(
                      onPlus: onCameraZoomPlus, onMinus: onCameraZoomMinus),
                ),
                const SizedBox(
                  height: 24,
                ),
                PointerInterceptor(
                    child: SmallButton(
                        icon: "assets/icons/straighten.svg",
                        color: AppColors.neutral800,
                        onPressed: () {})),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}