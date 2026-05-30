import 'package:flutter/material.dart';

class QqTabItem {
  const QqTabItem({
    required this.label,
    this.icon,
  });

  final String label;
  final IconData? icon;
}

class QqTabBar extends StatelessWidget {
  const QqTabBar({
    super.key,
    this.controller,
    required this.items,
    this.onTap,
    this.isScrollable = false,
    this.tabAlignment,
    this.maxWidth = 720,
    this.alignment = Alignment.center,
    this.shrinkWrap = false,
  });

  final TabController? controller;
  final List<QqTabItem> items;
  final ValueChanged<int>? onTap;
  final bool isScrollable;
  final TabAlignment? tabAlignment;
  final double maxWidth;

  /// 外层对齐；AppBar 标题区左对齐时传 [Alignment.centerLeft]。
  final AlignmentGeometry alignment;

  /// 为 true 时按标签内容收缩宽度，避免窄屏标题区裁切文字。
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final scrollable = shrinkWrap || isScrollable;
    final tabAlign =
        shrinkWrap ? TabAlignment.start : tabAlignment;

    Widget bar = DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EBF0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: TabBar(
          controller: controller,
          onTap: onTap,
          isScrollable: scrollable,
          tabAlignment: tabAlign,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: const Color(0xFF202124),
              unselectedLabelColor: const Color(0xFF6B7280),
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              tabs: items.map(_buildTab).toList(),
            ),
          ),
    );

    if (shrinkWrap) {
      bar = IntrinsicWidth(child: bar);
    } else {
      bar = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: bar,
      );
    }

    return Align(alignment: alignment, child: bar);
  }

  Widget _buildTab(QqTabItem item) {
    final icon = item.icon;
    if (icon == null) {
      return Tab(
        height: 38,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.visible,
            softWrap: false,
          ),
        ),
      );
    }
    return Tab(
      height: 38,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class QqTabBarBottom extends StatelessWidget implements PreferredSizeWidget {
  const QqTabBarBottom({
    super.key,
    this.controller,
    required this.items,
    this.onTap,
    this.isScrollable = false,
    this.tabAlignment,
    this.maxWidth = 720,
    this.padding = const EdgeInsets.fromLTRB(14, 0, 14, 12),
  });

  final TabController? controller;
  final List<QqTabItem> items;
  final ValueChanged<int>? onTap;
  final bool isScrollable;
  final TabAlignment? tabAlignment;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Size get preferredSize => const Size.fromHeight(58);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: QqTabBar(
        controller: controller,
        items: items,
        onTap: onTap,
        isScrollable: isScrollable,
        tabAlignment: tabAlignment,
        maxWidth: maxWidth,
      ),
    );
  }
}

class QqTabSelector extends StatelessWidget {
  const QqTabSelector({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.maxWidth = 720,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFF3F5F8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE8EBF0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                for (var i = 0; i < labels.length; i++)
                  Expanded(
                    child: _QqTabSelectorItem(
                      text: labels[i],
                      selected: selectedIndex == i,
                      onTap: () => onChanged(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QqTabSelectorItem extends StatelessWidget {
  const _QqTabSelectorItem({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: selected ? const Color(0xFF202124) : const Color(0xFF6B7280),
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
