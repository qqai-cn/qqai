import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/app_typography.dart';

class MyGoodsView extends StatefulWidget {
  final int tabIndex;
  final int currentIndex; // 当前选中的 Tab index

  const MyGoodsView({required this.tabIndex, required this.currentIndex});

  @override
  State<MyGoodsView> createState() => _TabPageState();
}

class _TabPageState extends State<MyGoodsView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.tabIndex != widget.currentIndex) {
      return SizedBox.shrink();
    }
    final isWideScreen = 1.sw > 800;

    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWideScreen ? 4 : 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 2 / 3,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => waterCard(1),
            childCount: 30,
          ),
        ),
      ],
    );
  }

  Widget waterCard(double item) {
    var randomNum = new Random();
    var one = randomNum.nextBool();
    final titleStyle = context.typo.cardTitle.copyWith(
      fontWeight: FontWeight.normal,
    );
    final labelStyle = context.typo.label;
    final captionStyle = context.typo.caption;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            // height: item * 2 / 3,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    'https://file.qqai.cn/qqai/2025/09/1.webp',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Row(
                    spacing: 3,
                    children: [
                      Icon(
                        Icons.add_shopping_cart_sharp,
                        size: 20,
                        color: Colors.white,
                      ),
                      Text(
                        '300',
                        style: context.typo.label.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.w, top: 5),
            child: Text(
              '蓝月亮洗衣液',
              style: titleStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.w, top: 5),
            child: RichText(
              text: TextSpan(
                text: '¥',
              style: context.typo.cardSubtitle.copyWith(
                fontSize: 15,
                color: Colors.red,
              ),
                children: [
                  TextSpan(
                    text: '18.88',
                    style: context.typo.bodyStrong.copyWith(
                    fontSize: titleStyle.fontSize,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: ' 到手价 ',
                        style: context.typo.cardSubtitle.copyWith(
                          fontSize: 15,
                          color: Colors.red,
                        ),
                        children: [
                          TextSpan(
                            text: '¥38.8',
                            style: captionStyle.copyWith(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          one
              ? Padding(
                  padding: EdgeInsets.only(left: 10.w, top: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      '跨店每满300减40',
                      style: labelStyle.copyWith(color: Colors.red),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(left: 10.w, top: 5),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFFBC02D),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          '包邮',
                          style: context.typo.cardSubtitle.copyWith(
                            fontSize: 15,
                            color: const Color(0xFFFBC02D),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFFBC02D),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          '30天保价',
                          style: context.typo.cardSubtitle.copyWith(
                            fontSize: 15,
                            color: const Color(0xFFFBC02D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
