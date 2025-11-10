import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../banner/banner_state.dart';
import '../banner/route_activation_provider.dart';
import '../banner/use_banner.dart';

class DetailScreen extends HookConsumerWidget {
  const DetailScreen({super.key});

  static const bannerId = 'detail#topBanner';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerState = ref.watch(bannerStateProvider);
    final notifier = ref.read(bannerStateProvider.notifier);

    useEffect(() {
      final subscription = ref.listenManual<int>(
        routeActivationProvider.select((state) => state.versionOf('detail')),
        (previous, next) {
          if (previous == next) return;
          scheduleMicrotask(() => notifier.reset(bannerId));
        },
        fireImmediately: true,
      );
      return subscription.close;
    }, [ref, notifier]);

    final shouldShow = !bannerState.isDismissed(bannerId);

    useBanner(
      context: context,
      shouldShow: shouldShow,
      banner: _TopBanner(
        text: 'Detail のお知らせバナー',
        onClose: () => notifier.dismiss(bannerId),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: ListView.builder(
        itemCount: 40,
        itemBuilder: (_, index) => ListTile(title: Text('Detail Item $index')),
      ),
    );
  }
}

class _TopBanner extends StatelessWidget {
  final String text;
  final VoidCallback onClose;

  const _TopBanner({required this.text, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        elevation: 6,
        color: Colors.deepPurple,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: onClose,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
