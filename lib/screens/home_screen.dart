import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../banner/banner_state.dart';
import '../banner/use_banner.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  static const bannerId = 'home#topBanner';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerState = ref.watch(bannerStateProvider);
    final notifier = ref.read(bannerStateProvider.notifier);

    useEffect(() {
      var active = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!active) return;
        notifier.reset(bannerId);
      });
      return () => active = false;
    }, const []);

    final shouldShow = !bannerState.isDismissed(bannerId);

    useBanner(
      context: context,
      shouldShow: shouldShow,
      banner: _TopBanner(
        text: 'Home のお知らせバナー',
        onClose: () => notifier.dismiss(bannerId),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView.builder(
        itemCount: 40,
        itemBuilder: (_, index) => ListTile(
          title: Text('Home Item $index'),
          onTap: () => context.go('/detail'),
        ),
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
        color: Colors.blue,
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
