import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:spring/spring.dart';

import '../../../../../constant/constant.dart';
import '../../../../components/level_icon.dart';
import '../../../../router/app_routes.dart';
import '../../comment/providers/comment_providers.dart';
import 'video_share_view.dart';

class ShortVideoControls extends ConsumerStatefulWidget {
  ShortVideoControls();

  @override
  _ShortVideoControls createState() => _ShortVideoControls();
}

class _ShortVideoControls extends ConsumerState<ShortVideoControls> {
  _ShortVideoControls({Key? key});

  final double iconSize = 30;
  final double fontSize = 14;
  late bool _zan = false;
  bool _care = false;

  String text =
      '在十几二十岁的年纪遇见了你成为了我最喜欢的那个女孩，对我来说就是上天赐予我最好的礼物。我真的很喜欢你这个让我看一眼就会笑的女孩子，只靠爱情是不可能在一起辈子的，白头偕老需要的很多，成为情侣可能只需要爱情，但成为家人需要是我们两个人厮守到老，不仅仅要靠爱情更多的是习惯与责任。想和你走到最后，我会口是心非但我想让你看透我的心，我生气也好冷战也罢，这只能证明我爱你，我会故意气气你会粘着你会和你吵架，但是不会轻易离开你，我会管着你但不想失去你。';

  final SpringController springController = SpringController(
    initialAnim: Motion.mirror,
  );

  @override
  Widget build(BuildContext context) {
    final commentNotifier = ref.read(commentProvider.notifier);
    final commentState = ref.watch(commentProvider);

    bool widScreen = 1.sw > 800;
    var wid = (180.w > 80 ? 80 : 180.w) / 2;
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(left: 10, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          if (showDesc(widScreen, commentState))
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FlickTogglePlayAction(
                      child: FlickSeekVideoAction(child: FlickVideoBuffer()),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.push('${Routes.userDetail}/88/true');
                    },
                    child: Text('@ 3000万粉丝', style: TextStyle(fontSize: 15)),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        constraints: BoxConstraints(maxHeight: 0.5.sh),
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext build) {
                          return Center(child: Text(text));
                        },
                      );
                    },
                    child: RichText(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: TextStyle(color: Colors.white),
                        text:
                            '在十几二十岁的年纪遇见了你成为了我最喜欢的那个女孩，对我来说就是上天赐予我最好的礼物。我真的很喜欢你这个让我看一眼就会笑的女孩子，只靠爱情是喜欢你这个让我看一眼就会笑的女孩子，只靠爱情是喜欢你这个让我看一眼就会笑的女孩子，只靠爱情是不',
                      ),
                    ),
                  ),
                  FlickVideoProgressBar(
                    flickProgressBarSettings: FlickProgressBarSettings(
                      height: 5,
                      handleRadius: 5.5,
                    ),
                  ),
                  FlickAutoHideChild(
                    autoHide: true,
                    showIfVideoNotInitialized: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlickPlayToggle(size: iconSize),
                        SizedBox(width: iconSize / 2),
                        FlickSoundToggle(size: iconSize),
                        SizedBox(width: iconSize / 2),
                        Row(
                          children: <Widget>[
                            FlickCurrentPosition(fontSize: fontSize),
                            FlickAutoHideChild(
                              child: Text(
                                ' / ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontSize,
                                ),
                              ),
                            ),
                            FlickTotalDuration(fontSize: fontSize),
                          ],
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (!showDesc(widScreen, commentState)) Spacer(),
          Container(
            width: 180.w > 100 ? 80 : 180.w,
            child: Column(
              children: [
                Spacer(),
                Container(
                  width: 50,
                  height: 60,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: Padding(
                            child: InkWell(
                              onTap: () {},
                              child: ClipOval(
                                child: Image.asset('imgs/defbak.png'),
                              ),
                            ),
                            padding: EdgeInsets.all(2),
                          ),
                        ),
                      ),
                      if (true)
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: 50,
                            child: Center(
                              child: Container(
                                width: 25,
                                // height: 25,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: InkWell(
                                  child: Icon(Icons.add, color: Colors.white),
                                  onTap: () {},
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  iconSize: wid,
                  onPressed: () {
                    setState(() {
                      _zan = !_zan;
                    });
                  },
                  icon: _zan
                      ? Icon(Icons.favorite, color: Colors.red)
                      : Icon(Icons.favorite_border),
                ),
                Text('10kw'),
                IconButton(
                  iconSize: wid,
                  onPressed: () {
                    commentNotifier.changeShowComment();
                  },
                  color: Colors.white,
                  icon: Icon(Icons.comment),
                ),
                Text('110kw'),
                IconButton(
                  iconSize: wid,
                  onPressed: () {},
                  color: Colors.white,
                  icon: Icon(Icons.star),
                ),
                Text('20kw'),
                VideoShareView(),
                Text('2'),
                Spring.rotate(
                  springController: springController,
                  alignment: Alignment.center,
                  //def=center
                  startAngle: 0,
                  //def=0
                  endAngle: 360,
                  //def=360
                  animDuration: Duration(seconds: 2),
                  //def=1s
                  animStatus: (AnimStatus status) {},
                  curve: Curves.easeInBack,
                  child: IconButton(
                    iconSize: wid,
                    onPressed: () {},
                    color: Colors.white,
                    icon: Icon(Icons.ac_unit),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool showDesc(bool widScreen, var commentState) {
    if (!widScreen && commentState.showComment) {
      return false;
    } else {
      return true;
    }
  }

  Widget getRow(int i) {
    return ListTile(
      hoverColor: Colors.white,
      focusColor: Colors.white,
      leading: Image.asset(
        'imgs/defbak.png',
        width: Constant.HEAD_IMG_SEZE,
        height: Constant.HEAD_IMG_SEZE,
        fit: BoxFit.fill,
      ),
      title: Container(
        padding: EdgeInsets.only(top: 10),
        decoration: UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(child: Text('新飞飞')),
                LevelIcon(lv: 5),
                Spacer(),
                Image.asset('imgs/zan.png', width: 50, height: 30),
                Text('212'),
                PopupMenuButton(
                  tooltip: "",
                  icon: Icon(Icons.more_vert, color: Colors.black54),
                  onSelected: (va) {
                    print(va);
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(value: '0', child: Text('收藏')),
                      PopupMenuItem<String>(value: '1', child: Text('举报')),
                    ];
                  },
                ),
              ],
            ),
            SelectableText(text),
            SizedBox(height: 5),
            Text(
              '2022-12-11 10：12',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
      onTap: () {
        setState(() {});
      },
    );
  }
}
