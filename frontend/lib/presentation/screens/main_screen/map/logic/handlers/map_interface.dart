import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:frontend/domain/models/geographic/polygones/poly_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class PointAndLatLng {

  const PointAndLatLng(this.point, this.latLng);
  final Point<double> point;
  final LatLng latLng;
}

abstract class MapInterface {
  void init(BuildContext context);
  void dispose(BuildContext context);
  void onMapPressed(BuildContext context, {PointAndLatLng? point, Annotation? annotation, PolyModel? model});
  void onCameraMove(BuildContext context, CameraPosition cameraPosition);
}