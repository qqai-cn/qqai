import 'package:get/get.dart';

class BlogBinding extends Bindings {
  @override
  void dependencies() {
    //  Get.lazyPut<IBlogPageProvider>(() => BlogPageProvider());
    //  Get.lazyPut<BlogRepo>(() => BlogRepo(provider: Get.find<IBlogPageProvider>()));
    // Get.lazyPut<BlogController>(()=>BlogController(blogPageRepo: Get.find<BlogRepo>()));
  }
}
