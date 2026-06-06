import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/dark_theme_colors.dart';

import '../../../router/app_routes.dart';
import '../data/member_center_models.dart';

// ── Theme ──────────────────────────────────────────────────────────────────

abstract final class MemberPremiumColors {
  static const darkBg = Color(0xFF1A1410);
  static const darkMid = Color(0xFF2D2218);
  static const gold = Color(0xFFE8C078);
  static const goldLight = Color(0xFFFFE8B8);
  static const goldDeep = Color(0xFFB88746);
  static const jdRed = Color(0xFFE1251B);
  static const jdRedLight = Color(0xFFFF6B5A);
  static const pageBgLight = Color(0xFFF4F4F4);
  static const cardBgLight = Colors.white;

  static bool _isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  static Color pageBg(BuildContext context) {
    return _isLight(context)
        ? pageBgLight
        : DarkThemeColors.scaffoldBackgroundColor;
  }

  static Color cardBg(BuildContext context) {
    return _isLight(context) ? cardBgLight : DarkThemeColors.cardColor;
  }

  static Color giftButtonBg(BuildContext context) {
    return _isLight(context)
        ? const Color(0xFFF5E6C8)
        : gold.withValues(alpha: 0.18);
  }

  static Color giftButtonFg(BuildContext context) {
    return _isLight(context) ? const Color(0xFF5C4528) : goldLight;
  }

  static Color inactiveDot(BuildContext context) {
    return _isLight(context)
        ? const Color(0xFFCBD5E1)
        : Colors.white.withValues(alpha: 0.24);
  }

  /// 内容区卡片上的次要文字（浅色模式保留原 45% 黑，避免偏淡）。
  static Color bodySecondary(BuildContext context) {
    return _isLight(context)
        ? Colors.black.withValues(alpha: 0.45)
        : AppActionColors.muted(context);
  }

  static Color giftButtonDisabledBg(BuildContext context) {
    return _isLight(context)
        ? const Color(0xFFE8E8E8)
        : AppActionColors.borderSubtle(context);
  }

  static Color giftButtonDisabledFg(BuildContext context) {
    return _isLight(context) ? Colors.black38 : AppActionColors.subtle(context);
  }
}

