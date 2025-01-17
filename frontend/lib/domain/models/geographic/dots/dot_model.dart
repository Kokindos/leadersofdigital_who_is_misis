import 'package:frontend/domain/models/geographic/geographic_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

abstract class DotModel extends GeographicModel {
  DotModel(this.location);

  late LatLng location;
  DotModel.fromJson(json) {
     location=(LatLng(json["lat"]!, json["lon"]!));
    }
  }