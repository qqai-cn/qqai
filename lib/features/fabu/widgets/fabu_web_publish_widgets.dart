import 'package:flutter/material.dart';
import 'package:qqai/features/fabu/theme/fabu_publish_theme.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/goods/theme/goods_page_style.dart';

/// 发布页分区卡片，对齐抖音创作者中心风格。
class FabuWebSectionCard extends StatelessWidget {
  const FabuWebSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppActionColors.surface(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: GoodsPageStyle.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: GoodsPageStyle.imageBg(context),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
              border: Border(
                bottom: BorderSide(color: GoodsPageStyle.border(context)),
              ),
            ),
            child: Text(
              title,
              style: context.typo.sectionTitle.copyWith(
                color: GoodsPageStyle.text(context),
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// 发布设置行：左侧标签 + 右侧控件。
class FabuWebSettingRow extends StatelessWidget {
  const FabuWebSettingRow({
    super.key,
    required this.label,
    required this.child,
    this.showDivider = true,
  });

  final String label;
  final Widget child;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 88,
                child: Text(
                  label,
                  style: context.typo.body.copyWith(
                    color: GoodsPageStyle.text(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: GoodsPageStyle.border(context)),
      ],
    );
  }
}

/// 横向单选组。
class FabuWebRadioGroup extends StatelessWidget {
  const FabuWebRadioGroup({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 8,
      children: [
        for (var i = 0; i < options.length; i++)
          InkWell(
            onTap: () => onChanged(i),
            borderRadius: BorderRadius.circular(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: Radio<int>(
                    value: i,
                    groupValue: selectedIndex,
                    onChanged: (v) {
                      if (v != null) onChanged(v);
                    },
                    activeColor: FabuPublishTheme.accent,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  options[i],
                  style: context.typo.body.copyWith(
                    color: selectedIndex == i
                        ? GoodsPageStyle.text(context)
                        : AppActionColors.muted(context),
                    fontWeight:
                        selectedIndex == i ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
