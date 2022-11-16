import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/domain/models/geographic/polygones/poly_model.dart';
import 'package:frontend/domain/models/information/section_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';


abstract class LayerModel {}
class LayerState {
  final List<LayerModel> layers;

  const LayerState(this.layers);
}

class SectionLayerModel extends LayerModel{
  SectionLayerModel({required this.event, required this.opacity});

  List<SectionModel> event;
  double? opacity;
}

class PolyModelLayerModel extends LayerModel{
  PolyModelLayerModel({required this.event, required this.fillColor, required this.outlineColor, required this.onClick, required this.opacity});

  Map<int, PolyModel> event;
  Color fillColor, outlineColor;
  Function(PolyModel, Fill) onClick;
  double? opacity;
}

class UpdateFillLayerModel extends LayerModel{
  UpdateFillLayerModel({required this.fill, required this.fillColor, required this.outlineColor, required this.opacity});

  Fill fill;
  Color fillColor, outlineColor;
  double? opacity;
}

class DotLayerModel extends LayerModel{
  DotLayerModel({required this.geometry, this.size, required this.fillColor, required this.outlineColor, required this.opacity});

  LatLng geometry;
  Color fillColor, outlineColor;
  double? opacity;
  double? size;
}

class PolyLayerModel extends LayerModel{
  PolyLayerModel({required this.geometry, required this.fillColor, required this.outlineColor, required this.opacity});

  List<LatLng> geometry;
  Color fillColor, outlineColor;
  double? opacity;
}