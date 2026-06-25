import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/my_fonts.dart';
import 'package:qqai/config/theme/app_typography.dart';

class FriendVideoView extends StatefulWidget {
  final int tabIndex;
  final int currentIndex; // 当前选中的 Tab index

  const FriendVideoView({required this.tabIndex, required this.currentIndex});

  @override
  State<FriendVideoView> createState() => _TabPageState();
}

class _TabPageState extends State<FriendVideoView>
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
              color: AppActionColors.borderSubtle(context),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      'https://file.aabe.cn/qqai/2025/09/1.webp',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      color: Colors.orange,
                      child: Center(
                        child: Text(
                          '置顶',
                          style: context.typo.label.copyWith(fontSize: 15, color: Colors.white),
                        ),
                      ),
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
                        Text(
                          '300',
                          style: context.typo.label.copyWith(color: Colors.white, fontSize: 15),
                        ),
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
