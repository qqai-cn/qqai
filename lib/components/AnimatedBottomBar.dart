import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 主 Shell 底部 Tab 内容区高度（对齐 Material [kBottomNavigationBarHeight] / iOS TabBar ~49pt）。
const double kMainShellBottomBarHeight = 66;

class AnimatedBottomBar extends StatefulWidget {
  final List<BarItem> barItems;
  final List<int>? badgeCounts;
  final Duration animationDuration;
  final Function onBarTap;
  final BarStyle barStyle;
  final int selectedBarIndex;

  const AnimatedBottomBar({
    super.key,
    required this.barItems,
    this.badgeCounts,
    this.animationDuration = const Duration(milliseconds: 500),
    required this.onBarTap,
    required this.barStyle,
    this.selectedBarIndex = 0,
  });

  @override
  State<AnimatedBottomBar> createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar>
    with TickerProviderStateMixin {
  late int _selectedBarIndex;

  @override
  void initState() {
    super.initState();
    _selectedBarIndex = widget.selectedBarIndex;
  }

  @override
  void didUpdateWidget(covariant AnimatedBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedBarIndex != widget.selectedBarIndex) {
      _selectedBarIndex = widget.selectedBarIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kMainShellBottomBarHeight,
      child: Padding(
        padding: .only(top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildBarItems(),
        ),
      ),
    );
  }

  List<Widget> _buildBarItems() {
    List<Widget> barItems = [];
    for (int i = 0; i < widget.barItems.length; i++) {
      BarItem item = widget.barItems[i];
      bool isSelected = _selectedBarIndex == i;
      final badgeCount = (widget.badgeCounts != null &&
              i < widget.badgeCounts!.length)
          ? widget.badgeCounts![i]
          : 0;
      barItems.add(
        InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {
              _selectedBarIndex = i;
              widget.onBarTap(_selectedBarIndex);
            });
          },
          child: AnimatedContainer(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            duration: widget.animationDuration,
            decoration: BoxDecoration(
              color: isSelected
                  ? item.color.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(
                      isSelected ? item.selectPath : item.unSelectPath,
                      width: widget.barStyle.iconSize,
                      height: widget.barStyle.iconSize,
                    ),
                    if (badgeCount > 0)
                      Positioned(
                        right: -8,
                        top: -8,
                        child: _Badge(count: badgeCount),
                      ),
                  ],
                ),
                SizedBox(width: 2.0),
                AnimatedSize(
                  duration: widget.animationDuration,
                  curve: Curves.easeInOut,
                  child: AutoSizeText(
                    isSelected ? item.text : "",
                    style: context.typo.body.copyWith(
                      color: item.color,
                      fontWeight: widget.barStyle.fontWeight,
                      fontSize: widget.barStyle.fontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return barItems;
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '99+' : '$count';
    return Container(
      constraints: const BoxConstraints(minWidth: 17, minHeight: 17),
      padding: EdgeInsets.symmetric(horizontal: count > 9 ? 4 : 0),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

class BarStyle {
  final double fontSize, iconSize;
  final FontWeight fontWeight;

  const BarStyle({
    this.fontSize = 13.0,
    this.iconSize = 24.0,
    this.fontWeight = FontWeight.w600,
  });
}

class BarItem {
  String text;
  String selectPath;
  String unSelectPath;
  Color color;

  BarItem({
    required this.text,
    required this.selectPath,
    required this.unSelectPath,
    required this.color,
  });
}
