import 'package:flutter/material.dart';

import 'injection/factory.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FeatureFactory _featureFactory = FeatureFactory.compose();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _featureFactory.camera(),
    );
  }
}
