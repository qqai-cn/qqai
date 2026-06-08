import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/features/blog/data/models/blog_page_model.dart';
import 'package:qqai/features/blog/views/blog_detail_side_panel.dart';
import 'package:qqai/features/comment/views/comment_view.dart';
import 'package:qqai/router/app_routes.dart';

/// 媒体详情：左侧黑底内容区（含返回）+ 可选右侧评论栏。
class MediaDetailShell extends StatelessWidget {
  final Widget content;
  final bool showCommentPanel;
  final BlogItem? sidePanelBlog;
  final VoidCallback? onCommentClose;
  final Object? Function()? popResultBuilder;
  final int sidePanelInitialTabIndex;
  final BlogItemCollection? sidePanelCollection;
  final String? sidePanelCollectionVideoDetailRoute;

  const MediaDetailShell({
    super.key,
    required this.content,
    required this.showCommentPanel,
    this.sidePanelBlog,
    this.onCommentClose,
    this.popResultBuilder,
    this.sidePanelInitialTabIndex = 0,
    this.sidePanelCollection,
    this.sidePanelCollectionVideoDetailRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isWideScreen = 1.sw > 900;
    final sidePanel = showCommentPanel ? _buildSidePanel() : null;
    final mediaContent = Container(
      color: Colors.black,
      child: Stack(
        children: [
          content,
          Positioned(
            left: 10,
            child: _BackButtonOverlay(popResultBuilder: popResultBuilder),
          ),
        ],
      ),
    );

    return Scaffold(
      body: isWideScreen
          ? Row(
              children: [
                Expanded(child: mediaContent),
                if (sidePanel != null)
                  SizedBox(width: 350, height: 1.sh, child: sidePanel),
              ],
            )
          : Column(
              children: [
                Expanded(child: mediaContent),
                if (sidePanel != null)
                  PortraitCommentPanel(
                    onDismiss: onCommentClose,
                    child: SizedBox(
                      width: 1.sw,
                      height: 0.6.sh,
                      child: sidePanel,
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildSidePanel() {
    return sidePanelBlog != null
        ? BlogDetailSidePanel(
            key: ValueKey('blog_side_panel_${sidePanelBlog!.id}'),
            blog: sidePanelBlog!,
            onClose: onCommentClose,
            initialTabIndex: sidePanelInitialTabIndex,
            collection: sidePanelCollection,
            collectionVideoDetailRoute:
                sidePanelCollectionVideoDetailRoute ??
                Routes.blogVideoDetailView,
          )
        : const CommentView();
  }
}

/// 窄屏详情底部评论栏：下滑关闭。
class PortraitCommentPanel extends StatefulWidget {
  const PortraitCommentPanel({super.key, required this.child, this.onDismiss});

  final Widget child;
  final VoidCallback? onDismiss;

  @override
  State<PortraitCommentPanel> createState() => _PortraitCommentPanelState();
}

class _PortraitCommentPanelState extends State<PortraitCommentPanel> {
  double _dragOffset = 0;
  bool _dismissed = false;

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_dismissed) return;
    final delta = details.primaryDelta ?? 0;
    if (delta <= 0 && _dragOffset <= 0) return;
    setState(() {
      _dragOffset = (_dragOffset + delta).clamp(0, 120).toDouble();
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dismissed) return;
    final velocity = details.primaryVelocity ?? 0;
    if (_dragOffset > 56 || velocity > 700) {
      _dismissed = true;
      widget.onDismiss?.call();
      return;
    }
    if (_dragOffset == 0) return;
    setState(() => _dragOffset = 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: AnimatedSlide(
        offset: Offset(0, _dragOffset / (0.6.sh)),
        duration: _dragOffset == 0
            ? const Duration(milliseconds: 160)
            : Duration.zero,
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

/// 视频/图片详情等内容区顶部的圆形半透明图标按钮。
class MediaDetailOverlayIconButton extends StatelessWidget {
  const MediaDetailOverlayIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  static Widget buildIcon(IconData icon) {
    return Icon(icon, color: Colors.white.withValues(alpha: 0.5), size: 50);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: buildIcon(icon));
  }
}

class _BackButtonOverlay extends StatelessWidget {
  const _BackButtonOverlay({this.popResultBuilder});

  final Object? Function()? popResultBuilder;

  static const _stackedDetailRoutes = {
    Routes.blogVideoDetailView,
    Routes.videoDetailView,
    Routes.blogImgDetailView,
  };

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop(popResultBuilder?.call());
      var path = GoRouterState.of(context).uri.path;
      while (context.canPop() && _stackedDetailRoutes.contains(path)) {
        context.pop();
        path = GoRouterState.of(context).uri.path;
      }
      return;
    }

    if (_stackedDetailRoutes.contains(GoRouterState.of(context).uri.path)) {
      context.go(Routes.HOME);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaDetailOverlayIconButton(
      icon: Icons.arrow_circle_left,
      onPressed: () => _handleBack(context),
    );
  }
}
