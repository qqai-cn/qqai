import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/components/blog/async_masonry_feed.dart';

import '../data/models/help_page_model.dart';
import '../providers/help_providers.dart';
import 'help_img_item_view.dart';
import 'help_video_item_view.dart';

class HelpView extends ConsumerStatefulWidget {
  final int categary;

  const HelpView(this.categary, {super.key});

  @override
  ConsumerState<HelpView> createState() => _HelpViewState();
}

class _HelpViewState extends ConsumerState<HelpView> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final helpState = ref.watch(helpProvider);
    final helpNotifier = ref.read(helpProvider.notifier);
    final asyncItems = helpState.helpPageModelData.whenData(
      (data) => data.list ?? [],
    );
    return Scaffold(
      backgroundColor: Colors.black12,
      body: AsyncMasonryFeed<HelpItem>(
        asyncItems: asyncItems,
        onRetry: () => helpNotifier.load(),
        itemBuilder: (context, index, helpItem) {
          if (helpItem.blogType == 1) {
            return HelpImgItemView(widget.categary, helpItem);
          }
          return HelpVideoItemView(widget.categary, helpItem);
        },
      ),
    );
  }
}
