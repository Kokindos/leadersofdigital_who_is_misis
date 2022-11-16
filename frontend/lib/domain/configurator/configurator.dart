import 'package:frontend/domain/models/information/section_model.dart';

enum ZoneLevel {none, bad, normal, good}

class Configurator {
  static final Configurator _instance = Configurator._();

  factory Configurator() {
    return _instance;
  }

  Configurator._();

  ZoneLevel Function(SectionModel) calculateFunction = (_)=>ZoneLevel.none;
}