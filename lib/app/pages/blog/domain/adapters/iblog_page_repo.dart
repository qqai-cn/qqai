import 'package:qqai/app/pages/blog/domain/entity/blog_page_model.dart';

abstract class IBlogPageRepo {
  Future<BlogPageModel> getBlogPageModel(int id);
}
