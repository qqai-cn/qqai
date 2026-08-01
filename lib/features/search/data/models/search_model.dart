import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../blog/data/models/blog_page_model.dart';
import '../../../goods/data/models/mall_product_model.dart';

part 'search_model.freezed.dart';

/// 搜索结果分类：博客（图文）、视频、商品。
enum SearchCategory { blog, video, goods }

extension SearchCategoryX on SearchCategory {
  String get label => switch (this) {
        SearchCategory.blog => '博客',
        SearchCategory.video => '视频',
        SearchCategory.goods => '商品',
      };

  /// 博客接口 `blogType`：图文=1，视频=2；商品无此字段。
  int? get blogTypeFilter => switch (this) {
        SearchCategory.blog => 1,
        SearchCategory.video => 2,
        SearchCategory.goods => null,
      };
}

/// 博客 / 视频分页结果桶。
@freezed
sealed class SearchBlogBucket with _$SearchBlogBucket {
  const SearchBlogBucket._();

  const factory SearchBlogBucket({
    @Default([]) List<BlogItem> items,
    @Default(1) int pageNo,
    @Default(0) int total,
    @Default(false) bool loading,
    @Default(false) bool loadingMore,
    String? error,
  }) = _SearchBlogBucket;

  bool get hasMore => items.length < total;
}

/// 商品分页结果桶。
@freezed
sealed class SearchGoodsBucket with _$SearchGoodsBucket {
  const SearchGoodsBucket._();

  const factory SearchGoodsBucket({
    @Default([]) List<MallProduct> items,
    @Default(1) int pageNo,
    @Default(0) int total,
    @Default(false) bool loading,
    @Default(false) bool loadingMore,
    String? error,
  }) = _SearchGoodsBucket;

  bool get hasMore => items.length < total;
}
