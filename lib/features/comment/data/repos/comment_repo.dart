import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/comment_model.dart';

// Repo Provider（按 blog 的格式：Provider 放在 repo 文件里）
final commentRepoProvider = Provider<ICommentRepo>(
  (ref) => CommentRepo(),
);

abstract class ICommentRepo {
  Future<List<CommentModel>> getAllComments();
  Future<CommentModel?> getCommentById(String id);
  Future<void> addComment(CommentModel item);
  Future<void> updateComment(CommentModel item);
  Future<void> deleteComment(String id);
}

class CommentRepo implements ICommentRepo {
  final List<CommentModel> _items = [];

  @override
  Future<List<CommentModel>> getAllComments() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_items);
  }

  @override
  Future<CommentModel?> getCommentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addComment(CommentModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.add(item);
  }

  @override
  Future<void> updateComment(CommentModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((existing) => existing.id == item.id);
    if (index != -1) _items[index] = item;
  }

  @override
  Future<void> deleteComment(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((item) => item.id == id);
  }
}