BoxDecoration memberCardDecoration(BuildContext context, {double radius = 14}) {
  final isLight = MemberPremiumColors._isLight(context);
  return BoxDecoration(
    color: MemberPremiumColors.cardBg(context),
    borderRadius: BorderRadius.circular(radius),
    border: isLight
        ? null
        : Border.all(color: Colors.white.withValues(alpha: 0.08)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: isLight ? 0.06 : 0.35),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

void openMemberDetail(BuildContext context, String section) {
  context.push('${Routes.memberCenterDetail}/$section');
}

int _totalEarnedPoints(List<MemberPointRecord> records) {
  return records.where((r) => r.point > 0).fold(0, (sum, r) => sum + r.point);
}

// ── Hero ───────────────────────────────────────────────────────────────────

class MemberPremiumHero extends StatelessWidget {
  const MemberPremiumHero({super.key, required this.data});

  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    final user = data.user;
    final level = data.currentLevel;
    final name = user.nickname?.trim().isNotEmpty == true
        ? user.nickname!.trim()
        : '千千会员';
    final earnedPoints = _totalEarnedPoints(data.pointRecords);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D0A08),
            Color(0xFF1F1710),
            Color(0xFF3D2E1A),
            Color(0xFF5C4528),
          ],
          stops: [0.0, 0.35, 0.72, 1.0],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -30,
            top: 20,
            child: _GoldenCrown(level: level?.level ?? 0),
          ),
          Positioned(
            left: -60,
            bottom: 40,
            child: _GlowOrb(size: 140, color: MemberPremiumColors.gold),
          ),
          Positioned(
            right: 80,
            bottom: -20,
            child: _GlowOrb(size: 80, color: MemberPremiumColors.goldLight),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 72, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AvatarWithBadge(
                        avatarUrl: user.avatar,
                        levelName: level?.name ?? '成长会员',
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _SavingsChip(
                              earnedPoints: earnedPoints,
                              onTap: () => openMemberDetail(context, 'points'),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _LevelPill(
                                  label: level?.name ?? '成长会员',
                                  level: level?.level ?? 0,
                                ),
                                const SizedBox(width: 8),
                                if (data.nextLevel != null)
                                  _UpgradeButton(
                                    onTap: () =>
                                        openMemberDetail(context, 'levels'),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _QuickBenefitRow(data: data),
                  const SizedBox(height: 14),
                  _HeroPromoBanner(data: data),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoldenCrown extends StatelessWidget {
  const _GoldenCrown({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  MemberPremiumColors.gold.withValues(alpha: 0.35),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFF3D0),
                Color(0xFFE8C078),
                Color(0xFFB88746),
                Color(0xFF8B6914),
              ],
            ).createShader(bounds),
            child: const Icon(
              Icons.workspace_premium_rounded,
              size: 72,
              color: Colors.white,
            ),
          ),
          Positioned(
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFE8B8), Color(0xFFE8C078)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: MemberPremiumColors.gold.withValues(alpha: 0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Text(
                level > 0 ? 'LV.$level' : 'PLUS',
                style: const TextStyle(
                  color: Color(0xFF3D2E1A),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarWithBadge extends StatelessWidget {
  const _AvatarWithBadge({this.avatarUrl, required this.levelName});

  final String? avatarUrl;
  final String levelName;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFFE8B8), Color(0xFFB88746)],
            ),
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFF2D2218),
            backgroundImage:
                avatarUrl?.isNotEmpty == true ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl?.isNotEmpty == true
                ? null
                : const Icon(Icons.person, color: Colors.white70, size: 28),
          ),
        ),
        Positioned(
          bottom: -4,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3D2E1A), Color(0xFF5C4528)],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: MemberPremiumColors.gold.withValues(alpha: 0.6),
                ),
              ),
              child: Text(
                levelName.length > 4
                    ? levelName.substring(0, 4)
                    : levelName,
                style: const TextStyle(
                  color: MemberPremiumColors.goldLight,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SavingsChip extends StatelessWidget {
  const _SavingsChip({required this.earnedPoints, required this.onTap});

  final int earnedPoints;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '累计获得 $earnedPoints 积分',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13,
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 16,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }
}

class _LevelPill extends StatelessWidget {
  const _LevelPill({required this.label, required this.level});

  final String label;
  final int level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        level > 0 ? '$label · Lv.$level' : label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 11,
        ),
      ),
    );
  }
}

class _UpgradeButton extends StatelessWidget {
  const _UpgradeButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFE8B8), Color(0xFFE8C078)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          '去升级',
          style: TextStyle(
            color: Color(0xFF3D2E1A),
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _QuickBenefitRow extends StatelessWidget {
  const _QuickBenefitRow({required this.data});

  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    final discount = data.currentLevel?.discountPercent;
    final items = [
      _QuickItem(
        icon: Icons.stars_rounded,
        label: '积分',
        badge: data.user.point > 0 ? '${data.user.point}' : null,
        section: 'points',
      ),
      _QuickItem(
        icon: Icons.local_fire_department_rounded,
        label: '签到',
        badge: data.signInSummary.todaySignIn ? null : '待领',
        section: 'sign-in',
      ),
      _QuickItem(
        icon: Icons.workspace_premium_rounded,
        label: '等级',
        badge: discount != null ? '$discount%' : null,
        section: 'levels',
      ),
      _QuickItem(
        icon: Icons.bolt_rounded,
        label: '经验',
        section: 'experience',
      ),
      _QuickItem(
        icon: Icons.handshake_rounded,
        label: '推广',
        badge: data.user.brokerageEnabled ? '已开' : '待解锁',
        section: 'brokerage',
      ),
      _QuickItem(
        icon: Icons.card_giftcard_rounded,
        label: '福利',
        section: 'benefits',
      ),
    ];

    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 4),
        itemBuilder: (context, index) {
          final item = items[index];
          return _QuickBenefitIcon(item: item);
        },
      ),
    );
  }
}

