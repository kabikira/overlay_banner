import 'package:hooks_riverpod/hooks_riverpod.dart';

class RouteActivationState {
  const RouteActivationState({this.versions = const {}});

  final Map<String, int> versions;

  int versionOf(String routeName) => versions[routeName] ?? 0;

  RouteActivationState bump(String routeName) {
    final next = Map<String, int>.from(versions);
    next[routeName] = versionOf(routeName) + 1;
    return RouteActivationState(versions: next);
  }
}

class RouteActivationNotifier extends StateNotifier<RouteActivationState> {
  RouteActivationNotifier() : super(const RouteActivationState());

  void markActive(String? routeName) {
    if (routeName == null) return;
    state = state.bump(routeName);
  }
}

final routeActivationProvider =
    StateNotifierProvider<RouteActivationNotifier, RouteActivationState>((ref) {
  return RouteActivationNotifier();
});
