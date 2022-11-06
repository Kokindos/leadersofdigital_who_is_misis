import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/main_screen/topbars/choose_top_bar.dart';
import 'package:frontend/presentation/screens/main_screen/topbars/topbar.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'bbox_top_bar.dart';
abstract class TopBarState{
  TopBarState();
}
class MainTopBarState extends TopBarState{

 Widget widget=const Topbar();
  MainTopBarState(): super();
}
class ChooseTopBarState extends TopBarState{
  late List<LatLng> points;
  Widget widget=ChooseTopBar(point: points);
 ChooseTopBarState(this.points): super();
}
class BboxTopBarState extends TopBarState{

  Widget widget=const BboxTopBar();
    BboxTopBarState(): super();
}