import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/features/blog/views/components/blog_detail_scaffold.dart';

import '../../blog/data/models/blog_page_model.dart';
import '../../comment/providers/comment_providers.dart';
import '../../video/views/video_share_view.dart';
import 'package:qqai/config/theme/app_typography.dart';

class BlogImgDetailView extends ConsumerStatefulWidget {
  final BlogItem? blogItem;

  const BlogImgDetailView({super.key, this.blogItem});

  @override
  ConsumerState<BlogImgDetailView> createState() => _BlogImgDetailView();
}

class _BlogImgDetailView extends ConsumerState<BlogImgDetailView> {
  final CarouselSliderController carouselSliderController =
      CarouselSliderController();
  int _current = 0;

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
    return BlogDetailScaffold(
      showCommentPanel: commentState.showComment,
      content: Stack(
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
            right: 10,
            bottom: 50,
            child: Column(
              children: [
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
                            child: InkWell(
                              onTap: () {},
                              child: ClipOval(
                                child: Image.asset('imgs/defbak.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
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
                                onTap: () {},
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
                const SizedBox(height: 10),
                IconButton(
                  iconSize: 50,
                  onPressed: () {},
                  icon: const Icon(Icons.favorite, color: Colors.red),
                ),
                Text(
                  '10kw',
                  style: context.typo.caption.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 10),
                IconButton(
                  iconSize: 50,
                  onPressed: () {
                    commentNotifier.changeShowComment();
                  },
                  color: Colors.white,
                  icon: const Icon(Icons.comment),
                ),
                Text(
                  '110kw',
                  style: context.typo.caption.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 10),
                IconButton(
                  iconSize: 50,
                  onPressed: () {},
                  color: Colors.white,
                  icon: const Icon(Icons.star),
                ),
                Text(
                  '20kw',
                  style: context.typo.caption.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 10),
                VideoShareView(),
                Text(
                  '2kw',
                  style: context.typo.caption.copyWith(color: Colors.white),
                ),
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
                return GestureDetector(
                  onTap: () => carouselSliderController.animateToPage(index),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index ? Colors.white : Colors.black45,
                    ),
                  ),
                );
              }).toList(),
            ),
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
