import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/features/search/theme/search_ai_theme.dart';
import 'package:qqai/router/app_routes.dart';

import '../data/models/ai_chat_models.dart';
import '../data/repos/ai_chat_repo.dart';
import '../providers/ai_assistants_provider.dart';

/// AI 好友详情：发消息 + 设定（对标后管对话设定）
class AiFriendDetailPage extends ConsumerStatefulWidget {
  const AiFriendDetailPage({
    super.key,
    required this.conversationId,
    this.showAppBar = true,
  });

  final int conversationId;
  final bool showAppBar;

  @override
  ConsumerState<AiFriendDetailPage> createState() => _AiFriendDetailPageState();
}

class _AiFriendDetailPageState extends ConsumerState<AiFriendDetailPage> {
  /// 宽屏可两列流式排布；窄屏单列。
  static const double _contentMaxWidth = 880;
  static const double _twoColMinWidth = 520;

  AiChatConversationDto? _conversation;
  List<AiModelSimpleDto> _models = [];
  bool _loading = true;
  bool _saving = false;
  String? _error;

  late final TextEditingController _titleCtrl;
  late final TextEditingController _systemCtrl;
  int? _modelId;
  double _temperature = 0.7;
  int _maxTokens = 4096;
  int _maxContexts = 10;

  bool get _isDefault => _conversation?.isDefaultAssistant == true;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _systemCtrl = TextEditingController();
    Future.microtask(_load);
  }

  @override
  void didUpdateWidget(covariant AiFriendDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.conversationId != widget.conversationId) {
      Future.microtask(_load);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _systemCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(aiChatRepoProvider);
      final c = await repo.getMyConversation(widget.conversationId);
      final models = await repo.listChatModels();
      if (!mounted) return;
      if (c == null) {
        setState(() {
          _loading = false;
          _error = '助手不存在';
        });
        return;
      }
      _conversation = c;
      _models = models;
      _titleCtrl.text = c.title ?? '';
      _systemCtrl.text = c.systemMessage ?? '';
      _modelId = c.modelId;
      _temperature = c.temperature ?? 0.7;
      _maxTokens = c.maxTokens ?? 4096;
      _maxContexts = c.maxContexts ?? 10;
      setState(() => _loading = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  Future<void> _save() async {
    if (_saving || _modelId == null) return;
    setState(() => _saving = true);
    try {
      await ref.read(aiChatRepoProvider).updateMyConversation(
            id: widget.conversationId,
            title: _titleCtrl.text.trim().isEmpty
                ? (_conversation?.title ?? 'AI助手')
                : _titleCtrl.text.trim(),
            systemMessage: _systemCtrl.text.trim(),
            modelId: _modelId,
            temperature: _temperature,
            maxTokens: _maxTokens,
            maxContexts: _maxContexts,
          );
      ref.invalidate(aiAssistantsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('设定已保存')),
        );
        await _load();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败：$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    if (_isDefault) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final ai = SearchAiTheme.of(ctx);
        return AlertDialog(
          backgroundColor: ai.cardBg,
          title: Text('删除助手', style: TextStyle(color: ai.text)),
          content: Text(
            '确定删除该 AI 助手？对话记录也会一并删除。',
            style: TextStyle(color: ai.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('取消', style: TextStyle(color: ai.textSecondary)),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: SearchAiTheme.brandRed,
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('删除'),
            ),
          ],
        );
      },
    );
    if (ok != true) return;
    try {
      await ref
          .read(aiChatRepoProvider)
          .deleteMyConversation(widget.conversationId);
      ref.invalidate(aiAssistantsProvider);
      if (mounted) {
        if (widget.showAppBar) {
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('已删除')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('删除失败：$e')),
        );
      }
    }
  }

  void _openChat() {
    context.go(
      '${Routes.messagePage}?aiConversationId=${widget.conversationId}',
    );
  }

  InputDecoration _fieldDecoration(
    SearchAiTheme ai, {
    required String label,
    String? hint,
    bool alignHint = false,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: ai.cardBorder),
    );
    return InputDecoration(
      labelText: label,
      hintText: hint,
      alignLabelWithHint: alignHint,
      filled: true,
      fillColor: ai.chipBg,
      labelStyle: TextStyle(color: ai.textSecondary, fontSize: 13),
      hintStyle: TextStyle(color: ai.textSecondary.withValues(alpha: 0.7)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ai.accent, width: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ai = SearchAiTheme.of(context);
    final body = _loading
        ? Center(
            child: CircularProgressIndicator(color: ai.accent),
          )
        : _error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: ai.textSecondary),
                  ),
                ),
              )
            : _buildBody(ai);

    if (!widget.showAppBar) {
      return Material(color: Colors.transparent, child: body);
    }
    return Scaffold(
      backgroundColor: ai.pageGradient.last,
      appBar: AppBar(
        backgroundColor: ai.appBarBg,
        surfaceTintColor: Colors.transparent,
        title: Text(
          _conversation?.title ?? 'AI 助手',
          style: TextStyle(color: ai.text, fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(color: ai.text),
        actions: [
          if (!_isDefault)
            IconButton(
              tooltip: '删除',
              onPressed: _delete,
              icon: Icon(
                Icons.delete_outline,
                color: SearchAiTheme.brandRed.withValues(alpha: 0.9),
              ),
            ),
        ],
      ),
      body: body,
    );
  }

  Widget _buildBody(SearchAiTheme ai) {
    const gap = 12.0;
    const pad = 16.0;

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: ai.pageGradient,
              ),
            ),
          ),
        ),
        Positioned(
          top: -40,
          right: -30,
          child: _Orb(diameter: 160, gradient: ai.orbCyanGradient),
        ),
        Positioned(
          bottom: 80,
          left: -50,
          child: _Orb(diameter: 180, gradient: ai.orbRedGradient),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final shellW = constraints.maxWidth.clamp(0.0, _contentMaxWidth);
            final usable = (shellW - pad * 2).clamp(0.0, double.infinity);
            final twoCol = usable >= _twoColMinWidth;
            final half = twoCol ? (usable - gap) / 2 : usable;
            final full = usable;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(pad, 16.h, pad, 40.h),
                  child: Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      SizedBox(
                        width: full,
                        child: _ProfileCard(
                          ai: ai,
                          title: _conversation?.title ?? 'AI助手',
                          model: _conversation?.model ?? 'AI 助手',
                          isDefault: _isDefault,
                          onChat: _openChat,
                        ),
                      ),
                      SizedBox(
                        width: half,
                        child: _ModuleCard(
                          ai: ai,
                          icon: Icons.badge_outlined,
                          title: '助手名称',
                          child: TextField(
                            controller: _titleCtrl,
                            style: TextStyle(color: ai.text, fontSize: 14),
                            decoration: _fieldDecoration(ai, label: '名称'),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: half,
                        child: _ModuleCard(
                          ai: ai,
                          icon: Icons.memory_outlined,
                          title: '模型',
                          child: DropdownButtonFormField<int>(
                            value: _modelId != null &&
                                    _models.any((m) => m.id == _modelId)
                                ? _modelId
                                : (_models.isNotEmpty
                                    ? _models.first.id
                                    : null),
                            dropdownColor: ai.cardBg,
                            isExpanded: true,
                            style: TextStyle(color: ai.text, fontSize: 14),
                            decoration: _fieldDecoration(ai, label: '选择模型'),
                            items: _models
                                .where((m) => m.id != null)
                                .map(
                                  (m) => DropdownMenuItem(
                                    value: m.id,
                                    child: Text(
                                      m.name ?? m.model ?? '${m.id}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              if (v == null) return;
                              final model =
                                  _models.firstWhere((m) => m.id == v);
                              setState(() {
                                _modelId = v;
                                if (model.temperature != null) {
                                  _temperature = model.temperature!;
                                }
                                if (model.maxTokens != null) {
                                  _maxTokens = model.maxTokens!;
                                }
                                if (model.maxContexts != null) {
                                  _maxContexts = model.maxContexts!;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: full,
                        child: _ModuleCard(
                          ai: ai,
                          icon: Icons.psychology_outlined,
                          title: '角色设定',
                          child: TextField(
                            controller: _systemCtrl,
                            minLines: 3,
                            maxLines: 6,
                            style: TextStyle(color: ai.text, fontSize: 14),
                            decoration: _fieldDecoration(
                              ai,
                              label: '人设 / 提示词',
                              hint: '描述助手的人设、语气与能力边界…',
                              alignHint: true,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: half,
                        child: _ModuleCard(
                          ai: ai,
                          icon: Icons.thermostat_outlined,
                          title: '温度',
                          child: _ParamSlider(
                            ai: ai,
                            label: '随机性',
                            valueText: _temperature.toStringAsFixed(2),
                            value: _temperature.clamp(0, 2),
                            min: 0,
                            max: 2,
                            divisions: 40,
                            onChanged: (v) =>
                                setState(() => _temperature = v),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: half,
                        child: _ModuleCard(
                          ai: ai,
                          icon: Icons.token_outlined,
                          title: '回复 Token',
                          child: _ParamSlider(
                            ai: ai,
                            label: '上限',
                            valueText: '$_maxTokens',
                            value: _maxTokens.clamp(256, 8192).toDouble(),
                            min: 256,
                            max: 8192,
                            divisions: 31,
                            onChanged: (v) =>
                                setState(() => _maxTokens = v.round()),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: half,
                        child: _ModuleCard(
                          ai: ai,
                          icon: Icons.history_outlined,
                          title: '上下文数量',
                          child: _ParamSlider(
                            ai: ai,
                            label: '轮次',
                            valueText: '$_maxContexts',
                            value: _maxContexts.clamp(0, 20).toDouble(),
                            min: 0,
                            max: 20,
                            divisions: 20,
                            onChanged: (v) =>
                                setState(() => _maxContexts = v.round()),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: half,
                        child: _ModuleCard(
                          ai: ai,
                          icon: Icons.save_outlined,
                          title: '操作',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _SaveButton(
                                ai: ai,
                                saving: _saving,
                                onTap: _saving ? null : _save,
                              ),
                              if (!_isDefault && !widget.showAppBar) ...[
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: _delete,
                                  child: Text(
                                    '删除助手',
                                    style: TextStyle(
                                      color: SearchAiTheme.brandRed
                                          .withValues(alpha: 0.85),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.diameter, required this.gradient});

  final double diameter;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient,
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.ai,
    required this.title,
    required this.model,
    required this.isDefault,
    required this.onChat,
  });

  final SearchAiTheme ai;
  final String title;
  final String model;
  final bool isDefault;
  final VoidCallback onChat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: ai.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ai.cardBorder),
        boxShadow: ai.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: ai.aiBadgeGradient,
              boxShadow: [
                BoxShadow(
                  color: SearchAiTheme.cyan.withValues(alpha: 0.28),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 32,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ai.text,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 6.h),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              _MetaChip(ai: ai, label: model, icon: Icons.smart_toy_outlined),
              if (isDefault)
                _MetaChip(
                  ai: ai,
                  label: '默认助手',
                  icon: Icons.star_outline,
                  highlight: true,
                ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: ai.searchButtonGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: SearchAiTheme.brandRed.withValues(alpha: 0.28),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onChat,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '发消息',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.ai,
    required this.label,
    required this.icon,
    this.highlight = false,
  });

  final SearchAiTheme ai;
  final String label;
  final IconData icon;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final fg = highlight ? SearchAiTheme.brandRed : ai.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: highlight
            ? SearchAiTheme.brandRed.withValues(alpha: ai.isDark ? 0.16 : 0.08)
            : ai.accentSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlight
              ? SearchAiTheme.brandRed.withValues(alpha: 0.28)
              : ai.chipBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.ai,
    required this.icon,
    required this.title,
    required this.child,
  });

  final SearchAiTheme ai;
  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: ai.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ai.cardBorder),
        boxShadow: ai.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  gradient: ai.aiBadgeGradient,
                ),
                child: Icon(icon, size: 14, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: ai.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _ParamSlider extends StatelessWidget {
  const _ParamSlider({
    required this.ai,
    required this.label,
    required this.valueText,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final SearchAiTheme ai;
  final String label;
  final String valueText;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 2),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: ai.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ai.accentSoft,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ai.chipBorder),
                ),
                child: Text(
                  valueText,
                  style: TextStyle(
                    color: ai.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: ai.accent,
              inactiveTrackColor: ai.line,
              thumbColor: SearchAiTheme.cyan,
              overlayColor: SearchAiTheme.cyan.withValues(alpha: 0.16),
              trackHeight: 3.5,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              label: valueText,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.ai,
    required this.saving,
    required this.onTap,
  });

  final SearchAiTheme ai;
  final bool saving;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: ai.accent,
          side: BorderSide(color: ai.accent.withValues(alpha: 0.55)),
          backgroundColor: ai.accentSoft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: saving
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ai.accent,
                ),
              )
            : const Text(
                '保存设定',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
      ),
    );
  }
}
