import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyVideoView extends StatefulWidget {
  final int tabIndex;
  final int currentIndex; // 当前选中的 Tab index

  const MyVideoView({required this.tabIndex, required this.currentIndex});

  @override
  State<MyVideoView> createState() => _TabPageState();
}

class _TabPageState extends State<MyVideoView>
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
            (context, index) => Container(
              color: Colors.black12,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      'https://file.qqai.cn/qqai/2025/09/1.webp',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      color: Colors.orange,
                      child: Center(child: Text('置顶')),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Row(
                      spacing: 3,
                      children: [
                        Icon(
                          Icons.play_arrow_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                        Text('300', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            childCount: 30,
          ),
        ),
      ],
    );
  }
}
