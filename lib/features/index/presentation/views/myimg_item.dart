// import 'dart:math';
//
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:qqai/constant/color_constant.dart';
// import 'package:qqai/constant/constant.dart';
//
// import '../../../components/level_icon.dart';
// import '../../../components/myshare_page.dart';
// import '../../../router/app_routes.dart';
// import '../controllers/home_controller.dart';
//
//
// //首页--图片
// class MyImgItem extends StatefulWidget {
//   const MyImgItem({super.key, this.id = 0});
//
//   final int id;
//
//   @override
//   State<StatefulWidget> createState() {
//     return _MyImgItem();
//   }
// }
//
// class _MyImgItem extends State<MyImgItem> {
//   late String name;
//   late Color click;
//   final List<String> _items = [];
//   bool _care = false;
//   bool _zan = false;
//   late int length;
//   String split_o = Constant.SPLIT_O;
//   HomeController myHomeController = Get.put(HomeController());
//
//
//   //网络请求,获取详情
//   @override
//   void initState() {
//     super.initState();
//     name = "新飞飞";
//     length = widget.id;
//     _items.addAll([
//       // '1',
//       // '1',
//       '1',
//       '1',
//     ]);
//     _care = Random.secure().nextBool();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(1),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               InkWell(
//                 onTap: () {},
//                 child: Image.asset(
//                   'imgs/img_default.png',
//                   width: Constant.HEAD_IMG_SEZE,
//                   height: Constant.HEAD_IMG_SEZE,
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Row(
//                     children: <Widget>[
//                       InkWell(
//                         onTap: () {},
//                         child: AutoSizeText(
//                           name,
//                           style: const TextStyle(fontSize: 20),
//                           minFontSize: 10,
//                           maxLines: 1,
//                         ),
//                       ),
//                       LevelIcon(lv: Random().nextInt(7)),
//                     ],
//                   ),
//                   Container(
//                     height: 2,
//                     color: Colors.white,
//                   ),
//                   const Text(
//                     '关注 32 KW ◉️ 活跃 333 KW',
//                     textAlign: TextAlign.left,
//                     style: TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               Padding(
//                 padding: EdgeInsets.only(right: 10),
//                 child: ElevatedButton(
//                   style: _care
//                       ? ElevatedButton.styleFrom(
//                           minimumSize: const Size(20, 35),
//                           padding: EdgeInsets.only(left: 10, right: 10),
//                         )
//                       : ElevatedButton.styleFrom(
//                           minimumSize: const Size(20, 35),
//                           padding: EdgeInsets.only(left: 13, right: 13),
//                           backgroundColor: ColorConstant.ThemeGreen,
//                         ),
//                   child: _care
//                       ? Text(
//                           "已关注",
//                           style: const TextStyle(
//                               fontSize: 13, color: ColorConstant.ThemeGreen),
//                         )
//                       : Text(
//                           "关注",
//                           style: const TextStyle(
//                               fontSize: 13, color: Colors.white),
//                         ),
//                   onPressed: () {
//                     setState(() {
//                       _care = !_care;
//                     });
//                   },
//                 ),
//               )
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 5, right: 5),
//             child: SelectableText(
//               '${myHomeController.skuuBlogPageDataRecords[widget.id].content}',
//               scrollPhysics: NeverScrollableScrollPhysics(),
//               maxLines: 3,
//               minLines: 1,
//               style: TextStyle(
//                 fontSize: 20,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ),
//           if (myHomeController.skuuBlogPageDataRecords[widget.id].resources.split(",").length > 0)
//             Expanded(
//               // flex: 9,
//               child: InkWell(
//                 onTap: () {
//                   Get.toNamed(Routes.whatArticle);
//                 },
//                 child: Container(
//                   child: GridView.builder(
//                       padding: EdgeInsets.only(top: 2.0),
//                       physics: NeverScrollableScrollPhysics(),
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: getCount(myHomeController.skuuBlogPageDataRecords[widget.id].resources.split(",").length),
//                           childAspectRatio: 1,
//                           mainAxisSpacing: 2.0,
//                           crossAxisSpacing: 2.0),
//                       itemCount: myHomeController.skuuBlogPageDataRecords[widget.id].resources.split(",").length,
//                       itemBuilder: (context, index) {
//                         return Image.network(
//                           '${myHomeController.skuuBlogPageDataRecords[widget.id].resources.split(",")[index]}',
//                           fit: BoxFit.fill,
//                         );
//                       }),
//                 ),
//               ),
//             ),
//           Row(
//             children: <Widget>[
//               TextButton.icon(
//                 onPressed: () => {
//                   setState(() {
//                     _zan = !_zan;
//                   })
//                 },
//                 icon: _zan
//                     ? Icon(
//                         Icons.favorite,
//                         color: Colors.red,
//                       )
//                     : Icon(
//                         Icons.favorite_border,
//                       ),
//                 label: Text(
//                   _zan ? '取消' : '喜欢',
//                 ),
//               ),
//               TextButton.icon(
//                 style: ButtonStyle(
//                     backgroundColor:
//                         MaterialStateProperty.all(Colors.transparent)),
//                 onPressed: () => {Get.toNamed(Routes.whatArticle)},
//                 icon: Icon(
//                   Icons.comment,
//                 ),
//                 label: Text(
//                   '评论',
//                 ),
//               ),
//               MySharePage(),
//               Spacer(),
//               PopupMenuButton(
//                 tooltip: "",
//                 icon: Icon(
//                   Icons.more_vert,
//                   color: Colors.black54,
//                 ),
//                 onSelected: (va) {
//                   print(va);
//                 },
//                 itemBuilder: (BuildContext context) {
//                   return <PopupMenuEntry<String>>[
//                     PopupMenuItem<String>(
//                       value: '0',
//                       child: Text(
//                         '收藏',
//                         style: TextStyle(color: Colors.black54),
//                       ),
//                     ),
//                     PopupMenuItem<String>(
//                       value: '1',
//                       child: Text(
//                         '举报',
//                         style: TextStyle(color: Colors.black54),
//                       ),
//                     ),
//                     PopupMenuItem<String>(
//                       value: '2',
//                       child: Text(
//                         '不感兴趣',
//                         style: TextStyle(color: Colors.black54),
//                       ),
//                     ),
//                   ];
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   int getCount(int count) {
//     if (count <= 3) {
//       return count;
//     } else {
//       return 3;
//     }
//   }
// }
