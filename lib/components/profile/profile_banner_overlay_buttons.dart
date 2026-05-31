import 'package:flutter/material.dart';

/// 他人主页封面顶栏按钮：实心白 icon + 半透明灰圆底。
class ProfileBannerOverlayIcon extends StatelessWidget {
  const ProfileBannerOverlayIcon({super.key, required this.icon});

  final IconData icon;

  static const double buttonSize = 40;
  static const double iconSize = 22;
  static const Color backgroundColor = Color(0x99666666);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: iconSize),
    );
  }
}

/// 他人主页封面顶栏返回按钮。
class ProfileBannerOverlayBackButton extends StatelessWidget {
  const ProfileBannerOverlayBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      icon: const ProfileBannerOverlayIcon(icon: Icons.arrow_back_ios_new),
    );
  }
}

/// 他人主页封面顶栏更多按钮图标。
class ProfileBannerOverlayMoreIcon extends StatelessWidget {
  const ProfileBannerOverlayMoreIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileBannerOverlayIcon(icon: Icons.more_horiz);
  }
}

/// 他人主页封面顶栏更多按钮。
class ProfileBannerOverlayMoreButton extends StatelessWidget {
  const ProfileBannerOverlayMoreButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      icon: const ProfileBannerOverlayMoreIcon(),
    );
  }
}
