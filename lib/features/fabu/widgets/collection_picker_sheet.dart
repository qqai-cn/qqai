import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/util/api_error_message.dart';

import '../../my/data/models/profile_models.dart';
import '../../my/data/repos/profile_repo.dart';

/// 发布视频时选择本人合集（多选）。
Future<Map<int, String>?> showCollectionPickerSheet(
  BuildContext context, {
  required Map<int, String> initialSelection,
}) {
  return showModalBottomSheet<Map<int, String>>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => _CollectionPickerSheet(initialSelection: initialSelection),
  );
}

class _CollectionPickerSheet extends ConsumerStatefulWidget {
  const _CollectionPickerSheet({required this.initialSelection});

  final Map<int, String> initialSelection;

  @override
  ConsumerState<_CollectionPickerSheet> createState() =>
      _CollectionPickerSheetState();
}

class _CollectionPickerSheetState extends ConsumerState<_CollectionPickerSheet> {
  late Map<int, String> _selected;
  List<BlogCollectionResp> _collections = [];
  bool _loading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _selected = Map.from(widget.initialSelection);
    scheduleMicrotask(_loadCollections);
  }

  Future<void> _loadCollections() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ref
          .read(profileRepoProvider)
          .getMyCollectionsPage(1, pageSize: 100);
      if (!mounted) return;
      setState(() {
        _collections = data.list ?? [];
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  void _toggle(BlogCollectionResp item) {
    final id = item.id;
    if (id == null) return;
    setState(() {
      if (_selected.containsKey(id)) {
        _selected.remove(id);
      } else {
        _selected[id] = item.name ?? '合集';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, bottom + 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('选择合集', style: context.typo.sectionTitle),
            const SizedBox(height: 4),
            Text(
              '可选多个，发布后将加入对应合集',
              style: context.typo.caption.copyWith(color: const Color(0xFF6B7280)),
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Text(ApiErrorMessage.userMessage(_error!), style: context.typo.body),
                    TextButton(onPressed: _loadCollections, child: const Text('重试')),
                  ],
                ),
              )
            else if (_collections.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  '暂无合集，可先在「我的-合集」中创建',
                  textAlign: TextAlign.center,
                  style: context.typo.body.copyWith(color: const Color(0xFF6B7280)),
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.45,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _collections.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = _collections[index];
                    final id = item.id;
                    final selected = id != null && _selected.containsKey(id);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        selected
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: selected
                            ? const Color(0xFF3578E5)
                            : const Color(0xFF9CA3AF),
                      ),
                      title: Text(item.name ?? '合集'),
                      subtitle: Text(
                        item.intro?.isNotEmpty == true
                            ? item.intro!
                            : '${item.itemCount ?? 0} 个作品',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: id == null ? null : () => _toggle(item),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF3578E5),
                    ),
                    onPressed: () => Navigator.pop(context, _selected),
                    child: Text(
                      _selected.isEmpty ? '确定' : '确定 (${_selected.length})',
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
