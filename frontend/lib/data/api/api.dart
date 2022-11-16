import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:frontend/data/api/api_routes/api_routes.dart';
import 'package:frontend/data/interceptors/error_interceptor.dart';
import 'package:frontend/domain/models/geographic/polygones/capital_model.dart';
import 'package:frontend/domain/models/geographic/polygones/cultural_heritage_model.dart';
import 'package:frontend/domain/models/geographic/polygones/land_model.dart';
import 'package:frontend/domain/models/geographic/dots/organization_model.dart';
import 'package:frontend/domain/models/geographic/polygones/sanitary_model.dart';
import 'package:frontend/domain/models/geographic/polygones/start_model.dart';
import 'package:frontend/domain/models/information/section_model.dart';
import 'package:mapbox_gl/mapbox_gl.dart';


class Api {
  late Dio _client;

  static final Api _instance = Api._newInstance();

  factory Api() => _instance;

  Api._newInstance() {
    final dio = Dio(BaseOptions(
      baseUrl: 'http://89.108.102.188/api',
      connectTimeout: 1000000,
    ));
    dio.interceptors.add(ErrorInterceptor());
    _client = dio;
  }

  Future<Map<int, LandModel>> getLands({LatLng? lb, LatLng? rt}) async {
    List<LandModel> res = [];

    var response;
    if (lb != null && rt != null) {
      response = await _client.get(ApiRoutes.lands, queryParameters: {'lat1': lb.latitude, 'lon1': lb.longitude, 'lat2': rt.latitude, 'lon2': rt.longitude});
    } else {
      response = await _client.get(ApiRoutes.getLands);
    }

    Map<int, LandModel> m = {};

    for (var j in response.data['lands']) {
      m[j['oid']] = LandModel.fromJson(j);
    }

    return m;
  }

  Future<Map<int, CapitalModel>> getCapital() async {
    final response = await _client.get(ApiRoutes.getCapital);

    Map<int, CapitalModel> m = {};

    for (var j in response.data['capital_construction_works']) {
      m[j['oid']] = CapitalModel.fromJson(j);
    }

    return m;
  }

  Future<Map<int, SanitaryModel>> getSanitary() async {
    final response = await _client.get(ApiRoutes.getSanitary);

    Map<int, SanitaryModel> m = {};

    for (var j in response.data['sanitary_protected_zones']) {
      m[j['oid']] = SanitaryModel.fromJson(j);
    }

    return m;
  }

  Future<Map<int, StartModel>> getStartGrounds() async {
    final response = await _client.get(ApiRoutes.getStartGrounds);

    Map<int, StartModel> m = {};

    for (var j in response.data['start_grounds']) {
      m[j['oid']] = StartModel.fromJson(j);
    }

    return m;
  }

  Future<Map<int, CulturalHeritageModel>> getCulturalHeritage() async {
    final response = await _client.get(ApiRoutes.getCulturalHeritage);

    Map<int, CulturalHeritageModel> m = {};

    for (var j in response.data['cultural_heritage']) {
      m[j['oid']] = CulturalHeritageModel.fromJson(j);
    }

    return m;
  }

  Future<Map<int, OrganizationModel>> getOrganizations() async {
    final response = await _client.get(ApiRoutes.getOrganizations);
    Map<int, OrganizationModel> m = {};
    for (var j in response.data['organizations']) {
      m[j['oid']] = OrganizationModel.fromJson(j);
    }
    return m;
  }

  Future<List<SectionModel>> getHeatmap() async {
    final response = await _client.get('${ApiRoutes.heatmap}/50');
    List<SectionModel> m = [];
    for (var j in response.data['heatmap']['sections']) {
      m.add(SectionModel(
          LatLng(j['bbox']['bottom_left']['lat'], j['bbox']['bottom_left']['lon']),
          LatLng(j['bbox']['top_right']['lat'], j['bbox']['top_right']['lon']),
          j['average_data']['is_sanitary_protected_zone'],
          j['average_data']['is_cultural_heritage'],
          j['average_data']['is_unauthorized'],
          j['average_data']['is_mismatch'],
          j['average_data']['is_hazardous'],
          j['average_data']['is_habitable'],
          j['average_data']['is_oks_hazardous'],
          j['average_data']['is_typical'],
          j['average_data']['kol_mest']));
    }


    return m;
  }
}
