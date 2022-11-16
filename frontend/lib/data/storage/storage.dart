import 'package:frontend/domain/models/geographic/polygones/building_model.dart';
import 'package:frontend/domain/models/geographic/geographic_model.dart';
import 'package:frontend/domain/models/geographic/polygones/capital_model.dart';
import 'package:frontend/domain/models/geographic/polygones/land_model.dart';
import 'package:frontend/domain/models/geographic/dots/organization_model.dart';
import 'package:frontend/domain/models/geographic/polygones/sanitary_model.dart';
import 'package:frontend/domain/models/geographic/polygones/start_model.dart';
import 'package:frontend/domain/models/information/section_model.dart';

class Storage {

  static final Storage _instance = Storage._();

  factory Storage() => _instance;
  Storage._();

  List<SectionModel> heatmap = [];
  Map<int, LandModel> lands = {};
  Map<int, CapitalModel> capitals = {};
  Map<int, OrganizationModel> organizations = {};
  Map<int, SanitaryModel> sanitaries = {};
  Map<int, StartModel> starts = {};
  Map<int, BuildingModel> buildings = {};

  List<Map<int, GeographicModel>> get allLayers => [lands, capitals, organizations, sanitaries, starts, buildings];
}