import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/models/area_model.dart';
import 'package:frontend/presentation/screens/main_screen/bloc/layers_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/bloc/polygon_loader_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/bloc/sidebar_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/configurator/configurator.dart';
import 'package:frontend/presentation/screens/main_screen/export/export_bar.dart';
import 'package:frontend/presentation/screens/main_screen/layers_bar/layers_bar.dart';
import 'package:frontend/presentation/screens/main_screen/topbars/bbox_top_bar.dart';
import 'package:frontend/presentation/screens/main_screen/topbars/choose_top_bar.dart';
import 'package:frontend/presentation/screens/main_screen/topbars/cubit/top_bar_next_cubit.dart';
import 'package:frontend/presentation/screens/main_screen/topbars/cubit/top_bar_state.dart';
import 'package:frontend/presentation/screens/main_screen/widgets/loader.dart';
import 'package:frontend/presentation/screens/main_screen/map/map_widget.dart';
import 'package:frontend/presentation/screens/main_screen/topbars/topbar.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import 'sidebar/side_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int? currentRightPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Column(
              children: [
                BlocBuilder<TopBarNextCubit, TopBarState>(
                  builder: (BuildContext context, TopBarState state) {
                    dev.log(("BLOC BUILDER SUCCESS"));
                    if (state is MainTopBarState) {
                      return Topbar(
                        currentRightPage: currentRightPage,
                        onRightMenuPressed: (c) {
                          setState(
                            () {
                              if (currentRightPage == c) {
                                currentRightPage = null;
                              } else {
                                currentRightPage = c;
                              }
                            },
                          );
                        },
                      );
                    } else if (state is ChooseTopBarState) {
                      return ChooseTopBar(
                        p1: state.p1,
                        p2: state.p2,
                      );
                    } else {
                      return BboxTopBar(
                        currentRightPage: currentRightPage,
                        onRightMenuPressed: (c) {
                          setState(
                            () {
                              if (currentRightPage == c) {
                                currentRightPage = null;
                              } else {
                                currentRightPage = c;
                              }
                            },
                          );
                        },
                      );
                    }
                  },
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (_, c) => Stack(
                      children: [
                        MapWidget(),
                        BlocBuilder<SidebarCubit, AreaModel?>(
                          builder: (_, m) => AnimatedPositioned(
                            top: 0,
                            left: m != null ? 0 : -450,
                            height: c.maxHeight,
                            duration: const Duration(milliseconds: 200),
                            child: PointerInterceptor(
                              child: SideBar(),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          top: 0,
                          right: currentRightPage == 0 ? 0 : -450,
                          height: c.maxHeight,
                          duration: const Duration(milliseconds: 200),
                          child: PointerInterceptor(
                            child: LayersBar(
                              onChanged: (l) =>
                                  context.read<LayersCubit>().setLayers(l),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          top: 0,
                          right: currentRightPage == 3 ? 0 : -450,
                          height: c.maxHeight,
                          duration: const Duration(milliseconds: 200),
                          child: const ExportBar(),
                        ),
                        AnimatedPositioned(
                          top: 0,
                          right: currentRightPage == 1 ? 0 : -600,
                          height: c.maxHeight,
                          duration: const Duration(milliseconds: 200),
                          child: const ConfiguratorBar(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            BlocBuilder<PolygonLoaderCubit, DownloadedState>(
              builder: (_, data) => PointerInterceptor(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  child: data == DownloadedState.inProgress
                      ? Loader()
                      : const SizedBox(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
