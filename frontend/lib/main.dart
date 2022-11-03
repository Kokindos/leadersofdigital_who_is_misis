import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/main_screen/main_screen.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'presentation/screens/topbar_screen/topbar_screen.dart';

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
      ),
      debugShowCheckedModeBanner: false,
      home: const TopbarScreen(),
    );
  }
}

