import 'package:flutter/material.dart';

/// 头像外圈：固定渐变描边 + 呼吸光晕（不旋转）。
class ShinyAvatarRing extends StatefulWidget {
  const ShinyAvatarRing({
    super.key,
    required this.child,
    required this.size,
    this.ringWidth = 2.5,
  });

  final Widget child;
  final double size;
  final double ringWidth;

  @override
  State<ShinyAvatarRing> createState() => _ShinyAvatarRingState();
}

class _ShinyAvatarRingState extends State<ShinyAvatarRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final outerSize = widget.size + widget.ringWidth * 2;
    return SizedBox(
      width: outerSize + 6,
      height: outerSize + 6,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final pulse = Curves.easeInOut.transform(_pulseController.value);
          final glowAlpha = 0.28 + pulse * 0.32;
          final glowBlur = 5 + pulse * 7;
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: outerSize + 4,
                height: outerSize + 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFB74D).withValues(alpha: glowAlpha),
                      blurRadius: glowBlur,
                      spreadRadius: 0.5,
                    ),
                    BoxShadow(
                      color: const Color(0xFF5B8CFF).withValues(alpha: glowAlpha * 0.85),
                      blurRadius: glowBlur * 0.75,
                    ),
                  ],
                ),
              ),
              Container(
                width: outerSize,
                height: outerSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    startAngle: -0.8,
                    colors: [
                      Color(0xFFFFD54F),
                      Color(0xFFFF8A65),
                      Color(0xFFE53935),
                      Color(0xFFAB47BC),
                      Color(0xFF42A5F5),
                      Color(0xFF26C6DA),
                      Color(0xFFFFD54F),
                    ],
                    stops: [0.0, 0.16, 0.32, 0.48, 0.64, 0.82, 1.0],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(widget.ringWidth),
                  child: ClipOval(child: child),
                ),
              ),
            ],
          );
        },
        child: widget.child,
      ),
    );
  }
}