class _QuickItem {
  const _QuickItem({
    required this.icon,
    required this.label,
    required this.section,
    this.badge,
  });

  final IconData icon;
  final String label;
  final String? badge;
  final String section;
}

class _QuickBenefitIcon extends StatelessWidget {
  const _QuickBenefitIcon({required this.item});

  final _QuickItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openMemberDetail(context, item.section),
      child: SizedBox(
        width: 58,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Icon(item.icon, color: MemberPremiumColors.goldLight, size: 22),
                ),
                if (item.badge != null)
                  Positioned(
                    top: -6,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: MemberPremiumColors.jdRed,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroPromoBanner extends StatelessWidget {
  const _HeroPromoBanner({required this.data});

  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    final next = data.nextLevel;
    final progress = (data.levelProgress * 100).round();
    final subtitle = next == null
        ? '已点亮最高等级，尊享全部权益'
        : '距 ${next.name ?? '下一等级'} 还差 ${data.experienceToNext} 经验';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MemberPremiumColors.gold.withValues(alpha: 0.3),
                  MemberPremiumColors.goldDeep.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.trending_up_rounded,
              color: MemberPremiumColors.goldLight,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    value: data.levelProgress,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation(
                      MemberPremiumColors.gold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$progress%',
            style: const TextStyle(
              color: MemberPremiumColors.goldLight,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.12),
      ),
    );
  }
}

// ── Body sections ──────────────────────────────────────────────────────────

class MemberPremiumBody extends StatelessWidget {
  const MemberPremiumBody({
    super.key,
    required this.data,
    required this.signing,
    required this.onSignIn,
  });

  final MemberCenterData data;
  final bool signing;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;
        final horizontal = isWide ? 28.0 : 14.0;

        return Transform.translate(
          offset: const Offset(0, -18),
          child: Container(
            decoration: BoxDecoration(
              color: MemberPremiumColors.pageBg(context),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontal,
                    isWide ? 28 : 16,
                    horizontal,
                    32,
                  ),
                  child: isWide ? _buildWide(context) : _buildNarrow(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNarrow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SuperSubsidyBanner(data: data),
        const SizedBox(height: 16),
        _DailyGiftsSection(
          data: data,
          signing: signing,
          onSignIn: onSignIn,
        ),
        const SizedBox(height: 20),
        _HotBenefitsSection(data: data),
        const SizedBox(height: 20),
        _ExclusiveCards(data: data),
        const SizedBox(height: 20),
        _LevelProgressCard(data: data),
        const SizedBox(height: 16),
        _CompactRecordsSection(data: data),
      ],
    );
  }

  Widget _buildWide(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SuperSubsidyBanner(data: data),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: _DailyGiftsSection(
                data: data,
                signing: signing,
                onSignIn: onSignIn,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  _HotBenefitsSection(data: data, compact: true),
                  const SizedBox(height: 16),
                  _LevelProgressCard(data: data),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _ExclusiveCards(data: data),
        const SizedBox(height: 20),
        _CompactRecordsSection(data: data),
      ],
    );
  }
}

class _SuperSubsidyBanner extends StatelessWidget {
  const _SuperSubsidyBanner({required this.data});

  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    final discount = data.currentLevel?.discountPercent;
    final levelName = data.currentLevel?.name ?? '成长会员';

