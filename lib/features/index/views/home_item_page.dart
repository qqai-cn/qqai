// import 'dart:math';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:qqai/features/index/controllers/home_controller.dart';
//
// import '../../../../config/translations/strings_enum.dart';
// import '../../../components/api_error_widget.dart';
// import '../../../components/my_widgets_animator.dart';
// import 'myimg_item.dart';
// import 'myindex_video_item.dart';
//
// //首页
// class HomeItemPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _HomeItemPage();
//   }
// }
//
// class _HomeItemPage extends State<HomeItemPage> {
//   final List<String> _items = [];
//   int colCount = 2;
//   bool ifHelpOrShare = false;
//   late double scrollOffset = 0;
//   HomeController myHomeController = Get.put(HomeController());
//   ScrollController scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _items.addAll([
//       '1',
//       '1',
//       '1',
//       '1',
//       '1',
//       '1',
//       '1',
//       '1',
//       '1',
//       '1',
//     ]);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     scrollController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
// //    double width = MediaQuery.of(context).size.width;
// //    int count = getColCount(width);
//
//     setState(() {
//       colCount = getColCount(MediaQuery.of(context).size.width);
//     });
//     return GetBuilder<HomeController>(builder: (_) {
//       return Scaffold(
//         backgroundColor: Colors.black12,
//         body: Padding(
//             padding: EdgeInsets.only(left: 5, right: 5),
//             // ignore: missing_required_param
//             child: NotificationListener<ScrollNotification>(
//               onNotification: (ScrollNotification notification) {
//                 switch (notification.runtimeType) {
//                   // case ScrollStartNotification:
//                   //   if (scrollController.offset == 0) {
//                   //     myHomeController.changeShowSearch(true);
//                   //   }
//                   //   break;
//                   // case ScrollUpdateNotification:
//                   //   print("正在滚动"+scrollController.offset.toString());
//                   //   break;
//                   case ScrollEndNotification:
//                     double curOffset = scrollController.offset;
//                     myHomeController.changeShowSearch(curOffset < scrollOffset);
//                     scrollOffset = curOffset;
//                     break;
//                   // case OverscrollNotification:
//                   //   print("滚动到边界"+scrollController.offset.toString());
//                   //   break;
//                 }
//                 return false;
//               },
//               child: MyWidgetsAnimator(
//                 apiCallStatus: myHomeController.apiCallStatus,
//                 loadingWidget: () => const Center(
//                   child: CupertinoActivityIndicator(),
//                 ),
//                 errorWidget: () => ApiErrorWidget(
//                   message: Strings.internetError.tr,
//                   retryAction: () => myHomeController.getDataFromApi(),
//                   padding: EdgeInsets.symmetric(horizontal: 20.w),
//                 ),
//                 successWidget: () => MasonryGridView.count(
//                   itemCount: myHomeController.skuuBlogPageDataRecords.length,
//                   crossAxisCount: colCount,
//                   controller: scrollController,
//                   mainAxisSpacing: 4.0,
//                   crossAxisSpacing: 4.0,
//                   itemBuilder: (BuildContext context, int index) {
//                     if (myHomeController
//                             .skuuBlogPageDataRecords[index].blogType ==
//                         1) {
//                       return Material(
//                         child: Container(
//                           height: getImgItemHeight(
//                               myHomeController.skuuBlogPageDataRecords[index]
//                                           .resources
//                                           .split(",")
//                                           .length >
//                                       6
//                                   ? 6
//                                   : myHomeController
//                                       .skuuBlogPageDataRecords[index].resources
//                                       .split(",")
//                                       .length,
//                               index * 100),
//                           child: MyImgItem(
//                             id: index,
//                           ),
//                         ),
//                         borderRadius: BorderRadius.circular(10.0),
//                       );
//                     } else {
//                       return Material(
//                         borderRadius: BorderRadius.circular(10.0),
//                         child: Container(
//                           height: getVideoItemHeight(),
//                           child: MyIndexVideoItem(id: index),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               ),
//             )),
//       );
//     });
//   }
//
//   int getColCount(double len) {
//     // print(len);
//     if (len < 1000) {
//       return 1;
//       // } else if (len >= 1000 && len < 1450) {
//       //   // } else if (len >= 1000 && len < 1430) {
//       //   return 2;
//       //   // } else if (len >= 1430 && len < 2300) {
//       // } else if (len >= 1450 && len < 2000) {
//       //   return 3;
//       // } else {
//     } else {
//       return 2;
//     }
//   }
//
//   //动态根据图片个数算item高度
//   double getImgItemHeight(int itemCount, double length) {
//     length = length == 0 ? 100 : length;
//     double widthItem = 1.sw;
//     if (colCount > 1) {
//       widthItem = 0.5.sw;
//     }
//     length =
//         '长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。长风破浪会有时，直挂云帆济沧海。'.length.toDouble();
//     length = length * 22;
//     double lineCount = (length / widthItem).ceilToDouble();
//     double wordHeight = (lineCount > 3 ? 3 : lineCount) * 30 + 102;
//     //没有图片的时候
//     if (itemCount == 0) {
//       return wordHeight;
//     }
//     //图片超过3个的时候，高度固定
//     if (itemCount > 3) {
//       return (2 / 3) * widthItem + wordHeight;
//     }
//     return widthItem / itemCount + wordHeight;
//   }
//
//   double getVideoItemHeight() {
//     double widthItem = 1.sw;
//     if (colCount > 1) {
//       widthItem = 0.5.sw;
//     }
//     return widthItem / (15 / 9) + 150;
//   }
//
//   int getImgItemCount() {
//     return Random().nextInt(3) + 1;
//   }
// }
