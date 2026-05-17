import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../blog/data/models/blog_page_model.dart';
import '../../blog/data/repos/blog_repo.dart';
import '../data/models/my_model.dart';
import '../data/repos/my_repo.dart';

part 'my_providers.freezed.dart';

part 'my_providers.g.dart';

@freezed
sealed class MyState with _$MyState {
  const factory MyState({
    // freezed 的 @Default 必须是 const
    @Default(AsyncLoading()) AsyncValue<BlogPageModelData> blogPageData,
    String? error,
  }) = _MyState;
}

@riverpod
class MyNotifier extends _$MyNotifier {
  late final IMyRepo _repo;
  late final IBlogRepo blogRepo;

  @override
  MyState build() {
    _repo = ref.read(myRepoProvider);
    blogRepo = ref.read(blogRepoProvider);
    Future.microtask(() {
      if (ref.mounted) loadBlog();
    });
    return const MyState();
  }

  Future<void> add(String title) async {
    if (title.trim().isEmpty) return;
    final newItem = MyModel(id: const Uuid().v4(), title: title, isDone: false);
    try {
      await _repo.addMy(newItem);
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(error: '添加失败: $e');
    }
  }

  Future<void> toggle(String id) async {
    final item = await _repo.getMyById(id);
    if (item == null) return;
    final updated = item.copyWith(isDone: !item.isDone);
    try {
      await _repo.updateMy(updated);
      // await load();
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(error: '更新失败: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.deleteMy(id);
      // await load();
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(error: '删除失败: $e');
    }
  }

  Future<void> loadBlog() async {
    state = state.copyWith(blogPageData: const AsyncLoading(), error: null);
    try {
      final items = await blogRepo.getBlogPageModelData();
      if (!ref.mounted) return;
      state = state.copyWith(blogPageData: AsyncData(items));
    } catch (e, st) {
      if (!ref.mounted) return;
      state = state.copyWith(
        blogPageData: AsyncError(e, st),
        error: e.toString(),
      );
    }
  }
}
