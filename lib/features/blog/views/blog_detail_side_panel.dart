import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../data/models/blog_page_model.dart';
import 'blog_comment_panel.dart';
import 'blog_related_recommend_view.dart';

/// 宽屏详情右侧：评论 + 相关推荐（Tab）。
class BlogDetailSidePanel extends StatefulWidget {
  final BlogItem blog;
  final VoidCallback? onClose;

  const BlogDetailSidePanel({
    super.key,
    required this.blog,
    this.onClose,
  });

  @override
  State<BlogDetailSidePanel> createState() => _BlogDetailSidePanelState();
}

class _BlogDetailSidePanelState extends State<BlogDetailSidePanel>
    with SingleTickerProviderStateMixin {
  static const _tabs = ['评论', '相关推荐'];
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

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

    return Column(
      children: [
        Material(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: context.typo.sectionTitle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: context.typo.sectionTitle,
                    tabs: _tabs
                        .map(
                          (t) => Tab(
                            height: 44,
                            child: Text(t),
                          ),
                        )
                        .toList(),
                  ),
                ),
                if (widget.onClose != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: widget.onClose,
                  ),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
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
              BlogRelatedRecommendView(currentBlog: widget.blog),
            ],
          ),
        ),
      ],
    );
  }
}
