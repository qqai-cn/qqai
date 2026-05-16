import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../data/repos/comment_repo.dart';
import '../data/models/comment_model.dart';

part 'comment_providers.freezed.dart';

part 'comment_providers.g.dart';

@freezed
sealed class CommentState with _$CommentState {
  const factory CommentState({
    // freezed 的 @Default 必须是 const
    @Default(const AsyncLoading()) AsyncValue<List<CommentModel>> items,
    @Default(false) bool showComment,
    String? error,
  }) = _CommentState;
}

@riverpod
class CommentNotifier extends _$CommentNotifier {
  late final ICommentRepo _repo;
  final List<String> tabValues = ['评论', '相关推荐'];

  @override
  CommentState build() {
    _repo = ref.read(commentRepoProvider);
    return const CommentState();
  }

  Future<void> load() async {
    state = state.copyWith(items: const AsyncLoading(), error: null);
    try {
      final items = await _repo.getAllComments();
      state = state.copyWith(items: AsyncData(items));
    } catch (e, st) {
      state = state.copyWith(items: AsyncError(e, st), error: e.toString());
    }
  }

  Future<void> add(String title) async {
    if (title.trim().isEmpty) return;
    final newItem = CommentModel(
      id: const Uuid().v4(),
      title: title,
      isDone: false,
    );
    try {
      await _repo.addComment(newItem);
      await load();
    } catch (e) {
      state = state.copyWith(error: '添加失败: $e');
    }
  }

  Future<void> toggle(String id) async {
    final item = await _repo.getCommentById(id);
    if (item == null) return;
    final updated = item.copyWith(isDone: !item.isDone);
    try {
      await _repo.updateComment(updated);
      await load();
    } catch (e) {
      state = state.copyWith(error: '更新失败: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.deleteComment(id);
      await load();
    } catch (e) {
      state = state.copyWith(error: '删除失败: $e');
    }
  }

  void changeShowComment() {
    state = state.copyWith(showComment: !state.showComment);
  }

  void openCommentPanel() {
    if (!state.showComment) {
      state = state.copyWith(showComment: true);
    }
  }

  void dontShowComment() {
    state = state.copyWith(showComment: false);
  }
}
