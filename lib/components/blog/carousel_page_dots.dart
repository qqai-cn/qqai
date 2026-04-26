import 'package:flutter/material.dart';

/// 轮播底部圆点指示器（带 [Positioned] 包裹）。
class CarouselPageDots extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final ValueChanged<int> onDotTap;

  const CarouselPageDots({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    required this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount <= 0) return const SizedBox.shrink();
    return Positioned(
      left: 0,
      right: 0,
      bottom: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(itemCount, (index) {
          return GestureDetector(
            onTap: () => onDotTap(index),
            child: Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == index ? Colors.white : Colors.black45,
              ),
            ),
          );
        }),
      ),
    );
  }
}
