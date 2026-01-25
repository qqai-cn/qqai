import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
    final helpState = ref.watch(helpProvider);
    final helpNotifier = ref.read(helpProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black12,
      body: helpState.helpPageModelData.when(
        data: (data) {
         return MasonryGridView.count(
            itemCount: data.list!.length,
            crossAxisCount: 2,
            controller: scrollController,
            itemBuilder: (context, index) {
              final helpItem = data.list![index];
              if (helpItem.blogType == 1) {
                return Card(child: HelpImgItemView(widget.categary, helpItem));
              } else {
                return Card(
                  child: SizedBox(
                    height: helpNotifier.getVideoItemHeightWithWidth(2, 1.sw),
                    child: HelpVideoItemView(widget.categary, helpItem),
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
              Text('加载失败: $err', style: const TextStyle(color: Colors.white)),
              ElevatedButton(
                onPressed: () => helpNotifier.load(),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
