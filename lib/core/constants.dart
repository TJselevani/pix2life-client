// constraints.dart

import 'package:flutter/material.dart';

class AppConstraints {
  // Define common constraints used throughout the app
  static const BoxConstraints tightConstraints = BoxConstraints.tightFor(
    width: 100.0,
    height: 100.0,
  );

  static BoxConstraints looseConstraints = BoxConstraints.loose(
    const Size(200.0, 200.0),
  );

  static const BoxConstraints expandedConstraints = BoxConstraints.expand(
    width: 300.0,
    height: 300.0,
  );

  static const BoxConstraints minConstraints = BoxConstraints(
    minWidth: 50.0,
    minHeight: 50.0,
  );

  static const BoxConstraints maxConstraints = BoxConstraints(
    maxWidth: 400.0,
    maxHeight: 400.0,
  );
}
