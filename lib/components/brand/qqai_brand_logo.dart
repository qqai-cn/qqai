import 'package:flutter/material.dart';

/// AppBar / 品牌区同款：旋转的千千 logo（`imgs/qqai_logo.png`）。
class QqaiBrandLogo extends StatefulWidget {
  const QqaiBrandLogo({
    super.key,
    this.size = 28,
    this.borderRadius,
    this.duration = const Duration(seconds: 12),
  });

  final double size;
  final BorderRadius? borderRadius;
  final Duration duration;

  @override
  State<QqaiBrandLogo> createState() => _QqaiBrandLogoState();
}

class _QqaiBrandLogoState extends State<QqaiBrandLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotateController;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant QqaiBrandLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _rotateController.duration = widget.duration;
      if (!_rotateController.isAnimating) {
        _rotateController.repeat();
      }
    }
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(6);
    return RotationTransition(
      turns: _rotateController,
      child: ClipRRect(
        borderRadius: radius,
        child: Image.asset(
          'imgs/qqai_logo.png',
          width: widget.size,
          height: widget.size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.auto_awesome,
            size: widget.size,
          ),
        ),
      ),
    );
  }
}
