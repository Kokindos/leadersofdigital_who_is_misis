import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/presentation/theme/app_colors.dart';
import 'package:frontend/presentation/widgets/lct_button/lct_button.dart';
import 'package:frontend/presentation/widgets/small_button.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MapboxMapController controller;
  bool onDrawed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            MapboxMap(
              accessToken:
                  'pk.eyJ1IjoicGl0dXNhbm9uaW1vdXMiLCJhIjoiY2twcHk5M2VtMDZvZjJ2bzEzMHNhNDM1diJ9.8BLcJknh8FvUVLJRZbHJDQ',
              styleString:
                  'mapbox://styles/pitusanonimous/ckpq0eydh0tk318mr0dcw773k',
              initialCameraPosition: const CameraPosition(
                zoom: 12.0,
                target: LatLng(-33.86711, 151.1947171),
              ),
              onMapCreated: (MapboxMapController c) {
                controller = c;
              },
              onCameraIdle: () {
                if (onDrawed) return;
                onDrawed = true;
                controller.addFill(
                  const FillOptions(
                    geometry: [
                      [
                        LatLng(-33.719, 151.150),
                        LatLng(-33.858, 151.150),
                        LatLng(-33.866, 151.401),
                        LatLng(-33.747, 151.328),
                        LatLng(-33.719, 151.150),
                      ],
                      [
                        LatLng(-33.762, 151.250),
                        LatLng(-33.827, 151.250),
                        LatLng(-33.833, 151.347),
                        LatLng(-33.762, 151.250),
                      ]
                    ],
                    fillColor: "#FF0000",
                    fillOutlineColor: "#FF0000",
                    fillOpacity: 0.3,
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Base"),
            ),
            Positioned(
              top: 80,
              right: 40,
              child: SmallButton(
                  icon: "assets/icons/layers.svg",
                  color: AppColors.neutral800,
                  onPressed: () {}),
            ),
            Positioned(
              top: 120,
              right: 40,
              child: SmallButton(
                  icon: "assets/icons/add.svg",
                  color: AppColors.neutral800,
                  onPressed: () {}),
            ),
            Positioned(
              top: 160,
              right: 40,
              child: SmallButton(
                  icon: "assets/icons/remove.svg",
                  color: AppColors.neutral800,
                  onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
