import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/features/blog/views/blog_detail_side_panel.dart';
import 'package:qqai/features/comment/views/comment_view.dart';

/// 媒体详情：左侧黑底内容区（含返回）+ 可选右侧评论栏。
class MediaDetailShell extends StatelessWidget {
  final Widget content;
  final bool showCommentPanel;
  final BlogItem? sidePanelBlog;
  final VoidCallback? onCommentClose;

  const MediaDetailShell({
    super.key,
    required this.content,
    required this.showCommentPanel,
    this.sidePanelBlog,
    this.onCommentClose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  content,
                  const Positioned(
                    left: 10,
                    child: _BackButtonOverlay(),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: showCommentPanel,
            child: SizedBox(
              width: 350,
              height: 1.sh,
              child: sidePanelBlog != null
                  ? BlogDetailSidePanel(
                      blog: sidePanelBlog!,
                      onClose: onCommentClose,
                    )
                  : const CommentView(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButtonOverlay extends StatelessWidget {
  const _BackButtonOverlay();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Icons.arrow_circle_left,
        color: Colors.white.withValues(alpha: 0.5),
        size: 50,
      ),
    );
  }
}
