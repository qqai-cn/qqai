import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:spring/spring.dart';

import '../../../../../../constant/constant.dart';
import '../../../../../router/app_routes.dart';
import '../../features/blog/data/models/blog_page_model.dart';
import '../../features/blog/providers/blog_providers.dart';
import '../../features/blog/views/blog_detail_ui.dart';
import '../../features/comment/providers/comment_providers.dart';
import '../../features/my/providers/my_shop_profile.dart';
import '../../providers/auth_providers.dart';
import '../blog/detail_avatar.dart';
import 'package:qqai/components/level_icon.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/blog/data/blog_list_patch.dart';
import 'package:qqai/features/blog/views/blog_share_button.dart';
import 'video_share_view.dart';

class DetailControls extends ConsumerStatefulWidget {
  final FlickManager? flickManager;
  final BlogItem? blog;

  const DetailControls({super.key, this.flickManager, this.blog});

  @override
  _DetailControls createState() => _DetailControls();
}

class _DetailControls
    extends ConsumerState<DetailControls> {
  _DetailControls({Key? key});

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
    if (widget.blog != null) {
      return _buildBlogControls(context, widget.blog!);
    }
    return _buildLegacyControls(context);
  }

  Widget _buildBlogControls(BuildContext context, BlogItem initial) {
    final item = resolveBlogItem(ref, initial);
    final auth = ref.watch(authProvider);
    final myShop = switch (ref.watch(myShopProfileProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final avatarUrl = blogCreatorAvatarUrl(
      item,
      currentUserId: auth.userId,
      fallbackAvatarUrl: myShop?.coverUrl,
    );
    final notifier = ref.read(blogProvider.notifier);
    final commentNotifier = ref.read(commentProvider.notifier);
    final showFollow = shouldShowBlogFollowButton(item, auth.userId);
    final following = blogFollowCare(item) == 1;
    final liked = blogLikedByMe(item);
    final collected = blogCollectedByMe(item);
    final widScreen = 1.sw > 800;
    final wid = (180.w > 80 ? 80 : 180.w) / 2;
    final name = item.creatorName?.trim();
    final displayName =
        (name != null && name.isNotEmpty) ? name : '用户';
    final metaText = authorFollowerMetaText(item);
    final content = item.content?.trim() ?? '';

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
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
                Row(
                  children: [
                    Text(
                      '@$displayName',
                      style: context.typo.bodyStrong.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    if (blogCreatorLevel(item) > 0) ...[
                      const SizedBox(width: 6),
                      LevelIcon(lv: blogCreatorLevel(item)),
                    ],
                  ],
                ),
                if (metaText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      metaText,
                      style: context.typo.caption.copyWith(color: Colors.white70),
                    ),
                  ),
                if (content.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                        constraints: BoxConstraints(maxHeight: 0.5.sh),
                        context: context,
                        isScrollControlled: true,
                        builder: (ctx) => Padding(
                          padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(child: Text(content)),
                        ),
                      );
                    },
                    child: Text(
                      content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: context.typo.body.copyWith(color: Colors.white),
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
                    children: [
                      FlickPlayToggle(size: iconSize),
                      SizedBox(width: iconSize / 2),
                      FlickSoundToggle(size: iconSize),
                      SizedBox(width: iconSize / 2),
                      Row(
                        children: [
                          FlickCurrentPosition(fontSize: fontSize),
                          FlickAutoHideChild(
                            child: Text(
                              ' / ',
                              style: context.typo.body.copyWith(
                                color: Colors.white,
                                fontSize: fontSize,
                              ),
                            ),
                          ),
                          FlickTotalDuration(fontSize: fontSize),
                        ],
                      ),
                      Expanded(child: Container()),
                      FlickFullScreenToggle(size: iconSize),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 180.w > 100 ? 80 : 180.w,
            child: Column(
              children: [
                FlickAutoHideChild(
                  showIfVideoNotInitialized: false,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: FlickLeftDuration(fontSize: 20),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
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
                            padding: const EdgeInsets.all(2),
                            child: buildDetailAvatar(avatarUrl: avatarUrl),
                          ),
                        ),
                      ),
                      if (showFollow && !following)
                        Positioned(
                          bottom: 0,
                          child: SizedBox(
                            width: 50,
                            child: Center(
                              child: Container(
                                width: 25,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: InkWell(
                                  onTap: () => notifier.onCareTap(item),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
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
                  onPressed: () => notifier.onZanTap(item),
                  icon: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    color: liked ? Colors.red : Colors.white,
                  ),
                ),
                Text(
                  blogDetailCountLabel(item.zan),
                  style: context.typo.caption.copyWith(color: Colors.white),
                ),
                IconButton(
                  iconSize: wid,
                  onPressed: () {
                    if (widScreen) {
                      commentNotifier.changeShowComment();
                    } else {
                      showModalBottomSheet(
                        constraints: BoxConstraints(maxHeight: 0.5.sh),
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => const SizedBox.shrink(),
                      );
                    }
                  },
                  color: Colors.white,
                  icon: const Icon(Icons.comment),
                ),
                Text(
                  blogDetailCountLabel(item.commentCount),
                  style: context.typo.caption.copyWith(color: Colors.white),
                ),
                IconButton(
                  iconSize: wid,
                  onPressed: () => notifier.onCollectTap(item),
                  color: collected ? Colors.amber : Colors.white,
                  icon: Icon(
                    collected ? Icons.star : Icons.star_border,
                  ),
                ),
                Text(
                  blogDetailCountLabel(item.collectCount),
                  style: context.typo.caption.copyWith(color: Colors.white),
                ),
                BlogShareButton(
                  blog: item,
                  onShareChannelTap: () => notifier.onShareTap(item),
                  iconWidth: wid,
                  iconColor: Colors.white,
                ),
                Text(
                  blogDetailCountLabel(item.shareCount),
                  style: context.typo.caption.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegacyControls(BuildContext context) {
    final commentNotifier = ref.read(commentProvider.notifier);
    bool widScreen = 1.sw > 800;
    var wid = (180.w > 80 ? 80 : 180.w) / 2;
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(left: 10, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
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
                  child: Text('@ 3000万粉丝', style: context.typo.bodyStrong.copyWith(color: Colors.white)),
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
                      style: context.typo.body.copyWith(color: Colors.white),
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
                              style: context.typo.body.copyWith(
                                color: Colors.white,
                                fontSize: fontSize,
                              ),
                            ),
                          ),
                          FlickTotalDuration(fontSize: fontSize),
                        ],
                      ),
                      Expanded(child: Container()),
                      FlickFullScreenToggle(size: iconSize),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 180.w > 100 ? 80 : 180.w,
            child: Column(
              children: [
                FlickAutoHideChild(
                  showIfVideoNotInitialized: false,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: FlickLeftDuration(fontSize: 20),
                    ),
                  ),
                ),
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
                    if (widScreen) {
                      commentNotifier.changeShowComment();
                    } else {
                      showModalBottomSheet(
                        constraints: BoxConstraints(maxHeight: 0.5.sh),
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext build) {
                          return ListView(
                            children: [
                              getRow(1),
                              getRow(1),
                              getRow(1),
                              getRow(1),
                            ],
                          );
                        },
                      );
                    }
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
              style: context.typo.body.copyWith(color: Colors.grey, fontSize: 15),
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
