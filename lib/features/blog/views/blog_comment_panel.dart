import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/components/chat/widgets/floating_emoji_picker.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/config/theme/my_fonts.dart';
import 'package:qqai/providers/auth_providers.dart';
import 'package:qqai/router/app_routes.dart';
import 'package:qqai/util/format_count.dart';
import 'package:qqai/util/media_url.dart';

import '../data/models/blog_comment_model.dart';
import '../data/models/blog_page_model.dart';
import '../providers/blog_comment_providers.dart';

TextStyle _blogCommentContentStyle(BuildContext context) {
  final wide = MyFonts.isWideScreen(context);
  return context.typo.body.copyWith(
    fontSize: wide ? 14 : 13,
    height: 1.35,
  );
}

TextStyle _blogCommentMetaStyle(BuildContext context) {
  final wide = MyFonts.isWideScreen(context);
  return context.typo.caption.copyWith(
    fontSize: wide ? 12 : 11,
  );
}

void showBlogCommentSheet(BuildContext context, BlogItem blog) {
  final blogId = blog.id;
  if (blogId == null) return;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, scrollController) => Material(
        color: AppActionColors.surface(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: BlogCommentPanel(
          blogId: blogId,
          blogAuthorUserId: blog.userId,
          initialCommentCount: blog.commentCount,
          scrollController: scrollController,
          showCloseButton: true,
          onClose: () => Navigator.pop(ctx),
        ),
      ),
    ),
  );
}

class BlogCommentPanel extends ConsumerStatefulWidget {
  final int blogId;
  final int? blogAuthorUserId;
  final int? initialCommentCount;
  final ScrollController? scrollController;
  final bool showCloseButton;
  final bool showTopHeader;
  final VoidCallback? onClose;

  const BlogCommentPanel({
    super.key,
    required this.blogId,
    this.blogAuthorUserId,
    this.initialCommentCount,
    this.scrollController,
    this.showCloseButton = false,
    this.showTopHeader = true,
    this.onClose,
  });

  @override
  ConsumerState<BlogCommentPanel> createState() => _BlogCommentPanelState();
}

