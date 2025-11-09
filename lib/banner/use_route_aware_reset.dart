import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../router/route_observer.dart';

void useRouteAwareReset({
  required BuildContext context,
  required VoidCallback onActive,
}) {
  final routeAware = useMemoized(() => _BannerRouteAware(onActive), [onActive]);

  useEffect(() {
    PageRoute<dynamic>? subscribedRoute;

    void subscribe() {
      final route = ModalRoute.of(context);
      if (route is! PageRoute) return;
      routeObserver.subscribe(routeAware, route);
      subscribedRoute = route;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (subscribedRoute != null) return;
      subscribe();
    });

    return () {
      if (subscribedRoute != null) {
        routeObserver.unsubscribe(routeAware);
        subscribedRoute = null;
      }
    };
  }, [routeAware, context]);
}

class _BannerRouteAware extends RouteAware {
  _BannerRouteAware(this.onActive);

  final VoidCallback onActive;

  void _scheduleReset() {
    scheduleMicrotask(onActive);
  }

  @override
  void didPush() => _scheduleReset();

  @override
  void didPopNext() => _scheduleReset();
}
