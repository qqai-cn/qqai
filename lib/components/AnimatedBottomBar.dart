import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 主 Shell 底部 Tab 内容区高度（对齐 Material [kBottomNavigationBarHeight] / iOS TabBar ~49pt）。
const double kMainShellBottomBarHeight = 56;

class AnimatedBottomBar extends StatefulWidget {
  final List<BarItem> barItems;
  final Duration animationDuration;
  final Function onBarTap;
  final BarStyle barStyle;
  late  int selectedBarIndex;

  AnimatedBottomBar({
    required this.barItems,
    this.animationDuration = const Duration(milliseconds: 500),
    required this.onBarTap,
    required this.barStyle,
    this.selectedBarIndex = 0,
  });

  @override
  _AnimatedBottomBarState createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar>
    with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kMainShellBottomBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _buildBarItems(),
      ),
    );
  }

  List<Widget> _buildBarItems() {
    List<Widget> _barItems = [];
    for (int i = 0; i < widget.barItems.length; i++) {
      BarItem item = widget.barItems[i];
      bool isSelected = widget.selectedBarIndex == i;
      _barItems.add(
        InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {
              widget.selectedBarIndex = i;
              widget.onBarTap(widget.selectedBarIndex);
            });
          },
          child: AnimatedContainer(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            duration: widget.animationDuration,
            decoration: BoxDecoration(
              color: isSelected
                  ? item.color.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SvgPicture.asset(
                  isSelected ? item.selectPath : item.unSelectPath,
                  width: widget.barStyle.iconSize,
                  height: widget.barStyle.iconSize,
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
    return _barItems;
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
