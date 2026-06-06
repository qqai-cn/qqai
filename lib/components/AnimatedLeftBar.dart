import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AnimatedBottomBar.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/config/theme/dark_theme_colors.dart';
import 'package:qqai/config/theme/shell_nav_colors.dart';

class Animatedleftbar extends StatefulWidget {
  final List<BarItem> barItems;
  final Duration animationDuration;
  final Function onBarTap;
  final BarStyle barStyle;
  final Widget? footerAboveBeian;
  late int selectedBarIndex;
  late bool isExtended;

  Animatedleftbar({
    required this.barItems,
    this.animationDuration = const Duration(milliseconds: 500),
    required this.onBarTap,
    required this.barStyle,
    this.footerAboveBeian,
    this.selectedBarIndex = 0,
    this.isExtended = false,
  });

  @override
  _Animatedleftbar createState() => _Animatedleftbar();
}

class _Animatedleftbar extends State<Animatedleftbar>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildBarItems(context),
    );
  }

  List<Widget> _buildBarItems(BuildContext context) {
    List<Widget> barItems = [];
    for (int i = 0; i < widget.barItems.length; i++) {
      BarItem item = widget.barItems[i];
      bool isSelected = widget.selectedBarIndex == i;
      barItems.add(
        InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {
              widget.selectedBarIndex = i;
              widget.onBarTap(widget.selectedBarIndex);
            });
          },
          child: AnimatedContainer(
            padding: const EdgeInsets.only(
              bottom: 15,
              top: 10,
              left: 10,
              right: 10,
            ),
            duration: widget.animationDuration,
            decoration: BoxDecoration(
              color: isSelected
                  ? ShellNavColors.selectedBackground(
                      context,
                      lightAccent: item.color,
                    )
                  : Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  ShellNavColors.iconPath(
                    context,
                    isSelected: isSelected,
                    selectPath: item.selectPath,
                    unSelectPath: item.unSelectPath,
                  ),
                  width: 40,
                  height: 40,
                  colorFilter: ShellNavColors.iconColorFilter(
                    context,
                    isSelected: isSelected,
                  ),
                ),
                const SizedBox(width: 2.0),
                Visibility(
                  visible: widget.isExtended,
                  child: AnimatedSize(
                    duration: widget.animationDuration,
                    curve: Curves.easeInOut,
                    child: AutoSizeText(
                      item.text,
                      style: context.typo.body.copyWith(
                        color: ShellNavColors.label(
                          context,
                          isSelected: isSelected,
                          lightAccent: item.color,
                        ),
                        fontWeight: widget.barStyle.fontWeight,
                        fontSize: widget.barStyle.fontSize,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    barItems.add(
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.footerAboveBeian != null) widget.footerAboveBeian!,
            TextButton(
              onPressed: () {
                _launchURL(Uri(scheme: 'https', host: 'beian.miit.gov.cn'));
              },
              child: Text(
                '京ICP备2022023998号-2',
                style: context.typo.body.copyWith(
                  color: ShellNavColors.isDark(context)
                      ? DarkThemeColors.bottomBarForegroundMuted
                      : Colors.grey,
                  fontSize: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return barItems;
  }

  Future<void> _launchURL(url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
