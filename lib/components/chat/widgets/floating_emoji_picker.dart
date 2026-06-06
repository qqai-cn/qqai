import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qqai/components/chat/widgets/chat_emoji_panel.dart';

/// 在 [controller] 当前光标处插入 [text]；超出 [maxLength] 时返回 false。
bool insertTextAtSelection(
  TextEditingController controller,
  String text, {
  int? maxLength,
}) {
  final value = controller.text;
  final selection = controller.selection;
  final start = selection.start >= 0 ? selection.start : value.length;
  final end = selection.end >= 0 ? selection.end : value.length;
  final newText = value.replaceRange(start, end, text);
  if (maxLength != null && newText.length > maxLength) return false;
  controller.value = controller.value.copyWith(
    text: newText,
    selection: TextSelection.collapsed(offset: start + text.length),
    composing: TextRange.empty,
  );
  return true;
}

/// 锚定在按钮上方的表情浮窗。
class FloatingEmojiPickerController {
  FloatingEmojiPickerController({
    required this.onEmojiSelected,
    this.darkOverlay = false,
    this.closeOnSelect = true,
    this.onVisibilityChanged,
  });

  final ValueChanged<String> onEmojiSelected;
  final bool darkOverlay;
  final bool closeOnSelect;
  final VoidCallback? onVisibilityChanged;

  static const panelHeight = 220.0;

  OverlayEntry? _overlay;

  bool get isVisible => _overlay != null;

  void dispose() => hide();

  void hide() {
    if (_overlay == null) return;
    _overlay!.remove();
    _overlay = null;
    onVisibilityChanged?.call();
  }

  void toggle(BuildContext context, GlobalKey anchorKey) {
    if (isVisible) {
      hide();
      return;
    }
    show(context, anchorKey);
  }

  void show(BuildContext context, GlobalKey anchorKey) {
    hide();

    final renderBox = anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final overlayState = Overlay.maybeOf(context);
    if (overlayState == null) return;

    final buttonOrigin = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final safeTop = mediaQuery.padding.top;
    final panelWidth = min(screenSize.width - 24, 360.0);
    var left = buttonOrigin.dx;
    var top = buttonOrigin.dy - panelHeight - 8;

    left = left.clamp(12.0, screenSize.width - panelWidth - 12);
    if (top < safeTop + 8) {
      top = buttonOrigin.dy + buttonSize.height + 8;
    }

    _overlay = OverlayEntry(
      builder: (overlayContext) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: hide,
              ),
            ),
            Positioned(
              left: left,
              top: top,
              width: panelWidth,
              child: Material(
                color: Colors.transparent,
                elevation: 10,
                shadowColor: Colors.black54,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: darkOverlay
                        ? Colors.black.withValues(alpha: 0.9)
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: darkOverlay
                          ? Colors.white.withValues(alpha: 0.12)
                          : Theme.of(context)
                              .colorScheme
                              .outlineVariant
                              .withValues(alpha: 0.5),
                    ),
                  ),
                  child: ChatEmojiPanel(
                    darkOverlay: darkOverlay,
                    onEmojiSelected: (emoji) {
                      onEmojiSelected(emoji);
                      if (closeOnSelect) hide();
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlayState.insert(_overlay!);
    onVisibilityChanged?.call();
  }
}
