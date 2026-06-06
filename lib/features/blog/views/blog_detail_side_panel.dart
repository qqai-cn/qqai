import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../data/models/blog_page_model.dart';
import '../../../router/app_routes.dart';
import 'blog_comment_panel.dart';
import 'blog_related_recommend_view.dart';

/// 宽屏详情右侧：评论 + 相关推荐 + 合集（Tab）。
class BlogDetailSidePanel extends StatefulWidget {
  final BlogItem blog;
  final VoidCallback? onClose;
  final int initialTabIndex;
  final BlogItemCollection? collection;
  final String collectionVideoDetailRoute;

  const BlogDetailSidePanel({
    super.key,
    required this.blog,
    this.onClose,
    this.initialTabIndex = 0,
    this.collection,
    this.collectionVideoDetailRoute = Routes.blogVideoDetailView,
  });

  @override
  State<BlogDetailSidePanel> createState() => _BlogDetailSidePanelState();
}

class _BlogDetailSidePanelState extends State<BlogDetailSidePanel>
    with SingleTickerProviderStateMixin {
  static const _baseTabs = ['评论', '相关推荐'];
  static const _collectionTab = '合集';
  late TabController _tabController;

  bool get _hasCollection => widget.collection?.id != null;

  List<String> get _tabs => [..._baseTabs, if (_hasCollection) _collectionTab];

  @override
  void initState() {
    super.initState();
    _tabController = _createController();
  }

  @override
  void didUpdateWidget(BlogDetailSidePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldHasCollection = oldWidget.collection?.id != null;
    if (oldHasCollection != _hasCollection) {
      _tabController.dispose();
      _tabController = _createController();
      return;
    }
    final nextIndex = _safeTabIndex(widget.initialTabIndex);
    if (nextIndex != _tabController.index ||
        widget.collection?.id != oldWidget.collection?.id) {
      _tabController.animateTo(nextIndex);
    }
  }

  TabController _createController() {
    return TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: _safeTabIndex(widget.initialTabIndex),
    );
  }

  int _safeTabIndex(int index) => index.clamp(0, _tabs.length - 1);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blogId = widget.blog.id;
    if (blogId == null) {
      return const Center(child: Text('无效的博客'));
    }

    return ColoredBox(
      color: AppActionColors.surface(context),
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: AppActionColors.strong(context),
                    unselectedLabelColor: AppActionColors.muted(context),
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    labelStyle: context.typo.sectionTitle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: context.typo.sectionTitle,
                    tabs: _tabs
                        .map((t) => Tab(height: 44, child: Text(t)))
                        .toList(),
                  ),
                ),
                if (widget.onClose != null)
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: AppActionColors.foreground(context),
                    ),
                    onPressed: widget.onClose,
                  ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: AppActionColors.borderSubtle(context),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                BlogCommentPanel(
                  blogId: blogId,
                  blogAuthorUserId: widget.blog.userId,
                  initialCommentCount: widget.blog.commentCount,
                  showTopHeader: false,
                ),
                BlogRelatedRecommendView(
                  currentBlog: widget.blog,
                  detailRoute: widget.collectionVideoDetailRoute,
                ),
                if (_hasCollection)
                  BlogCollectionVideosView(
                    currentBlog: widget.blog,
                    collection: widget.collection,
                    detailRoute: widget.collectionVideoDetailRoute,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
