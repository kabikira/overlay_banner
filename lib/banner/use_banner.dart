import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useBanner({
  required BuildContext context,
  required bool shouldShow,
  required Widget banner,
}) {
  final entryRef = useRef<OverlayEntry?>(null);

  void insert() {
    if (entryRef.value != null) return;
    final overlay = Overlay.maybeOf(context, rootOverlay: false);
    if (overlay == null) return;

    entryRef.value = OverlayEntry(
      builder: (_) => SafeArea(top: true, child: banner),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final entry = entryRef.value;
      if (entry != null && entry.mounted == false) {
        overlay.insert(entry);
      } else if (entry != null) {
        // entry already mounted; ignore
      }
    });
  }

  void remove() {
    final entry = entryRef.value;
    if (entry == null) return;
    if (entry.mounted) {
      entry.remove();
    }
    entryRef.value = null;
  }

  useEffect(() {
    if (shouldShow) {
      insert();
    } else {
      remove();
    }
    return remove;
  }, [shouldShow]);
}
