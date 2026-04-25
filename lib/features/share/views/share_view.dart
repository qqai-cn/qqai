import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:qqai/config/theme/my_fonts.dart';
import 'package:qqai/features/share/views/share_img_item_view.dart';
import 'package:qqai/features/share/views/share_video_item_view.dart';

import '../providers/share_providers.dart';
import 'package:qqai/config/theme/app_typography.dart';

class ShareView extends ConsumerStatefulWidget {
  final int categary;

  const ShareView(this.categary, {super.key});

  @override
  ConsumerState<ShareView> createState() => _HelpViewState();
}

class _HelpViewState extends ConsumerState<ShareView> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shareState = ref.watch(shareProvider);
    final shareNotifier = ref.read(shareProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black12,
      body: shareState.sharePageModelData.when(
        data: (data) {
          return MasonryGridView.count(
            itemCount: data.list!.length,
            crossAxisCount: 2,
            controller: scrollController,
            itemBuilder: (context, index) {
              final helpItem = data.list![index];
              if (helpItem.blogType == 1) {
                return Card(child: ShareImgItemView(widget.categary, helpItem));
              } else {
                return Card(
                  child: SizedBox(
                    height: shareNotifier.getVideoItemHeightWithWidth(2, 1.sw),
                    child: ShareVideoItemView(widget.categary, helpItem),
                  ),
                );
              }
            },
          );
        },
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '加载失败: $err',
                style: context.typo.body.copyWith(color: Colors.white),
              ),
              ElevatedButton(
                onPressed: () => shareNotifier.load(),
                child: Text(
                  '重试',
                  style: context.typo.button.copyWith(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
