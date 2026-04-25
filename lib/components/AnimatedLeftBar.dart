import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AnimatedBottomBar.dart';
import 'package:qqai/config/theme/app_typography.dart';

class Animatedleftbar extends StatefulWidget {
  final List<BarItem> barItems;
  final Duration animationDuration;
  final Function onBarTap;
  final BarStyle barStyle;
  late int selectedBarIndex;
  late bool isExtended;

  Animatedleftbar({
    required this.barItems,
    this.animationDuration = const Duration(milliseconds: 500),
    required this.onBarTap,
    required this.barStyle,
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
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _buildBarItems(),
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
            // alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(
              bottom: 15,
              top: 10,
              left: 10,
              right: 10,
            ),
            duration: widget.animationDuration,
            decoration: BoxDecoration(
              color: isSelected
                  ? item.color.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  isSelected ? item.selectPath : item.unSelectPath,
                  width: 40,
                  height: 40,
                ),
                SizedBox(width: 2.0),
                Visibility(
                  child: AnimatedSize(
                    duration: widget.animationDuration,
                    curve: Curves.easeInOut,
                    child: AutoSizeText(
                      item.text,
                      style: context.typo.body.copyWith(
                        color: item.color,
                        fontWeight: widget.barStyle.fontWeight,
                        fontSize: widget.barStyle.fontSize,
                      ),
                    ),
                  ),
                  visible: widget.isExtended,
                ),
              ],
            ),
          ),
        ),
      );
    }
    _barItems.add(
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                _launchURL(Uri(scheme: 'https', host: 'beian.miit.gov.cn'));
              },
              child: Text(
                '京ICP备2022023998号-2',
                style: context.typo.body.copyWith(color: Colors.grey, fontSize: 8),
              ),
            ),
          ],
        ),
      ),
    );
    return _barItems;
  }

  Future<void> _launchURL(url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
