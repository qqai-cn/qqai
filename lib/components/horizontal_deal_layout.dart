import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/util/adaptive_sp.dart';

/// 横向推荐卡片外框 **宽:高**（左图右文）。[SliverGrid] 的 `childAspectRatio` 控高。
const double kHorizontalDealCardAspectRatio = 4.0;

/// 宽屏（≥800）双列，窄屏单列。
int horizontalDealGridCrossAxisCount(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= 800 ? 2 : 1;

/// 团购带货风格渐变 Banner。
class DealPromoBanner extends StatelessWidget {
  const DealPromoBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.gradientColors = const [Color(0xFFFE2C55), Color(0xFFFF6B8A)],
    this.height,
  });

  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height ?? 120.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: context.typo.sectionTitle.copyWith(
              color: Colors.white,
              fontSize: 20.spClamp(maxSp: 30),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            subtitle,
            style: context.typo.body.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 15.spClamp(maxSp: 20),
            ),
          ),
        ],
      ),
    );
  }
}

/// 横向推荐卡片配色。
class HorizontalDealCardStyle {
  const HorizontalDealCardStyle({
    required this.cardColor,
    required this.accentColor,
    required this.chevronColor,
    this.titleColor,
    this.priceTextColor,
    this.borderColor,
    this.tagBackgroundAlpha = 0.2,
    this.useScreenUtil = true,
  });

  final Color cardColor;
  final Color accentColor;
  final Color chevronColor;
  final Color? titleColor;
  final Color? priceTextColor;
  final Color? borderColor;
  final double tagBackgroundAlpha;
  final bool useScreenUtil;

  factory HorizontalDealCardStyle.douyin({
    required BuildContext context,
    required Color Function(BuildContext) card,
    required Color Function(BuildContext) sub,
    Color accent = const Color(0xFFFE2C55),
  }) {
    return HorizontalDealCardStyle(
      cardColor: card(context),
      accentColor: accent,
      chevronColor: sub(context),
    );
  }

  factory HorizontalDealCardStyle.goods({
    required BuildContext context,
    required Color Function(BuildContext) cardBg,
    required Color Function(BuildContext) sub,
    required Color Function(BuildContext) border,
    Color accent = const Color(0xFFE11D48),
  }) {
    return HorizontalDealCardStyle(
      cardColor: cardBg(context),
      accentColor: accent,
      chevronColor: sub(context),
      titleColor: null,
      borderColor: border(context),
      tagBackgroundAlpha: 0.08,
      useScreenUtil: false,
    );
  }

  factory HorizontalDealCardStyle.square({
    required BuildContext context,
    required Color Function(BuildContext) cardBg,
    required Color Function(BuildContext) sub,
    required Color Function(BuildContext) border,
    required Color Function(BuildContext) strong,
    Color accent = const Color(0xFF3578E5),
    Color priceTextColor = const Color(0xFFE11D48),
  }) {
    return HorizontalDealCardStyle(
      cardColor: cardBg(context),
      accentColor: accent,
      chevronColor: sub(context),
      titleColor: strong(context),
      priceTextColor: priceTextColor,
      borderColor: border(context),
      tagBackgroundAlpha: 0.1,
      useScreenUtil: false,
    );
  }
}

/// 左图右文推荐卡片（团购带货同款布局）。
class HorizontalDealCard extends StatelessWidget {
  const HorizontalDealCard({
    super.key,
    required this.tag,
    required this.title,
    required this.priceText,
    required this.image,
    required this.style,
    this.onTap,
    this.showChevron = true,
    /// 列表场景可指定封面边长；网格场景留空，封面随单元格高度自适应为正方形。
    this.imageExtent,
  });

  final String tag;
  final String title;
  final String priceText;
  final Widget image;
  final HorizontalDealCardStyle style;
  final VoidCallback? onTap;
  final bool showChevron;
  final double? imageExtent;

