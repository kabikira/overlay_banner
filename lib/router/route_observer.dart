import 'dart:async';

import 'package:flutter/widgets.dart';

typedef RouteActivationCallback = void Function(String? routeName);

class BannerRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  BannerRouteObserver(this._onRouteActivated);

  final RouteActivationCallback _onRouteActivated;

  void _emit(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (name == null) return;
    scheduleMicrotask(() => _onRouteActivated(name));
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _emit(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _emit(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _emit(previousRoute);
  }
}
