import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/models/profile_models.dart';
import '../data/repos/profile_repo.dart';
import '../providers/my_shop_profile.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 「店铺」Tab：我的商品分页，支持删除与新建。
class MyGoodsView extends ConsumerStatefulWidget {
  final int tabIndex;
  final int currentIndex;
  final int? userId;

  const MyGoodsView({
    super.key,
    required this.tabIndex,
    required this.currentIndex,
    this.userId,
  });

  @override
  ConsumerState<MyGoodsView> createState() => _MyGoodsViewState();
}

class _MyGoodsViewState extends ConsumerState<MyGoodsView>
    with AutomaticKeepAliveClientMixin {
  static const int _pageSize = 12;
  static const String _placeholderCover =
      'https://file.qqai.cn/qqai/2025/09/1.webp';

  List<BlogShopProductResp> _items = [];
  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  Object? _error;

  @override
  void initState() {
    super.initState();
    if (widget.tabIndex == widget.currentIndex) {
      scheduleMicrotask(_loadFirstPage);
    }
  }

  @override
  void didUpdateWidget(MyGoodsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _items = [];
      _page = 1;
      _hasMore = true;
      _error = null;
      if (widget.tabIndex == widget.currentIndex) {
        unawaited(_loadFirstPage());
      }
      return;
    }
    if (widget.tabIndex == widget.currentIndex &&
        oldWidget.currentIndex != widget.currentIndex &&
        _items.isEmpty &&
        !_loading) {
      unawaited(_loadFirstPage());
    }
  }

  bool get _isSelf => widget.userId == null;

  bool _onScrollNotification(ScrollNotification notification) {
    if (!_hasMore || _loadingMore || _loading) return false;
    final metrics = notification.metrics;
    if (metrics.maxScrollExtent > 0 &&
        metrics.pixels >= metrics.maxScrollExtent - 400) {
      unawaited(_loadMore());
    }
    return false;
  }

  Future<void> _loadFirstPage() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(profileRepoProvider);
      final userId = widget.userId;
      final data = userId != null
          ? await repo.getUserShopProductsPage(userId, 1, pageSize: _pageSize)
          : await repo.getMyShopProductsPage(1, pageSize: _pageSize);
      if (!mounted) return;
      setState(() {
        _items = List.from(data.list ?? []);
        _page = 1;
        _hasMore = (data.list?.length ?? 0) >= _pageSize;
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
    if (_loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    try {
      final repo = ref.read(profileRepoProvider);
      final next = _page + 1;
      final userId = widget.userId;
      final data = userId != null
          ? await repo.getUserShopProductsPage(userId, next, pageSize: _pageSize)
          : await repo.getMyShopProductsPage(next, pageSize: _pageSize);
      final add = data.list ?? [];
      if (!mounted) return;
      setState(() {
        _items = [..._items, ...add];
        _page = next;
        _hasMore = add.length >= _pageSize;
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  Future<void> _confirmDelete(BlogShopProductResp p) async {
    final id = p.id;
    if (id == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除商品'),
        content: Text('确定删除「${p.name ?? ''}」吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('删除')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref.read(profileRepoProvider).deleteShopProduct(id);
      ref.invalidate(myShopProfileProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已删除')));
      await _loadFirstPage();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('删除失败: $e')),
      );
    }
  }

  Future<void> _openCreateDialog() async {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final coverCtrl = TextEditingController();
    final linkCtrl = TextEditingController();
    try {
      var status = 1;
      final submitted = await showDialog<bool>(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setLocal) => AlertDialog(
            title: const Text('新建商品'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: '名称 *'),
                  ),
                  TextField(
                    controller: priceCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: '售价（元）*',
                      hintText: '如 9.9',
                    ),
                  ),
                  TextField(
                    controller: coverCtrl,
                    decoration: const InputDecoration(labelText: '封面 URL（可选）'),
                  ),
                  TextField(
                    controller: linkCtrl,
                    decoration: const InputDecoration(labelText: '外链（可选）'),
                  ),
                  Row(
                    children: [
                      const Text('上架'),
                      Switch(
                        value: status == 1,
                        onChanged: (v) => setLocal(() => status = v ? 1 : 0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('创建'),
              ),
            ],
          ),
        ),
      );
      if (submitted != true || !mounted) return;
      final name = nameCtrl.text.trim();
      final yuan = double.tryParse(priceCtrl.text.trim());
      if (name.isEmpty || yuan == null || yuan < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请填写名称和有效价格')),
        );
        return;
      }
      final fen = (yuan * 100).round();
      try {
        await ref.read(profileRepoProvider).createShopProduct(
              BlogShopProductSaveReq(
                name: name,
                price: fen,
                status: status,
                coverUrl: coverCtrl.text.trim().isEmpty
                    ? null
                    : coverCtrl.text.trim(),
                externalUrl: linkCtrl.text.trim().isEmpty
                    ? null
                    : linkCtrl.text.trim(),
              ),
            );
        ref.invalidate(myShopProfileProvider);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已创建')),
        );
        await _loadFirstPage();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('创建失败: $e')),
        );
      }
    } finally {
      nameCtrl.dispose();
      priceCtrl.dispose();
      coverCtrl.dispose();
      linkCtrl.dispose();
    }
  }

  Future<void> _openProduct(BlogShopProductResp p) async {
    final url = p.externalUrl?.trim();
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('无法打开链接')),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.tabIndex != widget.currentIndex) {
      return const SizedBox.shrink();
    }
    final isWideScreen = 1.sw > 800;

    Widget body;
    if (_loading && _items.isEmpty) {
      body = CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    } else if (_error != null && _items.isEmpty) {
      body = CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('加载失败: $_error', style: context.typo.body),
                  TextButton(onPressed: _loadFirstPage, child: const Text('重试')),
                ],
              ),
            ),
          ),
        ],
      );
    } else if (_items.isEmpty) {
      body = CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                _isSelf ? '暂无商品，点击右下角添加' : '暂无商品',
                style: context.typo.body,
              ),
            ),
          ),
        ],
      );
    } else {
      body = NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: RefreshIndicator(
          onRefresh: _loadFirstPage,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWideScreen ? 4 : 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 2 / 3,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final p = _items[index];
                  final cover = (p.coverUrl != null && p.coverUrl!.isNotEmpty)
                      ? p.coverUrl!
                      : _placeholderCover;
                  final yuan = (p.price ?? 0) / 100.0;
                  final onShelf = p.status == 1;
                  return Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () => _openProduct(p),
                      onLongPress: _isSelf ? () => _confirmDelete(p) : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: cover,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => Image.network(
                                    _placeholderCover,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (_isSelf)
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: IconButton(
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.black45,
                                        foregroundColor: Colors.white,
                                      ),
                                      icon: const Icon(Icons.delete_outline, size: 20),
                                      onPressed: () => _confirmDelete(p),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.w, top: 6, right: 8),
                            child: Text(
                              p.name ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.typo.cardTitle.copyWith(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.w, top: 4, bottom: 6),
                            child: Row(
                              children: [
                                Text(
                                  '¥${yuan.toStringAsFixed(yuan == yuan.roundToDouble() ? 0 : 2)}',
                                  style: context.typo.bodyStrong.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  onShelf ? '上架' : '下架',
                                  style: context.typo.caption.copyWith(
                                    color: onShelf ? Colors.green : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: _items.length,
              ),
            ),
            if (_loadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isSelf) return body;

    return Stack(
      children: [
        body,
        Positioned(
          right: 16,
          bottom: 24,
          child: FloatingActionButton(
            onPressed: _openCreateDialog,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
