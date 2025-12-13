import 'package:qqai/app/pages/blog/domain/adapters/iblog_page_repo.dart';

import '../domain/entity/blog_page_model.dart';
import 'iblog_page_provider.dart';

class BlogRepo implements IBlogPageRepo {
  BlogRepo({required this.provider});

  final IBlogPageProvider provider;

  @override
  Future<BlogPageModel> getBlogPageModel(int id) async {
    final country = await provider.getBlogPageModel(id);
    if (country.status.hasError) {
      return Future.error(country.statusText!);
    } else {
      return country.body!;
    }
  }
}
