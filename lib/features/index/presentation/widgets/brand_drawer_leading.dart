import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/components/brand/qqai_brand_logo.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../../providers/home_providers.dart';

/// 首页同款：旋转 Logo + 红色渐变「千千AI」+ 呼吸动画；点击展开侧栏或宽屏切换。
class BrandDrawerLeading extends ConsumerStatefulWidget {
  const BrandDrawerLeading({
    super.key,
    required this.isWideScreen,
  });

  final bool isWideScreen;

  @override
  ConsumerState<BrandDrawerLeading> createState() =>
      _BrandDrawerLeadingState();
}

class _BrandDrawerLeadingState extends ConsumerState<BrandDrawerLeading>
    with SingleTickerProviderStateMixin {
  late AnimationController _brandPulseController;
  late Animation<double> _brandBreath;

  @override
  void initState() {
    super.initState();
    _brandPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
    _brandBreath = CurvedAnimation(
      parent: _brandPulseController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _brandPulseController.dispose();
    super.dispose();
  }

  Widget _brandMark(BuildContext context, double glowBlur) {
    final theme = Theme.of(context);
    final glowAlpha = 0.42 + 0.22 * (glowBlur / 18).clamp(0.0, 1.0);
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFFB71C1C),
          Color(0xFFE53935),
          Color(0xFFFF8A80),
        ],
      ).createShader(bounds),
      child: Text(
        '千千AI',
        style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              fontSize: 17,
              height: 1.1,
              shadows: [
                Shadow(
                  color: const Color(0xFFE53935).withValues(alpha: glowAlpha),
                  blurRadius: glowBlur,
                  offset: const Offset(0, 1),
                ),
              ],
            ) ??
            context.typo.sectionTitle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              fontSize: 17,
              height: 1.1,
              shadows: [
                Shadow(
                  color: const Color(0xFFE53935).withValues(alpha: glowAlpha),
                  blurRadius: glowBlur,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isWideScreen) {
          ref.read(homeProvider.notifier).changeExtended();
        } else {
          Scaffold.of(context).openDrawer();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: AnimatedBuilder(
            animation: _brandBreath,
            builder: (context, child) {
              final t = _brandBreath.value;
              final scale = 1.0 + 0.018 * t;
              final glowBlur = 8.0 + 7.0 * t;
              return Transform.scale(
                scale: scale,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Opacity(
                      opacity: 0.94 + 0.06 * t,
                      child: const QqaiBrandLogo(size: 28),
                    ),
                    if (widget.isWideScreen) const SizedBox(width: 8),
                    if (widget.isWideScreen)
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: _brandMark(context, glowBlur),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
