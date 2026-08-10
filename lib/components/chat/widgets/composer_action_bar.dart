import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_typography.dart';

class ComposerActionButton {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;
  final bool destructive;

  /// 开关类按钮选中态（如上下文、联网搜索）。
  final bool selected;

  const ComposerActionButton({
    required this.icon,
    required this.title,
    required this.onPressed,
    this.destructive = false,
    this.selected = false,
  });
}

class ComposerActionBar extends StatelessWidget {
  final List<ComposerActionButton> buttons;

  const ComposerActionBar({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var i = 0; i < buttons.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Builder(
                builder: (context) {
                  final button = buttons[i];
                  final Color? fg = button.destructive
                      ? Colors.red
                      : button.selected
                      ? primary
                      : null;
                  return OutlinedButton.icon(
                    icon: Icon(button.icon, color: fg, size: 18),
                    label: Text(
                      button.title,
                      style: context.typo.body.copyWith(color: fg),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: fg,
                      backgroundColor: button.selected
                          ? primary.withValues(alpha: 0.12)
                          : null,
                      side: button.selected
                          ? BorderSide(color: primary.withValues(alpha: 0.55))
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onPressed: button.onPressed,
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
