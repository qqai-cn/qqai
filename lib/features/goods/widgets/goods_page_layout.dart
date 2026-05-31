import 'package:flutter/material.dart';

import '../theme/goods_page_style.dart';

/// 主内容顶部留白（与详情相册区一致，返回按钮悬浮在其上）。
double goodsPageTopContentInset(BuildContext context) {
  return MediaQuery.paddingOf(context).top + 6;
}

/// 顶栏悬浮区高度（状态栏 + 返回行），用于需避开顶栏的正文起始位置。
double goodsPageTopBarExtent(BuildContext context) {
  return MediaQuery.paddingOf(context).top + 48;
}

/// 详情 / 评价页主卡片水平外边距。
const double goodsPageMainHorizontalPadding = 8;

/// 主内容顶部灰底留白（与详情相册、评价标题区一致）。
class GoodsPageTopInset extends StatelessWidget {
  const GoodsPageTopInset({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: goodsPageTopContentInset(context));
  }
}

/// 居中单列内的白卡片：水平 [goodsPageMainHorizontalPadding] + 圆角白底。
class GoodsPageMainCard extends StatelessWidget {
  const GoodsPageMainCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.color = Colors.white,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius borderRadius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: goodsPageMainHorizontalPadding,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}

/// 顶部留白 + 白卡片（评价页标题区、详情相册等）。
class GoodsPageTopSection extends StatelessWidget {
  const GoodsPageTopSection({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(14, 12, 14, 12),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.sectionColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Color? sectionColor;

  @override
  Widget build(BuildContext context) {
    final section = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const GoodsPageTopInset(),
        GoodsPageMainCard(
          padding: padding,
          borderRadius: borderRadius,
          child: child,
        ),
      ],
    );
    if (sectionColor == null) return section;
    return ColoredBox(color: sectionColor!, child: section);
  }
}

/// 商品子页主列：可选顶区白卡片 + 下方正文（正文通常为 [Expanded]）。
class GoodsPageMainColumn extends StatelessWidget {
  const GoodsPageMainColumn({
    super.key,
    this.header,
    required this.body,
    this.headerPadding = const EdgeInsets.fromLTRB(14, 12, 14, 12),
    this.topInsetOnly = false,
  });

  final Widget? header;
  final Widget body;
  final EdgeInsetsGeometry headerPadding;
  /// 无 [header] 时仅展示顶部留白（loading / error）。
  final bool topInsetOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (header != null)
          GoodsPageTopSection(
            padding: headerPadding,
            child: header!,
          )
        else if (topInsetOnly)
          const GoodsPageTopInset(),
        body,
      ],
    );
  }
}

/// 商品详情 / 评价等页：宽屏与窄屏均为居中单列（maxWidth 880）。
class GoodsPageScaffold extends StatelessWidget {
  const GoodsPageScaffold({
    super.key,
    required this.main,
    this.bottomBar,
    this.topBar,
    this.backgroundColor = const Color(0xFFF4F4F4),
    this.mainPadding,
  });

  final Widget main;
  final Widget? bottomBar;
  final Widget? topBar;
  final Color backgroundColor;
  final EdgeInsets? mainPadding;

  @override
  Widget build(BuildContext context) {
    Widget content = main;
    if (mainPadding != null) {
      content = Padding(padding: mainPadding!, child: content);
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: GoodsPageStyle.pageMaxWidth,
              ),
              child: content,
            ),
          ),
          if (topBar != null)
            Positioned(
              top: MediaQuery.paddingOf(context).top + 8,
              left: 0,
              right: 0,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: GoodsPageStyle.pageMaxWidth,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: topBar!,
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}

/// 与商品详情一致的返回按钮。
class GoodsBackButton extends StatelessWidget {
  const GoodsBackButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 22,
        color: GoodsPageStyle.text,
      ),
      style: IconButton.styleFrom(
        foregroundColor: GoodsPageStyle.text,
        padding: EdgeInsets.zero,
        minimumSize: const Size(40, 40),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

/// 详情顶栏圆角图标按钮。
class GoodsTopRoundButton extends StatelessWidget {
  const GoodsTopRoundButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.96),
      borderRadius: BorderRadius.circular(15),
      elevation: 2,
      shadowColor: const Color(0x16000000),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: SizedBox(
          width: 38,
          height: 32,
          child: Icon(icon, size: 19, color: GoodsPageStyle.text),
        ),
      ),
    );
  }
}
