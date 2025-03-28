import 'package:flutter/widgets.dart';

abstract class FlutterModule {
  static GlobalKey<NavigatorState>? _navigatorKeyInstance;

  static GlobalKey<NavigatorState> navigatorKey() {
    return _navigatorKeyInstance ??= GlobalKey<NavigatorState>();
  }
}
