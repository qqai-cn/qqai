import 'package:get/get.dart';
import 'package:qqai/app/pages/help/controllers/help_controller.dart';
import 'package:qqai/app/pages/index/controllers/home_controller.dart';

import '../../blog/controllers/blog_controller.dart';
import '../../blog/data/blog_repo.dart';
import '../../blog/data/iblog_page_provider.dart';
import '../../square/controllers/square_controller.dart';
import '../../video/controllers/long_video_controller.dart';
import '../controllers/index_controller.dart';
import '../controllers/me_controller.dart';
import '../controllers/message_controller.dart';
import '../controllers/video_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => IndexController());
    Get.lazyPut(() => VideoController());
    Get.lazyPut(() => MessageController());
    Get.lazyPut(() => MeController());

    Get.lazyPut(() => SquareController());

    Get.lazyPut<IBlogPageProvider>(() => BlogPageProvider());
    Get.lazyPut<BlogRepo>(
        () => BlogRepo(provider: Get.find<IBlogPageProvider>()));
    Get.lazyPut<BlogController>(
        () => BlogController(blogPageRepo: Get.find<BlogRepo>()));

    Get.lazyPut<IBlogPageProvider>(() => BlogPageProvider());
    Get.lazyPut<BlogRepo>(
            () => BlogRepo(provider: Get.find<IBlogPageProvider>()));
    Get.lazyPut<HelpController>(
            () => HelpController(blogPageRepo: Get.find<BlogRepo>()));


    Get.lazyPut(() => LongVideoController());

  }
}
