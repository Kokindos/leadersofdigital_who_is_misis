import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/screens/main_screen/area_state/context_menu/cubit/context_menu_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/area_state/layers_bar/cubit/choose_layers_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/area_state/layers_bar/cubit/choose_layers_state.dart';
import 'package:frontend/presentation/screens/main_screen/area_state/sidebar/cubit/sidebar_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/loader/cubit/loader_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/main_screen.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/context_menu/show_context_menu_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/context_menu/show_context_menu_state.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/draw/draw_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/draw/layers_state.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/handlers/empty_impl.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/handlers/heatmap_impl.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/handlers/map_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/zoom_bbox_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/topbars/cubit/top_bar_next_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/topbars/cubit/top_bar_state.dart';
import 'package:frontend/presentation/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.inter().fontFamily),
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => LoaderCubit(LoaderState.none),
          ),
          BlocProvider(
            create: (_) => SidebarCubit(null),
          ),
          BlocProvider(
            create: (_) => ChooseLayersCubit(ChooseLayersState({})),
          ),
          BlocProvider(create: (_) => MapCubit(EmptyImpl())),
          BlocProvider(create: (_) => DrawCubit(LayerState([]))),
          BlocProvider(create: (_) => ZoomBBoxCubit(ZoomBBoxState(CameraUpdate.zoomTo(14), LatLng(55.37949118840644, 36.75537470776375), LatLng(56.28408249081925, 38.17401410295989), true))),
          BlocProvider(
            create: (_) => TopBarCubit(
              MainTopBarState(),
            ),
          ),
          BlocProvider(
            create: (_) => ContextMenuCubit(ContextMenuState.added),
          ),
          BlocProvider(
            create: (_) => ShowContextMenuCubit(ClosedShowContextMenuState())
          )
        ],
        child: const MainScreen(),
      ),
    );
  }
}
