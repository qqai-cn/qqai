import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/video_player_detail/detail_video_player.dart';
import '../../../components/video_player_detail/myvideo_play.dart';
import '../../blog/data/models/blog_page_model.dart';
import '../../comment/providers/comment_providers.dart';
import '../../comment/views/comment_view.dart';
import '../../video/short_video_player/short_video_share_page.dart';

class BlogVideoDetailView extends ConsumerStatefulWidget {
  final BlogItem blogItem;

  const BlogVideoDetailView({super.key, required this.blogItem});

  @override
  ConsumerState<BlogVideoDetailView> createState() => _BlogVideoDetailView();
}

class _BlogVideoDetailView extends ConsumerState<BlogVideoDetailView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentState = ref.watch(commentProvider);
    final commentNotifier = ref.read(commentProvider.notifier);

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  DetailVideoPlayer(),
                  MyVideo(
                    id: widget.blogItem.id!,
                    url: widget.blogItem.resources!,
                    color: Colors.black,
                    categary: 2,
                  ),
                  Positioned(
                    left: 10,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_circle_left,
                        color: Colors.white.withValues(alpha: 0.5),
                        size: 50,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 80,
                    child: Column(
                      children: [
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
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          onTap: () {},
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        IconButton(
                          iconSize: 50,
                          onPressed: () {},
                          icon: true
                              ? Icon(Icons.favorite, color: Colors.red)
                              : Icon(Icons.favorite_border),
                        ),
                        Text('10kw', style: TextStyle(color: Colors.white)),
                        SizedBox(height: 10,),
                        IconButton(
                          iconSize: 50,
                          onPressed: () {
                            commentNotifier.changeShowComment();
                          },
                          color: Colors.white,
                          icon: Icon(Icons.comment),
                        ),
                        Text('110kw', style: TextStyle(color: Colors.white)),
                        SizedBox(height: 10,),
                        IconButton(
                          iconSize: 50,
                          onPressed: () {},
                          color: Colors.white,
                          icon: Icon(Icons.star),
                        ),
                        Text('20kw', style: TextStyle(color: Colors.white)),
                        SizedBox(height: 10,),
                        ShortVideoSharePage(),
                        Text('2kw', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: commentState.showComment,
            child: SizedBox(
              width: 350,
              height: 1.sh,
              // height: double.infinity,
              child: CommentView(),
            ),
          ),
        ],
      ),
    );
  }
}
