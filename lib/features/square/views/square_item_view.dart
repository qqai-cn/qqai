import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../router/app_routes.dart';
import '../../../util/format_count.dart';
import '../../../util/media_url.dart';
import '../data/models/square_model.dart';
import '../providers/square_providers.dart';
import 'square_grid_layout.dart';

Widget _squareOwnerAvatar(String? avatarUrl, double size) {
  const fallback = 'imgs/img_default.png';
  if (avatarUrl == null) {
    return Image.asset(fallback, width: size, height: size, fit: BoxFit.cover);
  }
  return CachedNetworkImage(
    imageUrl: avatarUrl,
    width: size,
    height: size,
    fit: BoxFit.cover,
    errorWidget: (_, _, _) =>
        Image.asset(fallback, width: size, height: size, fit: BoxFit.cover),
  );
}

class SquareItemView extends ConsumerWidget {
  const SquareItemView({super.key, required this.square});

  final SquareItem square;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coverUrl =
        resolveMediaUrl(square.squareImg) ??
        'https://file.qqai.cn/qqai/2025/09/square.webp';
    final avatarUrl = resolveMediaUrl(square.userAvatar);
    final title = (square.squareName?.trim().isNotEmpty ?? false)
        ? square.squareName!.trim()
        : '广场';
    final squareDesc = (square.squareDesc?.trim().isNotEmpty ?? false)
        ? square.squareDesc!.trim()
        : '暂无描述';
    final worksText = '${formatCompactCount(square.blogCount?.toInt())} 作品';
    final heatText = formatCompactCount(square.followCount?.toInt());
    final squareId = square.id;
    final followed = square.followedByMe == true;

    void onFollowTap() {
      if (squareId == null) return;
      ref.read(squareProvider.notifier).toggleFollow(square);
    }

    void onCardTap() {
      if (squareId == null) return;
      context.push(Routes.squareBlogView, extra: squareId);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileW = constraints.maxWidth;
        final density = squareTileDensity(tileW);
        final footerH = squareFooterHeight(density);
        final avatarSize = _avatarSize(density);

        return _SquareCardShell(
          onTap: squareId == null ? null : onCardTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _SquareCoverSection(
                  imageUrl: coverUrl,
                  tileWidth: tileW,
                  worksText: worksText,
                  heatText: heatText,
                ),
              ),
              SizedBox(
                height: footerH,
                child: _SquareFooter(
                  density: density,
                  title: title,
                  desc: squareDesc,
                  followed: followed,
                  avatarSize: avatarSize,
                  avatar: _squareOwnerAvatar(avatarUrl, avatarSize),
                  onFollowTap: onFollowTap,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _avatarSize(SquareTileDensity density) {
    return switch (density) {
      SquareTileDensity.compact => 28,
      SquareTileDensity.normal => 34,
      SquareTileDensity.comfortable => 38,
    };
  }
}

class _SquareCardShell extends StatefulWidget {
  const _SquareCardShell({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<_SquareCardShell> createState() => _SquareCardShellState();
}

class _SquareCardShellState extends State<_SquareCardShell> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final elevated = kIsWeb && _hovered;

    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: elevated ? const Color(0xFFCBD5E1) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: elevated ? 0.1 : 0.05),
            blurRadius: elevated ? 18 : 10,
            offset: Offset(0, elevated ? 8 : 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          splashColor: const Color(0xFF3578E5).withValues(alpha: 0.08),
          highlightColor: const Color(0xFF3578E5).withValues(alpha: 0.04),
          child: widget.child,
        ),
      ),
    );

    if (!kIsWeb) return card;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: card,
    );
  }
}

class _SquareCoverSection extends StatelessWidget {
  const _SquareCoverSection({
    required this.imageUrl,
    required this.tileWidth,
    required this.worksText,
    required this.heatText,
  });

  final String imageUrl;
  final double tileWidth;
  final String worksText;
  final String heatText;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cacheWidth = (tileWidth * dpr).round().clamp(96, 1200);

