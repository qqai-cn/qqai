import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/fabu/theme/fabu_publish_theme.dart';
import 'package:qqai/util/api_error_message.dart';
import 'package:qqai/util/media_url.dart';

import '../../goods/data/models/mall_product_model.dart';
import '../../goods/data/repos/goods_repo.dart';

const int _kShopProductPageSize = 12;

/// 发布时从本人商品库选择挂载商品（团购带货，多选）。
Future<List<MallProduct>?> showShopProductPickerSheet(
  BuildContext context, {
  required List<MallProduct> initialSelection,
}) {
  return showModalBottomSheet<List<MallProduct>>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: AppActionColors.surface(context),
    builder: (ctx) => _ShopProductPickerSheet(
      initialSelection: initialSelection,
    ),
  );
}

class _ShopProductPickerSheet extends ConsumerStatefulWidget {
  const _ShopProductPickerSheet({required this.initialSelection});

  final List<MallProduct> initialSelection;

  @override
  ConsumerState<_ShopProductPickerSheet> createState() =>
      _ShopProductPickerSheetState();
}

class _ShopProductPickerSheetState extends ConsumerState<_ShopProductPickerSheet> {
  late List<MallProduct> _selected;
  final List<MallProduct> _products = [];
  final ScrollController _scrollController = ScrollController();

  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.initialSelection);
    _scrollController.addListener(_onScroll);
    scheduleMicrotask(_loadFirstPage);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_hasMore || _loadingMore || _loading) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 120) {
      unawaited(_loadMore());
    }
  }

  Future<void> _loadFirstPage() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ref
          .read(goodsRepoProvider)
          .getMyProductsPage(1, pageSize: _kShopProductPageSize);
      if (!mounted) return;
      setState(() {
        _products
          ..clear()
          ..addAll(data.list);
        _page = 1;
        _hasMore = data.list.length >= _kShopProductPageSize;
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

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore || _loading) return;
    setState(() => _loadingMore = true);
    try {
      final nextPage = _page + 1;
      final data = await ref
          .read(goodsRepoProvider)
          .getMyProductsPage(nextPage, pageSize: _kShopProductPageSize);
      if (!mounted) return;
      setState(() {
        _products.addAll(data.list);
        _page = nextPage;
        _hasMore = data.list.length >= _kShopProductPageSize;
        _loadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  void _toggle(MallProduct item) {
    final id = item.id;
    if (id == null) return;
    setState(() {
      final index = _selected.indexWhere((product) => product.id == id);
      if (index >= 0) {
        _selected.removeAt(index);
      } else {
        _selected.add(item);
      }
    });
  }

  void _close() {
    Navigator.pop(context, _selected);
  }

  bool _isSelected(MallProduct item) {
    final id = item.id;
    if (id == null) return false;
    return _selected.any((product) => product.id == id);
  }

  String _formatPrice(int? cents) {
    if (cents == null) return '';
    final yuan = cents / 100;
    if (cents % 100 == 0) return '¥${yuan.toStringAsFixed(0)}';
    return '¥${yuan.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _close();
      },
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, bottom + 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '选择商品',
                      style: context.typo.sectionTitle.copyWith(
                        color: FabuPublishTheme.text(context),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _close,
                    child: Text(
                      _selected.isEmpty ? '完成' : '完成 (${_selected.length})',
                    ),
                  ),
                ],
              ),
              Text(
                '从商品库中选择，观众可在作品中查看并购买',
                style: context.typo.caption.copyWith(
                  color: AppActionColors.muted(context),
                ),
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
                      Text(
                        ApiErrorMessage.userMessage(_error!),
                        style: context.typo.body,
                      ),
                      TextButton(
                        onPressed: _loadFirstPage,
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                )
              else if (_products.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    '暂无商品，可先在「我的」中发布商品',
                    textAlign: TextAlign.center,
                    style: context.typo.body.copyWith(
                      color: AppActionColors.muted(context),
                    ),
                  ),
                )
              else
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.52,
                  ),
                  child: ListView.separated(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: _products.length + (_loadingMore ? 1 : 0),
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: FabuPublishTheme.border(context),
                    ),
                    itemBuilder: (context, index) {
                      if (index >= _products.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }
                      final item = _products[index];
                      final selected = _isSelected(item);
                      final coverUrl = resolveMediaUrl(item.picUrl);
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: coverUrl == null
                                ? ColoredBox(
                                    color: FabuPublishTheme.panelBg(context),
                                    child: Icon(
                                      Icons.shopping_bag_outlined,
                                      color: AppActionColors.muted(context),
                                    ),
                                  )
                                : Image.network(
                                    coverUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => ColoredBox(
                                      color: FabuPublishTheme.panelBg(context),
                                      child: Icon(
                                        Icons.shopping_bag_outlined,
                                        color: AppActionColors.muted(context),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        title: Text(
                          item.name ?? '商品',
                          style: TextStyle(color: FabuPublishTheme.text(context)),
                        ),
                        subtitle: Text(
                          _formatPrice(item.price),
                          style: context.typo.caption.copyWith(
                            color: FabuPublishTheme.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Icon(
                          selected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: selected
                              ? FabuPublishTheme.accent
                              : AppActionColors.subtle(context),
                        ),
                        onTap: () => _toggle(item),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
