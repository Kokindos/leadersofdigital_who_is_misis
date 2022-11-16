import 'package:mapbox_gl/mapbox_gl.dart';

class SectionModel {
  final LatLng bottom_left, top_right;
  final double is_sanitary_protected_zone;
  final double is_cultural_heritage;
  final double is_unauthorized;
  final double is_mismatch;
  final double is_hazardous;
  final double is_habitable;
  final double is_oks_hazardous;
  final double is_typical;
  final double kol_mest;

  SectionModel(this.bottom_left, this.top_right, this.is_sanitary_protected_zone, this.is_cultural_heritage, this.is_unauthorized, this.is_mismatch, this.is_hazardous, this.is_habitable, this.is_oks_hazardous, this.is_typical, this.kol_mest);
}