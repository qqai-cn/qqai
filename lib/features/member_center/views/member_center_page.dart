import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../components/api_error_widget.dart';
import '../../../router/app_routes.dart';
import '../../my/utils/footprint_timeline.dart';
import '../data/member_center_models.dart';
import '../data/member_center_repo.dart';
import '../providers/member_center_provider.dart';

class MemberCenterPage extends ConsumerStatefulWidget {
  const MemberCenterPage({super.key});

  @override
  ConsumerState<MemberCenterPage> createState() => _MemberCenterPageState();
}

class _MemberCenterPageState extends ConsumerState<MemberCenterPage> {
  bool _signing = false;

  Future<void> _signIn() async {
    if (_signing) return;
    setState(() => _signing = true);
    try {
      await ref.read(memberCenterRepoProvider).signIn();
      ref.invalidate(memberCenterProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('签到成功，积分与经验已入账')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _signing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(memberCenterProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ApiErrorWidget(
          message: error.toString(),
          padding: const EdgeInsets.all(24),
          retryAction: () => ref.invalidate(memberCenterProvider),
        ),
        data: (data) => RefreshIndicator(
          onRefresh: () async => ref.refresh(memberCenterProvider.future),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: MediaQuery.sizeOf(context).width >= 900
                    ? 304
                    : 276,
                backgroundColor: const Color(0xFF07111F),
                foregroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/');
                    }
                  },
                ),
                title: const Text('会员中心'),
                flexibleSpace: FlexibleSpaceBar(
                  background: _MemberHero(data: data),
                ),
              ),
              SliverToBoxAdapter(
                child: _MemberCenterContent(
                  data: data,
                  signing: _signing,
                  onSignIn: _signIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MemberCenterDetailPage extends ConsumerWidget {
  const MemberCenterDetailPage({super.key, required this.section});

  final String section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(memberCenterProvider);
    final title = _memberDetailTitle(section);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: Text(title)),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ApiErrorWidget(
          message: error.toString(),
          padding: const EdgeInsets.all(24),
          retryAction: () => ref.invalidate(memberCenterProvider),
        ),
        data: (data) => RefreshIndicator(
          onRefresh: () async => ref.refresh(memberCenterProvider.future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 920),
                  child: _MemberDetailBody(section: section, data: data),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemberDetailBody extends StatelessWidget {
  const _MemberDetailBody({required this.section, required this.data});

  final String section;
  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    return switch (section) {
      'points' => _PointRecordDetail(data: data),
      'experience' => _ExperienceRecordDetail(data: data),
      'sign-in' => _SignInDetail(data: data),
      'levels' => _LevelsDetail(data: data),
      'brokerage' => _BrokerageDetail(data: data),
      _ => _BenefitsDetail(data: data),
    };
  }
}

class _MemberCenterContent extends StatelessWidget {
  const _MemberCenterContent({
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
        final horizontalPadding = isWide ? 28.0 : 16.0;

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                isWide ? 24 : 16,
                horizontalPadding,
                28,
              ),
              child: isWide ? _buildWide() : _buildNarrow(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNarrow() {
    return Column(
      children: [
        _StatGrid(data: data),
        const SizedBox(height: 14),
        _SignInPanel(
          summary: data.signInSummary,
          configs: data.signInConfigs,
          signing: signing,
          onSignIn: onSignIn,
        ),
        const SizedBox(height: 14),
        _LevelRoadmap(data: data),
        const SizedBox(height: 14),
        _BenefitGrid(data: data),
        const SizedBox(height: 14),
        _PointRecordPanel(data: data),
        const SizedBox(height: 14),
        _ExperienceRecordPanel(data: data),
      ],
    );
  }

  Widget _buildWide() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            children: [
              _StatGrid(data: data),
              const SizedBox(height: 16),
              _SignInPanel(
                summary: data.signInSummary,
                configs: data.signInConfigs,
                signing: signing,
                onSignIn: onSignIn,
              ),
              const SizedBox(height: 16),
              _BenefitGrid(
                data: data,
                crossAxisCount: 2,
                childAspectRatio: 2.2,
              ),
            ],
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          flex: 5,
          child: Column(
            children: [
              _LevelRoadmap(data: data),
              const SizedBox(height: 16),
              _PointRecordPanel(data: data),
              const SizedBox(height: 16),
              _ExperienceRecordPanel(data: data),
            ],
          ),
        ),
      ],
    );
  }
}

class _MemberHero extends StatelessWidget {
  const _MemberHero({required this.data});

  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    final user = data.user;
    final level = data.currentLevel;
    final next = data.nextLevel;
    final name = user.nickname?.trim().isNotEmpty == true
        ? user.nickname!.trim()
        : '千千会员';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF07111F), Color(0xFF123D4A), Color(0xFFB88746)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -46,
            top: 42,
            child: _GlowCircle(size: 152, color: const Color(0xFFFFD28A)),
          ),
          Positioned(
            left: -52,
            bottom: -28,
            child: _GlowCircle(size: 132, color: const Color(0xFF31D4C6)),
          ),
          SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 78, 28, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.18,
                            ),
                            backgroundImage: user.avatar?.isNotEmpty == true
                                ? NetworkImage(user.avatar!)
                                : null,
                            child: user.avatar?.isNotEmpty == true
                                ? null
                                : const Icon(Icons.person, color: Colors.white),
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
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  level?.name ?? '成长会员',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.76),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _LevelBadge(level: level?.level ?? 0),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              next == null
                                  ? '已点亮当前最高等级'
                                  : '距离 ${next.name ?? '下一等级'} 还差 ${data.experienceToNext} 经验',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.82),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            '${(data.levelProgress * 100).round()}%',
                            style: const TextStyle(
                              color: Color(0xFFFFD28A),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          minHeight: 8,
                          value: data.levelProgress,
                          backgroundColor: Colors.white.withValues(alpha: 0.16),
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFFFFD28A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.data});

  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: '可用积分',
            value: '${data.user.point}',
            icon: Icons.stars_outlined,
            color: const Color(0xFFB88746),
            onTap: () => _openMemberDetail(context, 'points'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: '成长经验',
            value: '${data.user.experience}',
            icon: Icons.bolt_outlined,
            color: const Color(0xFF109B8F),
            onTap: () => _openMemberDetail(context, 'experience'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: '连续签到',
            value: '${data.signInSummary.continuousDay}天',
            icon: Icons.local_fire_department_outlined,
            color: const Color(0xFFE45C3A),
            onTap: () => _openMemberDetail(context, 'sign-in'),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: _panelDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 22),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: Colors.black.withValues(alpha: 0.28),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.52),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignInPanel extends StatelessWidget {
  const _SignInPanel({
    required this.summary,
    required this.configs,
    required this.signing,
    required this.onSignIn,
  });

  final MemberSignInSummary summary;
  final List<MemberSignInConfig> configs;
  final bool signing;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final visibleConfigs = configs.take(7).toList();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  '每日签到',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
              FilledButton.icon(
                onPressed: summary.todaySignIn || signing ? null : onSignIn,
                icon: signing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        summary.todaySignIn
                            ? Icons.check_circle
                            : Icons.rocket_launch_outlined,
                      ),
                label: Text(summary.todaySignIn ? '已签到' : '立即签到'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '累计 ${summary.totalDay} 天，连续 ${summary.continuousDay} 天',
            style: TextStyle(color: Colors.black.withValues(alpha: 0.56)),
          ),
          if (visibleConfigs.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: visibleConfigs
                  .map(
                    (item) => Expanded(
                      child: _SignDayChip(
                        day: item.day,
                        point: item.point,
                        active: item.day <= summary.continuousDay,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _SignDayChip extends StatelessWidget {
  const _SignDayChip({
    required this.day,
    required this.point,
    required this.active,
  });

  final int day;
  final int point;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF109B8F) : const Color(0xFFCBD5E1);
    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withValues(alpha: active ? 0.16 : 0.45),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color),
          ),
          alignment: Alignment.center,
          child: Text(
            '$day',
            style: TextStyle(color: active ? color : const Color(0xFF64748B)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '+$point',
          style: TextStyle(
            color: Colors.black.withValues(alpha: 0.54),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _LevelRoadmap extends StatelessWidget {
  const _LevelRoadmap({required this.data});

  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    final levels = data.levels.take(6).toList();
    if (levels.isEmpty) return const SizedBox.shrink();
    final current = data.currentLevel?.level ?? 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '等级星图',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          ...levels.map(
            (level) => _LevelRow(
              level: level,
              active: level.level <= current,
              current: level.level == current,
              onTap: () => _openMemberDetail(context, 'levels'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelRow extends StatelessWidget {
  const _LevelRow({
    required this.level,
    required this.active,
    required this.current,
    required this.onTap,
  });

  final MemberLevelInfo level;
  final bool active;
  final bool current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFFB88746) : const Color(0xFF94A3B8);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              _LevelBadge(level: level.level, compact: true, active: active),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            level.name ?? 'Lv.${level.level}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        if (current)
                          const Text(
                            '当前',
                            style: TextStyle(
                              color: Color(0xFF109B8F),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${level.experience} 经验解锁'
                      '${level.discountPercent == null ? '' : ' · ${level.discountPercent}%权益'}',
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                active ? Icons.check_circle : Icons.radio_button_unchecked,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                color: Colors.black.withValues(alpha: 0.26),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitGrid extends StatelessWidget {
  const _BenefitGrid({
    required this.data,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.72,
  });

  final MemberCenterData data;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    final discount = data.currentLevel?.discountPercent;
    final benefits = [
      _BenefitItem(
        icon: Icons.workspace_premium_outlined,
        title: '等级权益',
        subtitle: discount == null ? '成长解锁专属身份' : '当前享 $discount% 权益',
        section: 'levels',
      ),
      const _BenefitItem(
        icon: Icons.card_giftcard_outlined,
        title: '签到奖励',
        subtitle: '每日领取积分奖励',
        section: 'sign-in',
      ),
      const _BenefitItem(
        icon: Icons.trending_up_outlined,
        title: '经验成长',
        subtitle: '内容互动提升等级',
        section: 'experience',
      ),
      _BenefitItem(
        icon: Icons.handshake_outlined,
        title: '推广员',
        subtitle: data.user.brokerageEnabled ? '已开通推广身份' : '待解锁推广身份',
        section: 'brokerage',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: benefits.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => _BenefitCard(item: benefits[index]),
    );
  }
}

class _BenefitItem {
  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.section,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String section;
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({required this.item});

  final _BenefitItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openMemberDetail(context, item.section),
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: _panelDecoration(),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF07111F).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(item.icon, color: const Color(0xFF123D4A)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.5),
                        fontSize: 12,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: Colors.black.withValues(alpha: 0.28),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PointRecordPanel extends StatelessWidget {
  const _PointRecordPanel({required this.data});

  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    return _RecordPanel(
      title: '积分动态',
      emptyText: '暂无积分记录',
      onMore: () => _openMemberDetail(context, 'points'),
      children: data.pointRecords
          .map(
            (item) => _RecordTile(
              icon: Icons.generating_tokens_outlined,
              title: item.title ?? '积分变动',
              subtitle: item.description ?? _formatDate(item.createTime),
              trailing: _signedNumber(item.point),
              positive: item.point >= 0,
            ),
          )
          .toList(),
    );
  }
}

class _ExperienceRecordPanel extends StatelessWidget {
  const _ExperienceRecordPanel({required this.data});

  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    return _RecordPanel(
      title: '经验轨迹',
      emptyText: '暂无经验记录',
      onMore: () => _openMemberDetail(context, 'experience'),
      children: data.experienceRecords
          .map(
            (item) => _RecordTile(
              icon: Icons.auto_graph_outlined,
              title: item.title ?? '经验变动',
              subtitle: item.description ?? _formatDate(item.createTime),
              trailing: '${_signedNumber(item.experience)} EXP',
              positive: item.experience >= 0,
            ),
          )
          .toList(),
    );
  }
}

class _RecordPanel extends StatelessWidget {
  const _RecordPanel({
    required this.title,
    required this.emptyText,
    required this.children,
    this.onMore,
  });

  final String title;
  final String emptyText;
  final List<Widget> children;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (onMore != null)
                TextButton(onPressed: onMore, child: const Text('查看全部')),
            ],
          ),
          const SizedBox(height: 12),
          if (children.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(
                  emptyText,
                  style: TextStyle(color: Colors.black.withValues(alpha: 0.48)),
                ),
              ),
            )
          else
            ...children,
        ],
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.positive,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final color = positive ? const Color(0xFF109B8F) : const Color(0xFFE45C3A);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.46),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            trailing,
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _TimelineRecord {
  const _TimelineRecord({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.positive,
    required this.icon,
    required this.time,
  });

  final String title;
  final String subtitle;
  final String trailing;
  final bool positive;
  final IconData icon;
  final DateTime? time;
}

class _TimelineList extends StatelessWidget {
  const _TimelineList({required this.records});

  final List<_TimelineRecord> records;

  @override
  Widget build(BuildContext context) {
    final sorted = [...records]
      ..sort((a, b) {
        final aTime = a.time;
        final bTime = b.time;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });
    final groups = groupFootprintByTimeline<_TimelineRecord>(
      items: sorted,
      readTime: (record) => record.time,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < groups.length; index++) ...[
          _TimelineGroupView(group: groups[index]),
          if (index != groups.length - 1) const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class _TimelineGroupView extends StatelessWidget {
  const _TimelineGroupView({required this.group});

  final FootprintTimelineSection<_TimelineRecord> group;

  @override
  Widget build(BuildContext context) {
    return ContentTimelineSectionFrame(
      title: group.title,
      padding: EdgeInsets.zero,
      child: Column(
        children: group.items
            .map((record) => _TimelineTile(record: record))
            .toList(),
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.record});

  final _TimelineRecord record;

  @override
  Widget build(BuildContext context) {
    return ContentTimelineRecordTile(
      icon: record.icon,
      title: record.title,
      subtitle: record.subtitle,
      trailing: record.trailing,
      positive: record.positive,
    );
  }
}

class _PointRecordDetail extends StatelessWidget {
  const _PointRecordDetail({required this.data});

  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    final records = data.pointRecords
        .map(
          (item) => _TimelineRecord(
            title: item.title ?? '积分变动',
            subtitle: item.description ?? _formatDateTime(item.createTime),
            trailing: _signedNumber(item.point),
            positive: item.point >= 0,
            icon: Icons.generating_tokens_outlined,
            time: _parseRecordTime(item.createTime),
          ),
        )
        .toList();
    return _DetailPanel(
      title: '积分明细',
      subtitle: '当前可用积分 ${data.user.point}',
      children: data.pointRecords.isEmpty
          ? const [_EmptyDetail(text: '暂无积分记录')]
          : [_TimelineList(records: records)],
    );
  }
}

class _ExperienceRecordDetail extends StatelessWidget {
  const _ExperienceRecordDetail({required this.data});

  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    final records = data.experienceRecords
        .map(
          (item) => _TimelineRecord(
            title: item.title ?? '经验变动',
            subtitle: item.description ?? _formatDateTime(item.createTime),
            trailing: '${_signedNumber(item.experience)} EXP',
            positive: item.experience >= 0,
            icon: Icons.auto_graph_outlined,
            time: _parseRecordTime(item.createTime),
          ),
        )
        .toList();
    return _DetailPanel(
      title: '经验明细',
      subtitle: '当前成长经验 ${data.user.experience}',
      children: data.experienceRecords.isEmpty
          ? const [_EmptyDetail(text: '暂无经验记录')]
          : [_TimelineList(records: records)],
    );
  }
}

class _SignInDetail extends StatelessWidget {
  const _SignInDetail({required this.data});

  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    final configs = data.signInConfigs;
    return _DetailPanel(
      title: '签到奖励',
      subtitle:
          '累计签到 ${data.signInSummary.totalDay} 天，连续 ${data.signInSummary.continuousDay} 天',
      children: [
        _InfoTile(
          icon: data.signInSummary.todaySignIn
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
          title: data.signInSummary.todaySignIn ? '今日已签到' : '今日还未签到',
          subtitle: '返回会员中心点击“立即签到”领取今日奖励',
        ),
        const SizedBox(height: 12),
        if (configs.isEmpty)
          const _EmptyDetail(text: '暂无签到规则')
        else
          ...configs.map(
            (item) => _InfoTile(
              icon: Icons.card_giftcard_outlined,
              title: '第 ${item.day} 天',
              subtitle: '签到奖励 +${item.point} 积分',
            ),
          ),
      ],
    );
  }
}

class _LevelsDetail extends StatelessWidget {
  const _LevelsDetail({required this.data});

  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    return _DetailPanel(
      title: '等级权益',
      subtitle: data.nextLevel == null
          ? '你已点亮当前最高等级'
          : '距离 ${data.nextLevel?.name ?? '下一等级'} 还差 ${data.experienceToNext} 经验',
      children: data.levels.isEmpty
          ? const [_EmptyDetail(text: '暂无等级配置')]
          : data.levels
                .map(
                  (level) => _InfoTile(
                    icon: level.level <= (data.currentLevel?.level ?? 0)
                        ? Icons.workspace_premium
                        : Icons.workspace_premium_outlined,
                    title: level.name ?? 'LV ${level.level}',
                    subtitle:
                        '${level.experience} 经验解锁'
                        '${level.discountPercent == null ? '' : ' · ${level.discountPercent}%权益'}',
                  ),
                )
                .toList(),
    );
  }
}

class _BenefitsDetail extends StatelessWidget {
  const _BenefitsDetail({required this.data});

  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    final discount = data.currentLevel?.discountPercent;
    return _DetailPanel(
      title: '会员权益',
      subtitle: '围绕等级、积分、签到和成长体系的会员能力',
      children: [
        _InfoTile(
          icon: Icons.workspace_premium_outlined,
          title: '等级权益',
          subtitle: discount == null ? '成长解锁专属身份' : '当前享 $discount% 权益',
        ),
        const _InfoTile(
          icon: Icons.card_giftcard_outlined,
          title: '签到奖励',
          subtitle: '每日签到领取积分，连续签到提升活跃度',
        ),
        const _InfoTile(
          icon: Icons.trending_up_outlined,
          title: '经验成长',
          subtitle: '经验越高，会员等级越高，权益逐步解锁',
        ),
        _InfoTile(
          icon: Icons.handshake_outlined,
          title: '推广员',
          subtitle: data.user.brokerageEnabled ? '已开通推广身份' : '待解锁推广身份',
        ),
      ],
    );
  }
}

class _BrokerageDetail extends StatelessWidget {
  const _BrokerageDetail({required this.data});

  final MemberCenterData data;

  @override
  Widget build(BuildContext context) {
    return _DetailPanel(
      title: '推广员',
      subtitle: data.user.brokerageEnabled ? '已开通推广身份' : '当前暂未开通推广身份',
      children: const [
        _InfoTile(
          icon: Icons.verified_user_outlined,
          title: '身份状态',
          subtitle: '推广员能力来自后端会员信息中的 brokerageEnabled 字段',
        ),
        _InfoTile(
          icon: Icons.campaign_outlined,
          title: '能力说明',
          subtitle: '后续可在这里接入邀请、佣金、团队等推广员功能页面',
        ),
      ],
    );
  }
}

class _DetailPanel extends StatelessWidget {
  const _DetailPanel({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(color: Colors.black.withValues(alpha: 0.54)),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF123D4A).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF123D4A), size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.5),
                    fontSize: 12,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDetail extends StatelessWidget {
  const _EmptyDetail({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.black.withValues(alpha: 0.48)),
        ),
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({
    required this.level,
    this.compact = false,
    this.active = true,
  });

  final int level;
  final bool compact;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 5 : 8,
      ),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFFFD28A).withValues(alpha: 0.18)
            : const Color(0xFFE2E8F0),
        border: Border.all(
          color: active ? const Color(0xFFFFD28A) : const Color(0xFFCBD5E1),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'LV $level',
        style: TextStyle(
          color: active ? const Color(0xFFFFD28A) : const Color(0xFF64748B),
          fontWeight: FontWeight.w900,
          fontSize: compact ? 12 : 14,
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.16),
      ),
    );
  }
}

BoxDecoration _panelDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.06),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );
}

String _signedNumber(int value) => value > 0 ? '+$value' : '$value';

String _formatDate(String? value) {
  if (value == null || value.isEmpty) return '';
  return value.replaceFirst('T', ' ').split('.').first;
}

String _formatDateTime(String? value) {
  final parsed = _parseRecordTime(value);
  if (parsed == null) return _formatDate(value);
  return '${_formatFullDate(parsed)} ${_twoDigits(parsed.hour)}:${_twoDigits(parsed.minute)}';
}

void _openMemberDetail(BuildContext context, String section) {
  context.push('${Routes.memberCenterDetail}/$section');
}

String _memberDetailTitle(String section) {
  return switch (section) {
    'points' => '积分明细',
    'experience' => '经验明细',
    'sign-in' => '签到奖励',
    'levels' => '等级权益',
    'brokerage' => '推广员',
    _ => '会员权益',
  };
}

DateTime? _parseRecordTime(String? value) {
  return parseContentCreateTime(value);
}

String _formatFullDate(DateTime date) {
  return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');
