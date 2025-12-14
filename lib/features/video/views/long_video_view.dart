import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/providers/long_video_providers.dart';
import 'long_video_item_view.dart';

class LongVideoView extends ConsumerWidget {
  const LongVideoView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final longVideoState = ref.watch(longVideoProvider);
    
    return Material(
        child: Padding(
      padding: const EdgeInsets.all(0),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 500.0,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              childAspectRatio: 3 / 2),
          itemCount: longVideoState.videoItems.length,
          itemBuilder: (context, index) {
            return LongVideoItemView();
          }),
    ));
  }
}