  @override
  Widget build(BuildContext context) {
    final radius = style.useScreenUtil ? 12.r : 12.0;
    final imageRadius = style.useScreenUtil ? 8.r : 8.0;
    final padding = style.useScreenUtil
        ? EdgeInsets.all(2.w)
        : const EdgeInsets.all(10.0);
    final gap = style.useScreenUtil ? 5.w : 10.0;

    Widget cover = ClipRRect(
      borderRadius: BorderRadius.circular(imageRadius),
      child: image,
    );
    if (imageExtent != null) {
      cover = SizedBox(width: imageExtent, height: imageExtent, child: cover);
    } else {
      cover = AspectRatio(aspectRatio: 1, child: cover);
    }

    final titleStyle = context.typo.body.copyWith(
      color: style.titleColor ?? Theme.of(context).textTheme.bodyMedium?.color,
    );

    Widget card = Material(
      color: style.cardColor,
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: imageExtent != null
            ? Padding(
                padding: padding,
                child: _cardRow(
                  context,
                  cover: cover,
                  gap: gap,
                  titleStyle: titleStyle,
                ),
              )
            : SizedBox.expand(
                child: Padding(
                  padding: padding,
                  child: _cardRow(
                    context,
                    cover: cover,
                    gap: gap,
                    titleStyle: titleStyle,
                    stretch: true,
                  ),
                ),
              ),
      ),
    );

    if (style.borderColor != null) {
      card = DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: style.borderColor!),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: card,
      );
    }

    return card;
  }

  Widget _cardRow(
    BuildContext context, {
    required Widget cover,
    required double gap,
    required TextStyle titleStyle,
    bool stretch = false,
  }) {
    return Row(
      crossAxisAlignment:
          stretch ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
      children: [
        cover,
        SizedBox(width: gap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: style.useScreenUtil
                    ? null
                    : const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: style.accentColor.withValues(
                    alpha: style.tagBackgroundAlpha,
                  ),
                  borderRadius: BorderRadius.circular(
                    style.useScreenUtil ? 4.r : 4,
                  ),
                ),
                child: Text(
                  tag,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typo.caption.copyWith(
                    color: style.accentColor,
                    fontWeight:
                        style.useScreenUtil ? FontWeight.w200 : FontWeight.w500,
                    fontSize: style.useScreenUtil ? null : 11,
                    height: 1.1,
                  ),
                ),
              ),
              if (!stretch) SizedBox(height: style.useScreenUtil ? 0 : 6),
              Flexible(
                child: Padding(
                  padding: stretch
                      ? const EdgeInsets.symmetric(vertical: 2)
                      : EdgeInsets.zero,
                  child: Text(
                    title,
                    maxLines: stretch ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: titleStyle.copyWith(
                      fontSize: style.useScreenUtil ? null : 15,
                      height: style.useScreenUtil ? 1.15 : 1.25,
                      fontWeight:
                          style.useScreenUtil ? null : FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (!stretch) SizedBox(height: style.useScreenUtil ? 0 : 6),
              Text(
                priceText,
                style: context.typo.price.copyWith(
                  color: style.priceTextColor ?? style.accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: style.useScreenUtil ? null : 18,
                  height: 1.1,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        if (showChevron)
          Icon(Icons.chevron_right, color: style.chevronColor),
      ],
    );
  }
}

/// 团购带货页：Banner + 分区标题 + 推荐网格。
List<Widget> buildHorizontalDealRecommendationSlivers({
  required BuildContext context,
  required String sectionTitle,
  required int itemCount,
  required IndexedWidgetBuilder itemBuilder,
  DealPromoBanner? banner,
  Color? sectionTitleColor,
  EdgeInsetsGeometry? horizontalPadding,
  double aspectRatio = kHorizontalDealCardAspectRatio,
}) {
  final padding = horizontalPadding ?? EdgeInsets.symmetric(horizontal: 16.w);
  final titleColor = sectionTitleColor ?? Theme.of(context).textTheme.bodyLarge?.color;
  final cols = horizontalDealGridCrossAxisCount(context);

  final slivers = <Widget>[];
  if (banner != null) {
    slivers.add(
      SliverPadding(
        padding: padding.add(EdgeInsets.only(top: 8.h, bottom: 16.h)),
        sliver: SliverToBoxAdapter(
          child: SizedBox(width: double.infinity, child: banner),
        ),
      ),
    );
  }
  slivers.add(
    SliverPadding(
      padding: padding,
      sliver: SliverToBoxAdapter(
        child: Text(
          sectionTitle,
          style: context.typo.sectionTitle.copyWith(color: titleColor),
        ),
      ),
    ),
  );
  slivers.add(
    SliverPadding(
      padding: padding.add(EdgeInsets.only(top: 12.h, bottom: 24.h)),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: aspectRatio,
        ),
        delegate: SliverChildBuilderDelegate(itemBuilder, childCount: itemCount),
      ),
    ),
  );
  return slivers;
}
