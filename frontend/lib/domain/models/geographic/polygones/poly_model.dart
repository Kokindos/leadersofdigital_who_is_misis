import 'package:frontend/domain/models/geographic/geographic_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

abstract class PolyModel extends GeographicModel {
  PolyModel(this.geometry);

  List<List<LatLng>> geometry = [];

  PolyModel.fromJson(List json) {
    for (int i = 0; i < json.length; i++) {
      List<LatLng> polygons = [];
      for (int j = 0; j < json[i].length; j++) {
        polygons.add(LatLng(json[i][j]["lat"]!, json[i][j]["lon"]!));
      }
      geometry.add(polygons);
    }
  }
}