    return GestureDetector(
      onTap: () => openMemberDetail(context, 'levels'),
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFE1251B), Color(0xFFFF4757), Color(0xFFFF6B5A)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: MemberPremiumColors.jdRed.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.white, Color(0xFFFFE8B8)],
                    ).createShader(bounds),
                    child: Text(
                      discount != null
                          ? 'PLUS 专属 $discount% 权益'
                          : 'PLUS 超级成长补贴',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    discount != null
                        ? '当前 $levelName 等级已解锁'
                        : '升级解锁更多专属折扣',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '去看看',
                style: TextStyle(
                  color: MemberPremiumColors.jdRed,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyGiftsSection extends StatelessWidget {
  const _DailyGiftsSection({
    required this.data,
    required this.signing,
    required this.onSignIn,
  });

  final MemberCenterData data;
  final bool signing;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final configs = data.signInConfigs;
    final summary = data.signInSummary;

    final cards = <_GiftCardData>[
      _GiftCardData(
        title: '每日盲盒',
        subtitle: configs.isNotEmpty
            ? '最高 ${configs.last.point} 积分'
            : '签到领惊喜',
        icon: Icons.redeem_rounded,
        iconColors: const [Color(0xFFFFB347), Color(0xFFFFCC80)],
        buttonLabel: summary.todaySignIn ? '已签到' : '签到开启',
        enabled: !summary.todaySignIn && !signing,
        loading: signing,
        onTap: onSignIn,
      ),
      _GiftCardData(
        title: '积分宝箱',
        subtitle: '可用 ${data.user.point} 积分',
        icon: Icons.monetization_on_rounded,
        iconColors: const [Color(0xFFE8C078), Color(0xFFFFE8B8)],
        buttonLabel: '去查看',
        onTap: () => openMemberDetail(context, 'points'),
      ),
      _GiftCardData(
        title: '经验红包',
        subtitle: '当前 ${data.user.experience} 经验',
        icon: Icons.card_giftcard_rounded,
        iconColors: const [Color(0xFFFF6B5A), Color(0xFFFFB4A8)],
        buttonLabel: '去成长',
        onTap: () => openMemberDetail(context, 'experience'),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'PLUS 每日好礼',
          trailing: '连续 ${summary.continuousDay} 天',
        ),
        const SizedBox(height: 12),
        Row(
          children: cards
              .map(
                (card) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: card != cards.last ? 10 : 0,
                    ),
                    child: _DailyGiftCard(data: card),
                  ),
                ),
              )
              .toList(),
        ),
        if (configs.isNotEmpty) ...[
          const SizedBox(height: 12),
          _SignInDayStrip(summary: summary, configs: configs),
        ],
      ],
    );
  }
}

class _GiftCardData {
  const _GiftCardData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColors,
    required this.buttonLabel,
    this.enabled = true,
    this.loading = false,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> iconColors;
  final String buttonLabel;
  final bool enabled;
  final bool loading;
  final VoidCallback? onTap;
}

class _DailyGiftCard extends StatelessWidget {
  const _DailyGiftCard({required this.data});

