import 'package:frontend/domain/models/geographic/dots/dot_model.dart';
import 'package:frontend/domain/models/geographic/information_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class BuildingModel extends DotModel implements InformationModel {
  BuildingModel(LatLng location): super(location);

  @override
  Map<String, String> dataToMap() {
    // TODO: implement dataToMap
    throw UnimplementedError();
  }

}