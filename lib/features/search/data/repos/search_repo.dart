import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../blog/data/models/blog_page_model.dart';
import '../../../blog/data/repos/blog_repo.dart';
import '../../../goods/data/models/mall_product_model.dart';
import '../../../goods/data/repos/goods_repo.dart';

/// Repo Provider（按 blog 的格式：Provider 放在 repo 文件里）
final searchRepoProvider = Provider<ISearchRepo>(
  (ref) => SearchRepo(
    blogRepo: ref.watch(blogRepoProvider),
    goodsRepo: ref.watch(goodsRepoProvider),
  ),
);

abstract class ISearchRepo {
  Future<BlogPageModelData> searchBlogs(
    int page, {
    required String keyword,
    required int blogType,
    int pageSize = 20,
  });

  Future<MallProductPageData> searchGoods(
    int page, {
    required String keyword,
    int pageSize = 20,
  });
}

class SearchRepo implements ISearchRepo {
  SearchRepo({
    required IBlogRepo blogRepo,
    required IGoodsRepo goodsRepo,
  })  : _blogRepo = blogRepo,
        _goodsRepo = goodsRepo;

  final IBlogRepo _blogRepo;
  final IGoodsRepo _goodsRepo;

  @override
  Future<BlogPageModelData> searchBlogs(
    int page, {
    required String keyword,
    required int blogType,
    int pageSize = 20,
  }) {
    return _blogRepo.getBlogPageModelDataWithPage(
      page,
      pageSize: pageSize,
      keyword: keyword,
      blogType: blogType,
    );
  }

  @override
  Future<MallProductPageData> searchGoods(
    int page, {
    required String keyword,
    int pageSize = 20,
  }) {
    return _goodsRepo.getMallProductsPage(
      page,
      pageSize: pageSize,
      keyword: keyword,
    );
  }
}
