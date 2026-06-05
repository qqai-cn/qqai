import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/config/theme/app_typography.dart';

import '../data/feedback_repo.dart';

/// 反馈类型（与后端 AppMemberFeedbackCreateReqVO.type 一致）
const List<(int type, String label)> kFeedbackTypes = [
  (1, '功能异常'),
  (2, '使用体验'),
  (3, '账号相关'),
  (4, '功能建议'),
  (5, '其他'),
];

class FeedbackPage extends ConsumerStatefulWidget {
  const FeedbackPage({super.key});

  @override
  ConsumerState<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends ConsumerState<FeedbackPage> {
  int? _selectedType;
  final _contentController = TextEditingController();
  final _contactController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  String _platformLabel() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.linux:
        return 'linux';
      case TargetPlatform.fuchsia:
        return 'fuchsia';
    }
  }

  Future<void> _submit() async {
    final type = _selectedType;
    final content = _contentController.text.trim();
    if (type == null) {
      _showSnack('请选择反馈类型');
      return;
    }
    if (content.length < 5) {
      _showSnack('请至少填写 5 个字的问题描述');
      return;
    }

    setState(() => _submitting = true);
    try {
      await ref.read(feedbackRepoProvider).submitFeedback(
            type: type,
            content: content,
            contact: _contactController.text,
            appVersion: '1.0.0',
            platform: _platformLabel(),
          );
      if (!mounted) return;
      _showSnack('反馈已提交，感谢你的帮助');
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      _showSnack(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('问题反馈'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Text(
            '反馈类型',
            style: context.typo.sectionTitle.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 8),
          ...kFeedbackTypes.map(
            (entry) => RadioListTile<int>(
              value: entry.$1,
              groupValue: _selectedType,
              contentPadding: EdgeInsets.zero,
              title: Text(entry.$2),
              onChanged: _submitting
                  ? null
                  : (value) => setState(() => _selectedType = value),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '问题描述',
            style: context.typo.sectionTitle.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _contentController,
            enabled: !_submitting,
            maxLines: 6,
            maxLength: 2000,
            decoration: const InputDecoration(
              hintText: '请详细描述你遇到的问题或建议（至少 5 字）',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '联系方式（选填）',
            style: context.typo.sectionTitle.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _contactController,
            enabled: !_submitting,
            maxLength: 128,
            decoration: const InputDecoration(
              hintText: '手机号或邮箱，方便我们联系你',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('提交反馈'),
          ),
        ],
      ),
    );
  }
}
