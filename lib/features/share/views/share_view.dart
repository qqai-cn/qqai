import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/components/blog/async_masonry_feed.dart';
import 'package:qqai/features/share/views/share_img_item_view.dart';
import 'package:qqai/features/share/views/share_video_item_view.dart';

import '../data/models/share_page_model.dart';
import '../providers/share_providers.dart';

class ShareView extends ConsumerStatefulWidget {
  final int categary;

  const ShareView(this.categary, {super.key});

  @override
  ConsumerState<ShareView> createState() => _ShareViewState();
}

class _ShareViewState extends ConsumerState<ShareView> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shareState = ref.watch(shareProvider);
    final shareNotifier = ref.read(shareProvider.notifier);
    final asyncItems = shareState.sharePageModelData.whenData(
      (data) => data.list ?? [],
    );
    return Scaffold(
      backgroundColor: Colors.black12,
      body: AsyncMasonryFeed<ShareItem>(
        asyncItems: asyncItems,
        onRetry: () => shareNotifier.load(),
        itemBuilder: (context, index, item) {
          if (item.blogType == 1) {
            return Card(child: ShareImgItemView(widget.categary, item));
          }
          return Card(
            child: SizedBox(
              height: shareNotifier.getVideoItemHeightWithWidth(
                1.sw <= 800 ? 1 : 2,
                1.sw,
              ),
              child: ShareVideoItemView(widget.categary, item),
            ),
          );
        },
      ),
    );
  }
}