  final _GiftCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 14, 10, 12),
      decoration: memberCardDecoration(context, radius: 14),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: data.iconColors,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: data.iconColors.first.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(data.icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 10),
          Text(
            data.title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: AppActionColors.strong(context),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            data.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MemberPremiumColors.bodySecondary(context),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 28,
            child: TextButton(
              onPressed: data.enabled ? data.onTap : null,
              style: TextButton.styleFrom(
                backgroundColor: MemberPremiumColors.giftButtonBg(context),
                foregroundColor: MemberPremiumColors.giftButtonFg(context),
                disabledBackgroundColor:
                    MemberPremiumColors.giftButtonDisabledBg(context),
                disabledForegroundColor:
                    MemberPremiumColors.giftButtonDisabledFg(context),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: data.loading
                  ? SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: MemberPremiumColors.giftButtonFg(context),
                      ),
                    )
                  : Text(
                      data.buttonLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: MemberPremiumColors.giftButtonFg(context),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignInDayStrip extends StatelessWidget {
  const _SignInDayStrip({required this.summary, required this.configs});

  final MemberSignInSummary summary;
  final List<MemberSignInConfig> configs;

  @override
  Widget build(BuildContext context) {
    final visible = configs.take(7).toList();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: memberCardDecoration(context, radius: 12),
      child: Row(
        children: visible
            .map(
              (item) => Expanded(
                child: _SignDayDot(
                  day: item.day,
                  point: item.point,
                  active: item.day <= summary.continuousDay,
                  today: item.day == summary.continuousDay + 1 &&
                      !summary.todaySignIn,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SignDayDot extends StatelessWidget {
  const _SignDayDot({
    required this.day,
    required this.point,
    required this.active,
    this.today = false,
  });

  final int day;
  final int point;
  final bool active;
  final bool today;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? MemberPremiumColors.goldDeep
        : today
        ? MemberPremiumColors.jdRed
        : MemberPremiumColors.inactiveDot(context);

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: active ? 0.18 : 0.08),
            border: Border.all(color: color, width: today ? 2 : 1),
          ),
          alignment: Alignment.center,
          child: active
              ? Icon(Icons.check, size: 16, color: color)
              : Text('$day', style: TextStyle(color: color, fontSize: 11)),
        ),
        const SizedBox(height: 4),
        Text(
          '+$point',
          style: TextStyle(
            fontSize: 9,
            color: MemberPremiumColors.bodySecondary(context),
          ),
        ),
      ],
    );
  }
}

class _HotBenefitsSection extends StatelessWidget {
  const _HotBenefitsSection({required this.data, this.compact = false});

  final MemberCenterData data;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final discount = data.currentLevel?.discountPercent;
    final items = [
      _HotBenefitItem(
        icon: Icons.stars_rounded,
        iconColor: const Color(0xFFE8C078),
        title: '积分兑换',
        subtitle: '${data.user.point} 积分可用',
        section: 'points',
      ),
      _HotBenefitItem(
        icon: Icons.local_fire_department_rounded,
        iconColor: const Color(0xFFFF6B5A),
        title: '连续签到',
        subtitle: '${data.signInSummary.continuousDay} 天奖励',
        section: 'sign-in',
      ),
      _HotBenefitItem(
        icon: Icons.workspace_premium_rounded,
        iconColor: const Color(0xFFB88746),
        title: '等级折扣',
        subtitle: discount != null ? '$discount% 权益' : '升级解锁',
        section: 'levels',
      ),
      _HotBenefitItem(
        icon: Icons.trending_up_rounded,
        iconColor: const Color(0xFF109B8F),
        title: '经验加速',
        subtitle: '${data.user.experience} EXP',
        section: 'experience',
      ),
      _HotBenefitItem(
        icon: Icons.handshake_rounded,
        iconColor: const Color(0xFF6366F1),
        title: '推广员',
        subtitle: data.user.brokerageEnabled ? '已开通' : '待解锁',
        section: 'brokerage',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: '热门必领',
          trailing: '更多权益 >',
          onTrailingTap: () => openMemberDetail(context, 'benefits'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: compact ? 110 : 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) =>
                _HotBenefitCard(item: items[index]),
          ),
        ),
      ],
    );
  }
}

class _HotBenefitItem {
  const _HotBenefitItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.section,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String section;
}

class _HotBenefitCard extends StatelessWidget {
  const _HotBenefitCard({required this.item});

