import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blog/data/models/blog_page_model.dart';
import '../../comment/providers/comment_providers.dart';
import '../../comment/views/comment_view.dart';
import '../../video/views/video_share_view.dart';

class BlogImgDetailView extends ConsumerStatefulWidget {
  final BlogItem? blogItem;

  const BlogImgDetailView({super.key, this.blogItem});

  @override
  ConsumerState<BlogImgDetailView> createState() => _BlogImgDetailView();
}

class _BlogImgDetailView extends ConsumerState<BlogImgDetailView> {
  final TextEditingController _controller = TextEditingController();
  final CarouselSliderController carouselSliderController =
      CarouselSliderController();
  int _current = 0;

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

    final imageUrls =
        widget.blogItem!.resources
            ?.split(',')
            .map((url) => url.trim())
            .where((url) => url.isNotEmpty)
            .toList() ??
        [];
    List<Widget> imageWidgets = getImageWidgets(imageUrls);
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  CarouselSlider(
                    items: imageWidgets,
                    options: CarouselOptions(
                      height: 1.sh,
                      viewportFraction: 1.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        setState(() => _current = index);
                      },
                    ),
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
                    bottom: 50,
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
                        VideoShareView(),
                        Text('2kw', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imageUrls.asMap().entries.map((entry) {
                        final index = entry.key;
                        final url = entry.value;
                        return GestureDetector(
                          onTap: () =>
                              carouselSliderController.animateToPage(index),
                          child: Container(
                            width: 12.0,
                            height: 12.0,
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 4.0,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == index
                                  ? Colors.white
                                  : Colors.black45,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: commentState.showComment,
            child: SizedBox(width: 350, height: 1.sh, child: CommentView()),
          ),
        ],
      ),
    );
  }

  List<Widget> getImageWidgets(List<String> imageUrls) {
    return imageUrls.map((url) {
      return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.error, color: Colors.red),
                ),
              );
            },
          ),
        ),
      );
    }).toList();
  }
}
