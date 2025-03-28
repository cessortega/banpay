import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'routes.dart';

export 'routes.dart';

const _tag = '[route]';
final logger = Logger();

class Router {
  const Router(this._navigatorKey);

  final GlobalKey<NavigatorState> _navigatorKey;

  Route<dynamic>? generateRoute(RouteSettings settings) {
    final route = _toPathRoute(settings);
    return route?.asRoute();
  }

  PathRoute? _toPathRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/list':
        return const PokemonListRoute();
      default:
        return settings.arguments as PathRoute?;
    }
  }

  Future<T?> pushTo<T extends ActionResult?>(PathRoute<T> route) async {
    _logIfBadStatus();

    final pageRoute = route.asRoute();
    logger.d('$_tag pushTo $route');

    final result = await _navigatorKey.currentState?.push(pageRoute);
    logger.i('$_tag ${route.name} result: $result');

    return result;
  }

  Future<T?> replaceTo<T extends ActionResult?>(PathRoute<T> route) {
    _logIfBadStatus();
    return _navigatorKey.currentState!
        .pushAndRemoveUntil(route.asRoute(), (_) => false);
  }

  void pop<T extends ActionResult>([T? result]) {
    _logIfBadStatus();
    _navigatorKey.currentState?.pop(result);
  }

  void _logIfBadStatus() {
    if (_navigatorKey.currentState == null) {
      logger.w('$_tag bad state, the currentState is null');
    }
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Abstract Route Definitions
// ──────────────────────────────────────────────────────────────────────────────

abstract class PathRoute<R extends ActionResult?> {
  const PathRoute();

  Widget get page;

  String get name;

  Map<String, dynamic> get arguments;

  PageRoute<R> asRoute() {
    return MaterialPageRoute<R>(
      builder: (_) => page,
      settings: RouteSettings(name: name, arguments: this),
    );
  }

  @override
  String toString() => 'PathRoute{name: $name, arguments: $arguments}';
}

abstract class TransparentRoute<T extends ActionResult?> extends PathRoute<T> {
  const TransparentRoute();

  @override
  PageRoute<T> asRoute({bool shouldShowAsDialog = false}) {
    return PageRouteBuilder(
      opaque: false,
      settings: RouteSettings(name: name, arguments: this),
      pageBuilder: (context, animation, secondaryAnimation) => page,
    );
  }

  @override
  String toString() => 'TransparentRoute{name: $name, arguments: $arguments}';
}

abstract class ActionResult {
  const ActionResult();

  String get name;

  Map<String, dynamic> get arguments;

  @override
  String toString() => 'ActionResult{name: $name, arguments: $arguments}';
}

// ──────────────────────────────────────────────────────────────────────────────
// Optional Animated Page Route
// ──────────────────────────────────────────────────────────────────────────────

class AnimatedPageRoute<T> extends PageRouteBuilder<T> {
  AnimatedPageRoute({
    required this.page,
    required this.settings,
    this.duration = const Duration(milliseconds: 600),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          settings: settings,
          transitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0, 1);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: tween.animate(curvedAnimation),
                child: child,
              ),
            );
          },
        );

  final Widget page;
  @override
  final RouteSettings settings;
  final Duration duration;
}
