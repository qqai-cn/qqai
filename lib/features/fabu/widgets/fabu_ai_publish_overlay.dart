import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

/// 发布过程中的 AI 风格全屏进度遮罩。
class FabuAiPublishOverlay extends StatefulWidget {
  const FabuAiPublishOverlay({
    super.key,
    required this.progress,
    required this.stage,
  });

  final double progress;
  final String stage;

  @override
  State<FabuAiPublishOverlay> createState() => _FabuAiPublishOverlayState();
}

class _FabuAiPublishOverlayState extends State<FabuAiPublishOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _shimmerController;
  late final AnimationController _progressController;
  double _displayProgress = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _displayProgress = widget.progress.clamp(0.0, 1.0);
  }

  @override
  void didUpdateWidget(FabuAiPublishOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    final target = widget.progress.clamp(0.0, 1.0);
    if ((target - _displayProgress).abs() > 0.001) {
      _progressController.stop();
      _progressController.reset();
      final begin = _displayProgress;
      _progressController.addListener(() {
        setState(() {
          _displayProgress =
              lerpDouble(begin, target, _progressController.value) ?? target;
        });
      });
      _progressController.forward();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = (_displayProgress * 100).round().clamp(0, 100);
    final stage = widget.stage.isEmpty ? 'AI 正在处理中...' : widget.stage;

    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withValues(alpha: 0.55)),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final glow = 0.35 + _pulseController.value * 0.25;
                return Container(
                  constraints: const BoxConstraints(maxWidth: 340),
                  margin: const EdgeInsets.symmetric(horizontal: 28),
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF0B1020).withValues(alpha: 0.96),
                        const Color(0xFF151B33).withValues(alpha: 0.98),
                        const Color(0xFF1A1040).withValues(alpha: 0.96),
                      ],
                    ),
                    border: Border.all(
                      color: Color.lerp(
                        const Color(0xFF5B8CFF),
                        const Color(0xFFBC7CFF),
                        _pulseController.value,
                      )!.withValues(alpha: 0.45),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5B8CFF).withValues(alpha: glow),
                        blurRadius: 36,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: const Color(0xFFBC7CFF).withValues(alpha: glow * 0.6),
                        blurRadius: 48,
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _AiOrb(animation: _pulseController),
                  const SizedBox(height: 18),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF8EC5FF), Color(0xFFD4A8FF), Color(0xFF8EC5FF)],
                    ).createShader(bounds),
                    child: const Text(
                      'AI 发布中',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    stage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _AiProgressBar(
                    progress: _displayProgress,
                    shimmerAnimation: _shimmerController,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PROCESSING',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.42),
                          fontSize: 10,
                          letterSpacing: 1.6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$percent%',
                        style: const TextStyle(
                          color: Color(0xFF9ED0FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AiOrb extends StatelessWidget {
  const _AiOrb({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final scale = 0.92 + animation.value * 0.08;
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color.lerp(
                    const Color(0xFF7DD3FC),
                    const Color(0xFFC4B5FD),
                    animation.value,
                  )!,
                  const Color(0xFF312E81),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF60A5FA).withValues(alpha: 0.55),
                  blurRadius: 18 + animation.value * 10,
                ),
              ],
            ),
            child: Icon(
              Icons.auto_awesome,
              color: Colors.white.withValues(alpha: 0.92),
              size: 28,
            ),
          ),
        );
      },
    );
  }
}

class _AiProgressBar extends StatelessWidget {
  const _AiProgressBar({
    required this.progress,
    required this.shimmerAnimation,
  });

  final double progress;
  final Animation<double> shimmerAnimation;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final fillWidth = width * progress.clamp(0.0, 1.0);

        return ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  width: fillWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF38BDF8),
                        Color(0xFF818CF8),
                        Color(0xFFC084FC),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF818CF8).withValues(alpha: 0.55),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: shimmerAnimation,
                  builder: (context, _) {
                    final t = shimmerAnimation.value;
                    final shimmerX = (width + 80) * t - 80;
                    return Positioned(
                      left: shimmerX,
                      top: 0,
                      bottom: 0,
                      child: IgnorePointer(
                        child: Container(
                          width: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.white.withValues(alpha: 0),
                                Colors.white.withValues(alpha: 0.45),
                                Colors.white.withValues(alpha: 0),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (fillWidth > 6)
                  Positioned(
                    left: math.max(0, fillWidth - 8),
                    top: 1,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.95),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.8),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