class _BlogCommentPanelState extends ConsumerState<BlogCommentPanel> {
  final TextEditingController _input = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _emojiButtonKey = GlobalKey();
  late final FloatingEmojiPickerController _emojiPicker;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _focusNode.onKeyEvent = _handleCommentKey;
    _emojiPicker = FloatingEmojiPickerController(
      onEmojiSelected: _insertEmoji,
      onVisibilityChanged: () {
        if (mounted) setState(() {});
      },
    );
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && _emojiPicker.isVisible && mounted) {
      _emojiPicker.hide();
      setState(() {});
    }
  }

  KeyEventResult _handleCommentKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final isEnter = event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter;
    if (!isEnter || HardwareKeyboard.instance.isShiftPressed) {
      return KeyEventResult.ignored;
    }
    if (!mounted) return KeyEventResult.handled;
    final feed = ref.read(blogCommentsProvider(widget.blogId));
    if (feed.sending) return KeyEventResult.handled;
    final notifier = ref.read(blogCommentsProvider(widget.blogId).notifier);
    _submit(context, notifier);
    return KeyEventResult.handled;
  }

  void _toggleEmojiPanel() {
    if (_emojiPicker.isVisible) {
      _emojiPicker.hide();
      _focusNode.requestFocus();
      setState(() {});
      return;
    }
    _emojiPicker.show(context, _emojiButtonKey);
    _focusNode.unfocus();
    setState(() {});
  }

  void _insertEmoji(String emoji) {
    insertTextAtSelection(_input, emoji);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _emojiPicker.dispose();
    _focusNode.removeListener(_onFocusChange);
    _input.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  int? get _myUserId => int.tryParse((ref.read(authProvider).userId ?? '').trim());

  bool get _isBlogAuthor =>
      widget.blogAuthorUserId != null &&
      _myUserId != null &&
      widget.blogAuthorUserId == _myUserId;

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(blogCommentsProvider(widget.blogId));
    final notifier = ref.read(blogCommentsProvider(widget.blogId).notifier);
    final count = feed.totalCount > 0
        ? feed.totalCount
        : (widget.initialCommentCount ?? 0);

    return Column(
      children: [
        if (widget.showTopHeader) _buildHeader(context, count),
        _buildSortBar(feed.sortType, notifier, count: count),
        if (feed.error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              feed.error!,
              style: context.typo.caption.copyWith(color: Colors.red),
            ),
          ),
        Expanded(child: _buildList(feed, notifier)),
        _buildInputBar(context, feed, notifier),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 4, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$count条评论',
              style: context.typo.sectionTitle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (widget.showCloseButton)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: widget.onClose,
            ),
        ],
      ),
    );
  }

  Widget _buildSortBar(
    String sortType,
    BlogComments notifier, {
    int? count,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          if (!widget.showTopHeader && count != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                '$count条',
                style: context.typo.caption.copyWith(
                  color: AppActionColors.muted(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          _SortChip(
            label: '最热',
            selected: sortType == 'hot',
            onTap: () => notifier.setSortType('hot'),
          ),
          const SizedBox(width: 8),
          _SortChip(
            label: '最新',
            selected: sortType == 'time',
            onTap: () => notifier.setSortType('time'),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BlogCommentFeedState feed, BlogComments notifier) {
    if (feed.loading && feed.threads.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!feed.loading && feed.threads.isEmpty) {
      return Center(
        child: Text(
          '暂无评论，快来抢沙发',
          style: _blogCommentContentStyle(context).copyWith(
            color: AppActionColors.muted(context),
          ),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n is ScrollEndNotification &&
            n.metrics.pixels >= n.metrics.maxScrollExtent - 120) {
          notifier.loadMore();
        }
        return false;
      },
      child: ListView.builder(
        controller: widget.scrollController,
        padding: const EdgeInsets.only(bottom: 8),
        itemCount: feed.threads.length + (feed.loadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= feed.threads.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return _RootCommentTile(
            thread: feed.threads[index],
            threadIndex: index,
            blogId: widget.blogId,
            isBlogAuthor: _isBlogAuthor,
            myUserId: _myUserId,
            onReplyRoot: () {
              notifier.replyToRoot(feed.threads[index].root);
              _focusNode.requestFocus();
            },
            onExpandReplies: () {
              final rootId = feed.threads[index].root.id;
              if (rootId != null) notifier.expandReplies(rootId);
            },
            onReplyComment: (reply) {
              notifier.replyToComment(
                feed.threads[index].root,
                reply,
              );
              _focusNode.requestFocus();
            },
            onDelete: (id) => notifier.deleteComment(id),
            onPin: (id) => notifier.pinComment(id),
            onLike: (id) => _toggleCommentLike(context, notifier, id),
          );
        },
      ),
    );
  }

  Widget _buildInputBar(
    BuildContext context,
    BlogCommentFeedState feed,
    BlogComments notifier,
  ) {
    final target = feed.replyTarget;
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (target != null)
            Container(
              width: double.infinity,
              color: AppActionColors.borderSubtle(context),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      target.hint,
                      style: context.typo.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: notifier.cancelReply,
                    child: const Text('取消'),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
            child: Row(
              children: [
                IconButton(
                  key: _emojiButtonKey,
                  onPressed: _toggleEmojiPanel,
                  tooltip: _emojiPicker.isVisible ? '键盘' : '表情',
                  icon: Icon(
                    _emojiPicker.isVisible
                        ? Icons.keyboard_outlined
                        : Icons.emoji_emotions_outlined,
                    color: AppActionColors.foreground(context),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _input,
                    focusNode: _focusNode,
                    minLines: 1,
                    maxLines: 4,
                    style: TextStyle(color: AppActionColors.strong(context)),
                    decoration: InputDecoration(
                      hintText: target == null ? '说点什么…' : '写下你的回复…',
                      hintStyle: TextStyle(
                        color: AppActionColors.subtle(context),
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: AppActionColors.borderSubtle(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: AppActionColors.borderSubtle(context),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: AppActionColors.borderSubtle(context),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: AppActionColors.foreground(context),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                feed.sending
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.send,
                          color: AppActionColors.foreground(context),
                        ),
                        onPressed: () => _submit(context, notifier),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleCommentLike(
    BuildContext context,
    BlogComments notifier,
    int commentId,
  ) {
    final auth = ref.read(authProvider);
    if (!auth.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先登录后再点赞')),
      );
      context.push(Routes.login);
      return;
    }
    notifier.toggleCommentLike(commentId);
  }

  Future<void> _submit(BuildContext context, BlogComments notifier) async {
    final auth = ref.read(authProvider);
    if (!auth.isAuthenticated) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请先登录后再评论')),
        );
        context.push(Routes.login);
      }
      return;
    }
    final ok = await notifier.submitComment(_input.text);
    if (ok) {
      _input.clear();
      _emojiPicker.hide();
      if (mounted) _focusNode.unfocus();
    }
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? scheme.primary
              : AppActionColors.borderSubtle(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: context.typo.caption.copyWith(
            color: selected ? scheme.onPrimary : AppActionColors.muted(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _RootCommentTile extends StatelessWidget {
  final BlogCommentThread thread;
  final int threadIndex;
  final int blogId;
  final bool isBlogAuthor;
  final int? myUserId;
  final VoidCallback onReplyRoot;
  final VoidCallback onExpandReplies;
  final void Function(BlogComment reply) onReplyComment;
  final void Function(int id) onDelete;
  final void Function(int id) onPin;
  final void Function(int id) onLike;

  static String _expandRepliesLabel(BlogCommentThread thread) {
    final hidden = thread.replyTotal - thread.replies.length;
    if (hidden > 0) return '展开$hidden条回复';
    return '展开更多回复';
  }

  const _RootCommentTile({
    required this.thread,
    required this.threadIndex,
    required this.blogId,
    required this.isBlogAuthor,
    required this.myUserId,
    required this.onReplyRoot,
    required this.onExpandReplies,
    required this.onReplyComment,
    required this.onDelete,
    required this.onPin,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    final root = thread.root;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CommentRow(
            comment: root,
            isBlogAuthor: isBlogAuthor,
            myUserId: myUserId,
            isRoot: true,
            onReply: onReplyRoot,
            onDelete: onDelete,
            onPin: onPin,
            onLike: () {
              final id = root.id;
              if (id != null) onLike(id);
            },
          ),
          ...thread.replies.map(
            (r) => Padding(
              padding: const EdgeInsets.only(left: 44, top: 6),
              child: _CommentRow(
                comment: r,
                isBlogAuthor: isBlogAuthor,
                myUserId: myUserId,
                isRoot: false,
                onReply: () => onReplyComment(r),
                onDelete: onDelete,
                onPin: onPin,
                onLike: () {
                  final id = r.id;
                  if (id != null) onLike(id);
                },
              ),
            ),
          ),
          if (thread.canExpandMore)
            Padding(
              padding: const EdgeInsets.only(left: 44, top: 4),
              child: TextButton(
                onPressed: thread.loadingReplies ? null : onExpandReplies,
                child: thread.loadingReplies
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _expandRepliesLabel(thread),
                        style: _blogCommentMetaStyle(context).copyWith(
                          color: Colors.blue,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CommentRow extends StatelessWidget {
  final BlogComment comment;
  final bool isBlogAuthor;
  final int? myUserId;
  final bool isRoot;
  final VoidCallback onReply;
  final VoidCallback onLike;
  final void Function(int id) onDelete;
  final void Function(int id) onPin;

  const _CommentRow({
    required this.comment,
    required this.isBlogAuthor,
    required this.myUserId,
    required this.isRoot,
    required this.onReply,
    required this.onLike,
    required this.onDelete,
    required this.onPin,
  });

  @override
  Widget build(BuildContext context) {
    final avatarUrl = resolveMediaUrl(comment.avatar);
    final isMine = myUserId != null && comment.userId == myUserId;
    final id = comment.id;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Avatar(url: avatarUrl, size: isRoot ? 36 : 30),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      comment.nickname ?? '用户',
                      style: _blogCommentMetaStyle(context).copyWith(
                        color: AppActionColors.muted(context),
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (comment.pinned == true) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.orange.shade100
                            : Colors.orange.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '置顶',
                        style: context.typo.caption.copyWith(
                          fontSize: 10,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (id != null)
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_horiz,
                        size: 18,
                        color: AppActionColors.muted(context),
                      ),
                      onSelected: (v) {
                        if (v == 'delete') onDelete(id);
                        if (v == 'pin') onPin(id);
                      },
                      itemBuilder: (context) => [
                        if (isMine)
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('删除'),
                          ),
                        if (isBlogAuthor && isRoot)
                          const PopupMenuItem(
                            value: 'pin',
                            child: Text('置顶'),
                          ),
                      ],
                    ),
                ],
              ),
              if ((comment.replyNickname ?? '').isNotEmpty &&
                  (comment.parentId ?? 0) > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '回复 ',
                          style: _blogCommentMetaStyle(context).copyWith(
                            color: AppActionColors.subtle(context),
                          ),
                        ),
                        TextSpan(
                          text: comment.replyNickname,
                          style: _blogCommentMetaStyle(context).copyWith(
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SelectableText(
                comment.content ?? '',
                style: _blogCommentContentStyle(context),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    _formatTime(comment.createTime),
                    style: _blogCommentMetaStyle(context).copyWith(
                      color: AppActionColors.subtle(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: onReply,
                    child: Text(
                      '回复',
                      style: _blogCommentMetaStyle(context).copyWith(
                        color: AppActionColors.muted(context),
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: id != null ? onLike : null,
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          comment.liked == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 14,
                          color: comment.liked == true
                              ? Colors.red
                              : AppActionColors.subtle(context),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          (comment.likeCount ?? 0) > 0
                              ? formatCompactCount(comment.likeCount)
                              : '',
                          style: _blogCommentMetaStyle(context).copyWith(
                            color: AppActionColors.subtle(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final s = raw.trim();
    if (s.length >= 16) return s.substring(0, 16);
    return s;
  }
}

class _Avatar extends StatelessWidget {
  final String? url;
  final double size;

  const _Avatar({this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    final resolved = resolveMediaUrl(url);
    if (resolved != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: CachedNetworkImage(
          imageUrl: resolved,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorWidget: (_, _, _) => _placeholder(),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Image.asset(
      'imgs/img_default.png',
      width: size,
      height: size,
    );
  }
}
