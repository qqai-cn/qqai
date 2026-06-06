import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/blog_comment_model.dart';
import '../data/repos/blog_comment_repo.dart';

part 'blog_comment_providers.freezed.dart';
part 'blog_comment_providers.g.dart';

/// 回复目标（楼中楼）。
class BlogCommentReplyTarget {
  const BlogCommentReplyTarget({
    required this.parentId,
    required this.rootId,
    this.replyUserId,
    required this.hint,
  });

  final int parentId;
  final int rootId;
  final int? replyUserId;
  final String hint;
}

class BlogCommentThread {
  BlogCommentThread({
    required this.root,
    List<BlogComment>? replies,
    this.loadingReplies = false,
    this.repliesPage = 0,
    bool? hasMoreReplies,
  }) : replies = List<BlogComment>.from(replies ?? root.previewReplies),
       hasMoreReplies =
           hasMoreReplies ??
           _initialHasMoreReplies(root, replies ?? root.previewReplies);

  static bool _initialHasMoreReplies(
    BlogComment root,
    List<BlogComment> loaded,
  ) {
    final total = root.replyCount;
    if (total == null) return false;
    return loaded.length < total;
  }

  final BlogComment root;
  final List<BlogComment> replies;
  final bool loadingReplies;
  final int repliesPage;
  final bool hasMoreReplies;

  int get replyTotal {
    final count = root.replyCount;
    if (count != null && count >= 0) return count;
    return replies.length;
  }

  bool get canExpandMore => !loadingReplies && replies.length < replyTotal;

  BlogCommentThread copyWith({
    BlogComment? root,
    List<BlogComment>? replies,
    bool? loadingReplies,
    int? repliesPage,
    bool? hasMoreReplies,
  }) {
    return BlogCommentThread(
      root: root ?? this.root,
      replies: replies ?? this.replies,
      loadingReplies: loadingReplies ?? this.loadingReplies,
      repliesPage: repliesPage ?? this.repliesPage,
      hasMoreReplies: hasMoreReplies ?? this.hasMoreReplies,
    );
  }
}

@freezed
sealed class BlogCommentFeedState with _$BlogCommentFeedState {
  const factory BlogCommentFeedState({
    @Default(false) bool loading,
    @Default(false) bool loadingMore,
    @Default(false) bool sending,
    @Default('hot') String sortType,
    @Default([]) List<BlogCommentThread> threads,
    @Default(0) int totalCount,
    @Default(1) int pageNo,
    @Default(true) bool hasMore,
    BlogCommentReplyTarget? replyTarget,
    String? error,
  }) = _BlogCommentFeedState;
}

@riverpod
class BlogComments extends _$BlogComments {
  late final IBlogCommentRepo _repo;

  @override
  BlogCommentFeedState build(int blogId) {
    _repo = ref.read(blogCommentRepoProvider);
    Future.microtask(refresh);
    return const BlogCommentFeedState(loading: true);
  }

