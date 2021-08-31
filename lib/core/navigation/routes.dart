import 'package:flutter/material.dart';

import '../../injection/factory.dart';

abstract class PageRoutes {
  static MaterialPageRoute gallery() => MaterialPageRoute(
        builder: (_) => FeatureFactory.compose().gallery(),
      );
}
