import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/features/video/views/video_item_view.dart';

import '../providers/video_providers.dart';

class VideoListView extends ConsumerStatefulWidget {
  const VideoListView({super.key});

  @override
  ConsumerState<VideoListView> createState() => _VideoListViewState();
}

class _VideoListViewState extends ConsumerState<VideoListView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoState = ref.watch(videoProvider);
    final videoNotifier = ref.read(videoProvider.notifier);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Column(
        children: [
          Container(height: 50, color: Colors.green[50]),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 500.0,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                childAspectRatio: 3 / 2,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return VideoItemView();
              },
            ),
          ),
        ],
      ),
    );
  }
}
