import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../components/imgcomment/previewImg.dart';
import '../../../routes/app_pages.dart';
import '../../blog/domain/adapters/iblog_page_repo.dart';
import '../../blog/domain/entity/blog_page_model.dart';

class HelpController extends GetxController{
  final blogPageModel = BlogPageModel().obs;
  final RxnNum total = RxnNum(0);
  final RxList<BlogItem> blogItems = <BlogItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final IBlogPageRepo blogPageRepo;

  HelpController({required this.blogPageRepo});

  late double scrollOffset = 0;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    loadBlogPageModel();
    super.onReady();
  }

  Future<void> loadBlogPageModel() async {
    try {
      isLoading.value = true;
      BlogPageModel res = await blogPageRepo.getBlogPageModel(1);
      blogPageModel.value = res;
      total.value = res.data!.total!;
      blogItems.value = res.data!.list!;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // 跳转到博客详情页
  void onBlogItemTap(BlogItem blogItem) {
    if (blogItem.blogType == 1) {
      Get.toNamed(Routes.whatArticle, arguments: blogItem);
    } else {
      Get.toNamed(Routes.watchVideo, arguments: blogItem);
    }
  }

  // 跳转到图片预览页
  void onBlogImgItemTap(BlogItem blogItem, int index, String heroTag) {
    PreviewImg previewImg = PreviewImg().copyWith(
        id: blogItem.id,
        url: blogItem.resources,
        index: index,
        heroTag: heroTag);
    Get.toNamed(Routes.watchImgUrl, arguments: previewImg);
  }

  //点击头像事件
  void onUserAvatarTap(BlogItem blogItem) {
    Get.toNamed(Routes.whatArticle, arguments: blogItem);
  }

  //关注
  void onCareTap(BlogItem blogItem) {}

  //点赞
  void onZanTap(BlogItem blogItem) {}

  void setScrollOffset(double curScrollOffset) {
    scrollOffset = curScrollOffset;
  }

  double getImgGridHeight(int itemCount) {
    if (itemCount == 1) {
      return 500;
    } else if (itemCount > 1 && itemCount <= 3) {
      return 300;
    } else {
      return 600;
    }
  }

  //动态根据图片个数算item高度
  double getImgItemHeight(int itemCount, double length, int colCount) {
    length = length == 0 ? 100 : length;
    double widthItem = 1.sw;
    if (colCount > 1) {
      widthItem = 0.5.sw;
    }
    length =
        '长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。'.length.toDouble();
    length = length * 22;
    double lineCount = (length / widthItem).ceilToDouble();
    double wordHeight = (lineCount > 3 ? 3 : lineCount) * 30 + 102;
    //没有图片的时候
    if (itemCount == 0) {
      return wordHeight;
    }
    return getImgGridHeight(itemCount) + wordHeight;
    if (itemCount == 1) {
      return 300 + wordHeight;
    }
    //图片超过3个的时候，高度固定
    if (itemCount > 3) {
      return (2 / 3) * widthItem + wordHeight;
    }
    return widthItem / itemCount + wordHeight;
  }

  double getVideoItemHeight(int colCount) {
    double widthItem = 1.sw;
    if (colCount > 1) {
      widthItem = 0.5.sw;
    }
    return widthItem / (15 / 9) + 150;
  }

  @override
  void onClose() {
    super.onClose();
  }
}