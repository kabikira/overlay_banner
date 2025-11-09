import 'package:hooks_riverpod/hooks_riverpod.dart';

class BannerState {
  const BannerState._(this._dismissed);

  factory BannerState.initial() => const BannerState._(<String>{});

  final Set<String> _dismissed;

  bool isDismissed(String id) => _dismissed.contains(id);

  BannerState dismiss(String id) => BannerState._({..._dismissed, id});

  BannerState reset(String id) {
    final next = {..._dismissed};
    next.remove(id);
    return BannerState._(next);
  }
}

class BannerStateNotifier extends StateNotifier<BannerState> {
  BannerStateNotifier() : super(BannerState.initial());

  void dismiss(String id) => state = state.dismiss(id);

  void reset(String id) => state = state.reset(id);
}

final bannerStateProvider =
    StateNotifierProvider<BannerStateNotifier, BannerState>((ref) {
  return BannerStateNotifier();
});