    return Stack(
      fit: StackFit.expand,
      children: [
        _SquareCover(imageUrl: imageUrl, cacheWidth: cacheWidth),
        const Positioned.fill(child: _CoverScrim()),
        Positioned(
          left: 10,
          bottom: 10,
          child: _CoverBadge(
            text: worksText,
            icon: Icons.collections_outlined,
          ),
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: _CoverBadge(
            text: '热度 $heatText',
            icon: Icons.local_fire_department_outlined,
          ),
        ),
      ],
    );
  }
}

class _SquareCover extends StatelessWidget {
  const _SquareCover({required this.imageUrl, this.cacheWidth});

  final String imageUrl;
  final int? cacheWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFFE2E8F0)),
        Image(
          image: CachedNetworkImageProvider(imageUrl, maxWidth: cacheWidth),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          gaplessPlayback: true,
          filterQuality: FilterQuality.medium,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) return child;
            return const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (_, _, _) => ColoredBox(
            color: Colors.grey.shade300,
            child: Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CoverScrim extends StatelessWidget {
  const _CoverScrim();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.5),
          ],
          stops: const [0.5, 1],
        ),
      ),
    );
  }
}

class _CoverBadge extends StatelessWidget {
  const _CoverBadge({required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: Colors.white.withValues(alpha: 0.92)),
            const SizedBox(width: 4),
            Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.95),
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SquareFooter extends StatelessWidget {
  const _SquareFooter({
    required this.density,
    required this.title,
    required this.desc,
    required this.followed,
    required this.avatarSize,
    required this.avatar,
    required this.onFollowTap,
  });

  final SquareTileDensity density;
  final String title;
  final String desc;
  final bool followed;
  final double avatarSize;
  final Widget avatar;
  final VoidCallback onFollowTap;

  @override
  Widget build(BuildContext context) {
    final horizontal = switch (density) {
      SquareTileDensity.compact => 10.0,
      SquareTileDensity.normal => 11.0,
      SquareTileDensity.comfortable => 12.0,
    };
    final showDesc = density != SquareTileDensity.compact;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ClipOval(
                child: SizedBox(
                  width: avatarSize,
                  height: avatarSize,
                  child: avatar,
                ),
              ),
            ),
            SizedBox(width: density == SquareTileDensity.comfortable ? 10 : 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF0F172A),
                      fontSize: density == SquareTileDensity.compact ? 13.5 : 14.5,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (showDesc) ...[
                    const SizedBox(height: 2),
                    Text(
                      desc,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11.5,
                        height: 1.2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 6),
            _FollowControl(
              density: density,
              followed: followed,
              onTap: onFollowTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _FollowControl extends StatelessWidget {
  const _FollowControl({
    required this.density,
    required this.followed,
    required this.onTap,
  });

  final SquareTileDensity density;
  final bool followed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (density == SquareTileDensity.compact) {
      return _FollowIconButton(followed: followed, onTap: onTap, size: 30);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          decoration: BoxDecoration(
            color: followed ? Colors.white : const Color(0xFF3578E5),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: followed ? const Color(0xFFCBD5E1) : const Color(0xFF3578E5),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: density == SquareTileDensity.normal ? 10 : 14,
              vertical: 5,
            ),
            child: Text(
              followed ? '已关注' : '+ 关注',
              style: TextStyle(
                color: followed ? const Color(0xFF64748B) : Colors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FollowIconButton extends StatelessWidget {
  const _FollowIconButton({
    required this.followed,
    required this.onTap,
    required this.size,
  });

  final bool followed;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: followed ? Colors.white : const Color(0xFF3578E5),
            border: Border.all(
              color: followed ? const Color(0xFFCBD5E1) : const Color(0xFF3578E5),
            ),
          ),
          child: Icon(
            followed ? Icons.check_rounded : Icons.add_rounded,
            size: size * 0.52,
            color: followed ? const Color(0xFF64748B) : Colors.white,
          ),
        ),
      ),
    );
  }
}
