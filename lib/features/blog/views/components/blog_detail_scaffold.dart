import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../comment/views/comment_view.dart';

class BlogDetailScaffold extends StatelessWidget {
  final Widget content;
  final bool showCommentPanel;

  const BlogDetailScaffold({
    super.key,
    required this.content,
    required this.showCommentPanel,
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
              child: const CommentView(),
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
