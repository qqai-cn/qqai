import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/auth_providers.dart';
import '../../../router/app_routes.dart';
import '../../video/providers/video_play_queue_provider.dart';
import '../data/models/blog_page_model.dart';
import '../data/repos/blog_repo.dart';
import '../providers/blog_feed_list_actions.dart';

/// 举报原因选项（与后端 BlogReportReqVO.reason 一致）。
const List<(int reason, String label)> kBlogReportReasons = [
  (1, '违法违规'),
  (2, '色情低俗'),
  (3, '垃圾广告'),
  (4, '侵犯权益'),
  (5, '其他'),
];

void showBlogFeedSnackBar(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
}

bool _ensureLoggedIn(BuildContext context, WidgetRef ref) {
  if (ref.read(authProvider).isAuthenticated) return true;
  showBlogFeedSnackBar(context, '请先登录');
  context.push(Routes.login);
  return false;
}

/// 处理瀑布流「更多」菜单项：0 收藏、1 举报、2 不感兴趣、3 加入播放队列。
Future<void> handleBlogFeedMoreMenuSelection({
  required BuildContext context,
  required WidgetRef ref,
  required BlogItem item,
  required String value,
  BlogFeedListActions? feedActions,
}) async {
  switch (value) {
    case '0':
      feedActions?.onCollectTap(item);
      return;
    case '1':
      if (!_ensureLoggedIn(context, ref)) return;
      await _showReportSheet(context, ref, item);
      return;
    case '2':
      if (!_ensureLoggedIn(context, ref)) return;
      if (feedActions != null) {
        await feedActions.onNotInterestedTap(item);
        if (context.mounted) {
          showBlogFeedSnackBar(context, '将减少推荐此类内容');
        }
      }
      return;
    case '3':
      _addToPlayQueue(context, ref, item);
      return;
  }
}

void _addToPlayQueue(BuildContext context, WidgetRef ref, BlogItem item) {
  if (item.blogType != 2) {
    showBlogFeedSnackBar(context, '仅视频可加入播放队列');
    return;
  }
  final added = ref.read(videoPlayQueueProvider.notifier).add(item);
  if (added) {
    showBlogFeedSnackBar(context, '已加入播放队列');
  } else {
    showBlogFeedSnackBar(
      context,
      ref.read(videoPlayQueueProvider.notifier).contains(item.id ?? -1)
          ? '已在播放队列中'
          : '无法加入播放队列',
    );
  }
}

Future<void> _showReportSheet(
  BuildContext context,
  WidgetRef ref,
  BlogItem item,
) async {
  final id = item.id;
  if (id == null) {
    showBlogFeedSnackBar(context, '无法举报：缺少博客编号');
    return;
  }

  int? selectedReason;
  final descriptionController = TextEditingController();

  final submitted = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          final bottom = MediaQuery.viewInsetsOf(context).bottom;
          return Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      '举报',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  for (final entry in kBlogReportReasons)
                    RadioListTile<int>(
                      value: entry.$1,
                      groupValue: selectedReason,
                      title: Text(entry.$2),
                      onChanged: (v) => setState(() => selectedReason = v),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: descriptionController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: '补充说明（选填）',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: FilledButton(
                      onPressed: selectedReason == null
                          ? null
                          : () => Navigator.pop(sheetContext, true),
                      child: const Text('提交举报'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );

  if (submitted != true || selectedReason == null) {
    descriptionController.dispose();
    return;
  }

  try {
    await ref.read(blogRepoProvider).reportBlog(
          id,
          reason: selectedReason!,
          description: descriptionController.text,
        );
    if (context.mounted) {
      showBlogFeedSnackBar(context, '举报已提交，感谢反馈');
    }
  } catch (e) {
    if (context.mounted) {
      showBlogFeedSnackBar(context, e.toString());
    }
  } finally {
    descriptionController.dispose();
  }
}