  final _HotBenefitItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openMemberDetail(context, item.section),
      child: Container(
        width: 148,
        padding: const EdgeInsets.all(12),
        decoration: memberCardDecoration(context, radius: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: AppActionColors.strong(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: MemberPremiumColors.bodySecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: MemberPremiumColors.jdRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                '领取',
                style: TextStyle(
                  color: MemberPremiumColors.jdRed,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExclusiveCards extends StatelessWidget {
  const _ExclusiveCards({required this.data});

  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    final discount = data.currentLevel?.discountPercent;
    final levelName = data.currentLevel?.name ?? '成长会员';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'PLUS 专享'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ExclusiveCard(
                title: '等级嘉年华',
                subtitle: discount != null
                    ? '$levelName · $discount% 权益'
                    : '升级解锁专属折扣',
                gradient: const [Color(0xFF1F1710), Color(0xFF5C4528)],
                accentIcon: Icons.workspace_premium_rounded,
                onTap: () => openMemberDetail(context, 'levels'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ExclusiveCard(
                title: '成长必做清单',
                subtitle: '距下一级 ${data.experienceToNext} 经验',
                gradient: const [Color(0xFFE1251B), Color(0xFFFF6B5A)],
                accentIcon: Icons.rocket_launch_rounded,
                onTap: () => openMemberDetail(context, 'experience'),
                actionLabel: '冲',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ExclusiveCard extends StatelessWidget {
  const _ExclusiveCard({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.accentIcon,
    required this.onTap,
    this.actionLabel = '看',
  });

  final String title;
  final String subtitle;
  final List<Color> gradient;
  final IconData accentIcon;
  final VoidCallback onTap;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -8,
              bottom: -8,
              child: Icon(
                accentIcon,
                size: 64,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      actionLabel,
                      style: TextStyle(
                        color: gradient.first,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelProgressCard extends StatelessWidget {
  const _LevelProgressCard({required this.data});

  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    final levels = data.levels.take(5).toList();
    if (levels.isEmpty) return const SizedBox.shrink();
    final current = data.currentLevel?.level ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: memberCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '等级星图',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppActionColors.strong(context),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => openMemberDetail(context, 'levels'),
                child: Text(
                  '全部 >',
                  style: TextStyle(
                    color: MemberPremiumColors.bodySecondary(context),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...levels.map(
            (level) => _LevelStep(
              level: level,
              active: level.level <= current,
              current: level.level == current,
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelStep extends StatelessWidget {
  const _LevelStep({
    required this.level,
    required this.active,
    required this.current,
  });

  final MemberLevelInfo level;
  final bool active;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? MemberPremiumColors.goldDeep
        : MemberPremiumColors.inactiveDot(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: active ? 0.15 : 0.08),
              border: Border.all(color: color),
            ),
            alignment: Alignment.center,
            child: Text(
              '${level.level}',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        level.name ?? 'Lv.${level.level}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: active
                              ? AppActionColors.strong(context)
                              : AppActionColors.subtle(context),
                        ),
                      ),
                    ),
                    if (current)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: MemberPremiumColors.gold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '当前',
                          style: TextStyle(
                            color: MemberPremiumColors.goldDeep,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  '${level.experience} 经验'
                  '${level.discountPercent == null ? '' : ' · ${level.discountPercent}% 权益'}',
                  style: TextStyle(
                    fontSize: 11,
                    color: MemberPremiumColors.bodySecondary(context),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            active ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
            color: color,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _CompactRecordsSection extends StatelessWidget {
  const _CompactRecordsSection({required this.data});

  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _MiniRecordCard(
            title: '积分动态',
            emptyText: '暂无积分记录',
            section: 'points',
            records: data.pointRecords.take(3).map((item) {
              return _MiniRecord(
                title: item.title ?? '积分变动',
                value: _signedNumber(item.point),
                positive: item.point >= 0,
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MiniRecordCard(
            title: '经验轨迹',
            emptyText: '暂无经验记录',
            section: 'experience',
            records: data.experienceRecords.take(3).map((item) {
              return _MiniRecord(
                title: item.title ?? '经验变动',
                value: '${_signedNumber(item.experience)} EXP',
                positive: item.experience >= 0,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MiniRecord {
  const _MiniRecord({
    required this.title,
    required this.value,
    required this.positive,
  });

  final String title;
  final String value;
  final bool positive;
}

class _MiniRecordCard extends StatelessWidget {
  const _MiniRecordCard({
    required this.title,
    required this.emptyText,
    required this.section,
    required this.records,
  });

  final String title;
  final String emptyText;
  final String section;
  final List<_MiniRecord> records;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: memberCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: AppActionColors.strong(context),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => openMemberDetail(context, section),
                child: Text(
                  '全部',
                  style: TextStyle(
                    color: MemberPremiumColors.jdRed,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (records.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  emptyText,
                  style: TextStyle(
                    color: AppActionColors.subtle(context),
                    fontSize: 12,
                  ),
                ),
              ),
            )
          else
            ...records.map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        r.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppActionColors.strong(context),
                        ),
                      ),
                    ),
                    Text(
                      r.value,
                      style: TextStyle(
                        color: r.positive
                            ? const Color(0xFF109B8F)
                            : MemberPremiumColors.jdRed,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.trailing,
    this.onTrailingTap,
  });

  final String title;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.3,
              color: AppActionColors.strong(context),
            ),
          ),
        ),
        if (trailing != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: Text(
              trailing!,
              style: TextStyle(
                color: MemberPremiumColors.bodySecondary(context),
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}

String _signedNumber(int value) => value > 0 ? '+$value' : '$value';
