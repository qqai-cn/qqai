import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/components/chat/widgets/floating_emoji_picker.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/blog/data/models/blog_danmaku_model.dart';
import 'package:qqai/features/blog/data/repos/blog_danmaku_repo.dart';
import 'package:qqai/features/blog/providers/blog_danmaku_providers.dart';
import 'package:video_player/video_player.dart';

class BlogDanmakuOverlay extends ConsumerStatefulWidget {
  const BlogDanmakuOverlay({
    super.key,
    required this.blogId,
    required this.positionListenable,
    this.enabled = true,
    this.topPadding = 12,
    this.bottomPadding = 12,
    this.laneHeight = 32,
  });

  final int? blogId;
  final ValueListenable<VideoPlayerValue> positionListenable;
  final bool enabled;
  final double topPadding;
  final double bottomPadding;
  final double laneHeight;

  @override
  ConsumerState<BlogDanmakuOverlay> createState() => _BlogDanmakuOverlayState();
}

class _BlogDanmakuOverlayState extends ConsumerState<BlogDanmakuOverlay> {
  static const _tick = Duration(milliseconds: 280);
  static const _activeWindowMillis = 700;
  static const _flyDuration = Duration(milliseconds: 6200);

  final _random = Random();
  final _shownIds = <int>{};
  final _flying = <_FlyingDanmaku>[];
  List<BlogDanmakuItem> _items = const [];
  Timer? _timer;
  int _lastPositionMillis = 0;
  int? _lastRefreshVersion;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(_tick, (_) => _pump());
  }

  @override
  void didUpdateWidget(covariant BlogDanmakuOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.blogId != widget.blogId) {
      _items = const [];
      _shownIds.clear();
      _flying.clear();
      _lastPositionMillis = 0;
      _lastRefreshVersion = null;
      _load();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final blogId = widget.blogId;
    if (blogId == null || blogId <= 0) return;
    try {
      final items = await ref
          .read(blogDanmakuRepoProvider)
          .getDanmakuList(blogId);
      if (!mounted || widget.blogId != blogId) return;
      setState(() => _items = items);
    } catch (_) {
      if (!mounted || widget.blogId != blogId) return;
      setState(() => _items = const []);
    }
  }

  void _pump() {
    if (!mounted || !widget.enabled || _items.isEmpty) return;
    final value = widget.positionListenable.value;
    if (!value.isInitialized || !value.isPlaying) return;
    final now = value.position.inMilliseconds;
    final blogId = widget.blogId;
    if (blogId != null && blogId > 0) {
      ref.read(blogDanmakuCurrentPositionProvider(blogId).notifier).state = now;
    }
    if (now + 800 < _lastPositionMillis) {
      _shownIds.clear();
    }
    final from = max(0, min(_lastPositionMillis, now) - _activeWindowMillis);
    final to = max(_lastPositionMillis, now) + _activeWindowMillis;
    _lastPositionMillis = now;

    final nextItems = _items
        .where((item) {
          if (_shownIds.contains(item.id)) return false;
          return item.positionMillis >= from && item.positionMillis <= to;
        })
        .take(4)
        .toList();
    if (nextItems.isEmpty) return;

    setState(() {
      for (final item in nextItems) {
        _shownIds.add(item.id);
        _flying.add(
          _FlyingDanmaku(key: UniqueKey(), item: item, lane: _nextLane()),
        );
        Timer(_flyDuration, () {
          if (!mounted) return;
          setState(() => _flying.removeWhere((e) => e.item.id == item.id));
        });
      }
    });
  }

  int _nextLane() {
    final height = context.size?.height ?? 160;
    final usable = max(1.0, height - widget.topPadding - widget.bottomPadding);
    final lanes = max(1, usable ~/ widget.laneHeight);
    return _random.nextInt(min(lanes, 5));
  }

  @override
  Widget build(BuildContext context) {
    final blogId = widget.blogId;
    final danmakuVisible = blogId == null
        ? true
        : ref.watch(blogDanmakuVisibleProvider(blogId));
    final version = blogId == null
        ? 0
        : ref.watch(blogDanmakuRefreshProvider(blogId));
    if (_lastRefreshVersion != version) {
      _lastRefreshVersion = version;
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
    if (!widget.enabled || !danmakuVisible || blogId == null) {
      _flying.clear();
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: ClipRect(
        child: Stack(
          children: [
            for (final danmaku in _flying)
              Positioned(
                left: 0,
                right: 0,
                top: widget.topPadding + danmaku.lane * widget.laneHeight,
                child: _FlyingDanmakuText(
                  key: danmaku.key,
                  text: danmaku.item.content,
                  duration: _flyDuration,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 竖屏视频详情：抖音式圆形「弹」入口。
class BlogDanmakuLaunchButton extends ConsumerWidget {
  const BlogDanmakuLaunchButton({
    super.key,
    required this.blogId,
    this.size = 30,
  });

  final int? blogId;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = blogId;
    if (id == null || id <= 0) return const SizedBox.shrink();
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => showBlogDanmakuComposerSheet(context, ref, id),
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Text(
              '弹',
              style: context.typo.bodyStrong.copyWith(
                color: Colors.white,
                fontSize: size * 0.5,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showBlogDanmakuComposerSheet(
  BuildContext context,
  WidgetRef ref,
  int blogId,
) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black.withValues(alpha: 0.92),
    builder: (ctx) {
      final bottom = MediaQuery.viewInsetsOf(ctx).bottom;
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(14, 14, 14, bottom + 14),
          child: BlogDanmakuComposer(
            blogId: blogId,
            positionMillisGetter: () =>
                ref.read(blogDanmakuCurrentPositionProvider(blogId)),
          ),
        ),
      );
    },
  );
}

void toggleBlogDanmakuVisibility(
  BuildContext context,
  WidgetRef ref,
  int blogId, {
  bool? visible,
}) {
  final next =
      visible ?? !ref.read(blogDanmakuVisibleProvider(blogId));
  ref.read(blogDanmakuVisibleProvider(blogId).notifier).state = next;
  ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(next ? '弹幕已开启' : '弹幕已关闭'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1500),
      ),
    );
}

/// 分享面板内：弹幕显示开关（仅视频作品）。
class BlogDanmakuShareSheetToggle extends ConsumerWidget {
  const BlogDanmakuShareSheetToggle({
    super.key,
    required this.blogId,
    this.snackBarContext,
    this.onToggle,
  });

  final int blogId;
  final BuildContext? snackBarContext;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(blogDanmakuVisibleProvider(blogId));
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: Row(
        children: [
          Icon(
            Icons.subtitles_outlined,
            size: 22,
            color: AppActionColors.muted(context),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '弹幕',
              style: context.typo.bodyStrong.copyWith(
                color: AppActionColors.strong(context),
                fontSize: 15,
                height: 1.2,
              ),
            ),
          ),
          Switch(
            value: visible,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (_) {
              onToggle?.call();
              toggleBlogDanmakuVisibility(
                snackBarContext ?? context,
                ref,
                blogId,
              );
            },
          ),
        ],
      ),
    );
  }
}

class BlogDanmakuComposer extends ConsumerStatefulWidget {
  const BlogDanmakuComposer({
    super.key,
    required this.blogId,
    required this.positionMillisGetter,
    this.hintText = '发一条友好的弹幕吧',
  });

  final int? blogId;
  final int Function() positionMillisGetter;
  final String hintText;

  @override
  ConsumerState<BlogDanmakuComposer> createState() =>
      _BlogDanmakuComposerState();
}

class _BlogDanmakuComposerState extends ConsumerState<BlogDanmakuComposer> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _emojiButtonKey = GlobalKey();
  late final FloatingEmojiPickerController _emojiPicker;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _emojiPicker = FloatingEmojiPickerController(
      darkOverlay: true,
      onEmojiSelected: _insertEmoji,
      onVisibilityChanged: () {
        if (mounted) setState(() {});
      },
    );
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && _emojiPicker.isVisible && mounted) {
      _emojiPicker.hide();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _emojiPicker.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _toggleEmojiPanel() {
    if (_emojiPicker.isVisible) {
      _emojiPicker.hide();
      _focusNode.requestFocus();
      setState(() {});
      return;
    }
    _emojiPicker.show(context, _emojiButtonKey);
    _focusNode.unfocus();
    setState(() {});
  }

  void _insertEmoji(String emoji) {
    if (!insertTextAtSelection(_controller, emoji, maxLength: 80)) return;
    _focusNode.requestFocus();
  }

  Future<void> _submit() async {
    final blogId = widget.blogId;
    final content = _controller.text.trim();
    if (blogId == null || blogId <= 0 || content.isEmpty || _submitting) {
      return;
    }
    setState(() => _submitting = true);
    try {
      await ref
          .read(blogDanmakuRepoProvider)
          .createDanmaku(
            blogId: blogId,
            content: content,
            positionMillis: max(0, widget.positionMillisGetter()),
          );
      _controller.clear();
      ref.read(blogDanmakuRefreshProvider(blogId).notifier).state++;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.blogId == null) return const SizedBox.shrink();
    return Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                IconButton(
                  key: _emojiButtonKey,
                  onPressed: _toggleEmojiPanel,
                  tooltip: _emojiPicker.isVisible ? '键盘' : '表情',
                  icon: Icon(
                    _emojiPicker.isVisible
                        ? Icons.keyboard_outlined
                        : Icons.emoji_emotions_outlined,
                    color: Colors.white70,
                    size: 22,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    minLines: 1,
                    maxLines: 1,
                    maxLength: 80,
                    style: context.typo.body.copyWith(color: Colors.white),
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      hintText: widget.hintText,
                      hintStyle: context.typo.body.copyWith(
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.18),
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
          ),
          child: _submitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('发送'),
        ),
      ],
    );
  }
}

class _FlyingDanmaku {
  const _FlyingDanmaku({
    required this.key,
    required this.item,
    required this.lane,
  });

  final Key key;
  final BlogDanmakuItem item;
  final int lane;
}

class _FlyingDanmakuText extends StatefulWidget {
  const _FlyingDanmakuText({
    super.key,
    required this.text,
    required this.duration,
  });

  final String text;
  final Duration duration;

  @override
  State<_FlyingDanmakuText> createState() => _FlyingDanmakuTextState();
}

class _FlyingDanmakuTextState extends State<_FlyingDanmakuText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textWidth = (widget.text.length * 18.0).clamp(80.0, 360.0);
        final travel = constraints.maxWidth + textWidth + 24;
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                constraints.maxWidth - travel * _controller.value,
                0,
              ),
              child: child,
            );
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Text(
                  widget.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typo.bodyStrong.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                    shadows: const [
                      Shadow(color: Colors.black87, blurRadius: 4),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