  Future<void> refresh() async {
    state = state.copyWith(loading: true, error: null, pageNo: 1, hasMore: true);
    try {
      final count = await _repo.getCommentCount(blogId);
      final page = await _repo.getRootCommentPage(
        blogId: blogId,
        pageNo: 1,
        sortType: state.sortType,
      );
      final list = page.list ?? [];
      state = state.copyWith(
        loading: false,
        totalCount: count,
        threads: list.map((c) => BlogCommentThread(root: c)).toList(),
        pageNo: 1,
        hasMore: list.length >= 20,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.loadingMore || !state.hasMore || state.loading) return;
    state = state.copyWith(loadingMore: true);
    try {
      final next = state.pageNo + 1;
      final page = await _repo.getRootCommentPage(
        blogId: blogId,
        pageNo: next,
        sortType: state.sortType,
      );
      final list = page.list ?? [];
      state = state.copyWith(
        loadingMore: false,
        pageNo: next,
        hasMore: list.length >= 20,
        threads: [
          ...state.threads,
          ...list.map((c) => BlogCommentThread(root: c)),
        ],
      );
    } catch (e) {
      state = state.copyWith(loadingMore: false, error: e.toString());
    }
  }

  Future<void> setSortType(String sortType) async {
    if (state.sortType == sortType) return;
    state = state.copyWith(sortType: sortType);
    await refresh();
  }

  void setReplyTarget(BlogCommentReplyTarget? target) {
    state = state.copyWith(replyTarget: target);
  }

  void replyToRoot(BlogComment root) {
    final id = root.id;
    if (id == null) return;
    setReplyTarget(
      BlogCommentReplyTarget(
        parentId: id,
        rootId: id,
        replyUserId: root.userId,
        hint: '回复 ${root.nickname ?? ''}',
      ),
    );
  }

  void replyToComment(BlogComment root, BlogComment reply) {
    final rootId = root.id;
    final parentId = reply.id;
    if (rootId == null || parentId == null) return;
    setReplyTarget(
      BlogCommentReplyTarget(
        parentId: parentId,
        rootId: rootId,
        replyUserId: reply.userId,
        hint: '回复 ${reply.nickname ?? reply.replyNickname ?? ''}',
      ),
    );
  }

  void cancelReply() => setReplyTarget(null);

  Future<bool> submitComment(String text) async {
    final content = text.trim();
    if (content.isEmpty) return false;
    state = state.copyWith(sending: true, error: null);
    try {
      final target = state.replyTarget;
      await _repo.createComment(
        blogId: blogId,
        content: content,
        parentId: target?.parentId,
        replyUserId: target?.replyUserId,
      );
      cancelReply();
      await refresh();
      state = state.copyWith(sending: false);
      return true;
    } catch (e) {
      state = state.copyWith(sending: false, error: e.toString());
      return false;
    }
  }

  Future<void> expandReplies(int rootCommentId) async {
    final threadIndex = state.threads.indexWhere(
      (thread) => thread.root.id == rootCommentId,
    );
    if (threadIndex < 0) return;

    final thread = state.threads[threadIndex];
    if (thread.loadingReplies || !thread.canExpandMore) return;

    final targetTotal = thread.replyTotal;
    _setThread(
      rootCommentId,
      (current) => current.copyWith(loadingReplies: true),
    );

    try {
      var merged = List<BlogComment>.from(thread.replies);
      var pageNo = 1;
      const pageSize = 200;
      int? serverTotal;

      while (merged.length < targetTotal && pageNo <= 10) {
        final page = await _repo.getRepliesPage(
          rootId: rootCommentId,
          pageNo: pageNo,
          pageSize: pageSize,
        );
        serverTotal ??= page.total;
        final incoming = page.list ?? const <BlogComment>[];
        if (incoming.isEmpty) break;

        final nextMerged = _mergeReplies(merged, incoming);
        if (nextMerged.length == merged.length) {
          if (incoming.length < pageSize) break;
          pageNo++;
          continue;
        }
        merged = nextMerged;
        final total = serverTotal ?? targetTotal;
        if (merged.length >= total || incoming.length < pageSize) break;
        pageNo++;
      }

      merged.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
      final total = serverTotal ?? targetTotal;

      _setThread(rootCommentId, (current) {
        return current.copyWith(
          replies: merged,
          loadingReplies: false,
          repliesPage: pageNo,
          hasMoreReplies: merged.length < total,
        );
      });

      final updatedIndex = state.threads.indexWhere(
        (item) => item.root.id == rootCommentId,
      );
      if (updatedIndex >= 0) {
        final updated = state.threads[updatedIndex];
        if (updated.replies.length < targetTotal &&
            updated.replies.length == thread.replies.length) {
          state = state.copyWith(error: '回复加载失败，请稍后重试');
        }
      }
    } catch (e) {
      _setThread(
        rootCommentId,
        (current) => current.copyWith(loadingReplies: false),
      );
      state = state.copyWith(error: e.toString());
    }
  }

  void _setThread(
    int rootCommentId,
    BlogCommentThread Function(BlogCommentThread current) update,
  ) {
    final index = state.threads.indexWhere(
      (thread) => thread.root.id == rootCommentId,
    );
    if (index < 0) return;
    final threads = [...state.threads];
    threads[index] = update(threads[index]);
    state = state.copyWith(threads: threads);
  }

  List<BlogComment> _mergeReplies(
    List<BlogComment> existing,
    List<BlogComment> incoming,
  ) {
    final ids = existing.map((e) => e.id).whereType<int>().toSet();
    final merged = [...existing];
    for (final c in incoming) {
      final id = c.id;
      if (id == null || !ids.contains(id)) {
        merged.add(c);
        if (id != null) ids.add(id);
      }
    }
    return merged;
  }

  Future<void> deleteComment(int commentId, {int? threadIndex}) async {
    try {
      await _repo.deleteComment(commentId);
      await refresh();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> pinComment(int commentId) async {
    try {
      await _repo.pinComment(commentId);
      await refresh();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> toggleCommentLike(int commentId) async {
    final current = _findComment(commentId);
    if (current == null) return;

    final wasLiked = current.liked == true;
    final prevCount = current.likeCount ?? 0;
    final nextLiked = !wasLiked;
    final nextCount = nextLiked
        ? prevCount + 1
        : (prevCount > 0 ? prevCount - 1 : 0);

    _patchComment(
      commentId,
      (c) => c.copyWith(liked: nextLiked, likeCount: nextCount),
    );

    try {
      final ok = await _repo.toggleCommentLike(
        commentId,
        currentlyLiked: wasLiked,
      );
      if (!ok) {
        _patchComment(
          commentId,
          (c) => c.copyWith(liked: wasLiked, likeCount: prevCount),
        );
      }
    } catch (e) {
      _patchComment(
        commentId,
        (c) => c.copyWith(liked: wasLiked, likeCount: prevCount),
      );
      state = state.copyWith(error: e.toString());
    }
  }

  BlogComment? _findComment(int commentId) {
    for (final t in state.threads) {
      if (t.root.id == commentId) return t.root;
      for (final r in t.replies) {
        if (r.id == commentId) return r;
      }
    }
    return null;
  }

  void _patchComment(int commentId, BlogComment Function(BlogComment) patch) {
    final threads = state.threads.map((t) {
      final root = t.root.id == commentId ? patch(t.root) : t.root;
      final replies = t.replies
          .map((r) => r.id == commentId ? patch(r) : r)
          .toList();
      return t.copyWith(root: root, replies: replies);
    }).toList();
    state = state.copyWith(threads: threads);
  }
}
