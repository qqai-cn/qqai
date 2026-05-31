import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../comment/providers/comment_providers.dart';

/// 宽屏博客详情：进入时展开右侧评论栏，离开时收起。
///
/// 在 [initState] 中缓存 [CommentNotifier]，[dispose] 时勿再使用 [WidgetRef]。
class BlogDetailCommentSidePanelLifecycle {
  BlogDetailCommentSidePanelLifecycle(this._notifier);

  final CommentNotifier _notifier;

  void bind() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (1.sw > 900) {
        _notifier.openCommentPanel();
      }
    });
  }

  /// 须在 widget 树构建/销毁阶段之外修改 provider；下一帧收起，避免 pop 后列表页闪出侧栏。
  void unbind() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifier.dontShowComment();
    });
  }
}
