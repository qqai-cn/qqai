import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:qqai/config/theme/app_action_colors.dart';

import '../../../components/api_error_widget.dart';
import '../../my/utils/footprint_timeline.dart';
import '../data/member_center_models.dart';
import '../data/member_center_repo.dart';
import '../providers/member_center_provider.dart';
import 'member_center_premium_widgets.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('签到成功，积分与经验已入账')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _signing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(memberCenterProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      backgroundColor: MemberPremiumColors.darkBg,
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ApiErrorWidget(
          message: error.toString(),
          padding: const EdgeInsets.all(24),
          retryAction: () => ref.invalidate(memberCenterProvider),
        ),
        data: (data) => RefreshIndicator(
          onRefresh: () async => ref.refresh(memberCenterProvider.future),
          color: MemberPremiumColors.gold,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: isWide ? 380 : 360,
                backgroundColor: MemberPremiumColors.darkBg,
                foregroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/');
                    }
                  },
                ),
                title: const Text(
                  'PLUS会员',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Badge(
                      isLabelVisible: !data.signInSummary.todaySignIn,
                      smallSize: 8,
                      backgroundColor: MemberPremiumColors.jdRed,
                      child: const Icon(Icons.more_horiz),
                    ),
                    onPressed: () => openMemberDetail(context, 'benefits'),
                  ),
                  const SizedBox(width: 4),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: MemberPremiumHero(data: data),
                ),
              ),
              SliverToBoxAdapter(
                child: MemberPremiumBody(
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
      backgroundColor: MemberPremiumColors.pageBg,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppActionColors.surface(context),
        foregroundColor: AppActionColors.strong(context),
        elevation: 0,
      ),
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
          subtitle: '返回会员中心点击"签到开启"领取今日奖励',
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
      decoration: memberCardDecoration(),
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
            style: TextStyle(color: AppActionColors.muted(context)),
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
              color: MemberPremiumColors.goldDeep.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: MemberPremiumColors.goldDeep, size: 20),
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
                    color: AppActionColors.muted(context),
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
          style: TextStyle(color: AppActionColors.subtle(context)),
        ),
      ),
    );
  }
}

String _signedNumber(int value) => value > 0 ? '+$value' : '$value';

String _formatDateTime(String? value) {
  final parsed = _parseRecordTime(value);
  if (parsed == null) {
    if (value == null || value.isEmpty) return '';
    return value.replaceFirst('T', ' ').split('.').first;
  }
  return '${_formatFullDate(parsed)} ${_twoDigits(parsed.hour)}:${_twoDigits(parsed.minute)}';
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
