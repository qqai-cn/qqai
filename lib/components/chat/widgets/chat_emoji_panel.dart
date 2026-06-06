import 'package:flutter/material.dart';

const Map<String, List<String>> kChatEmojiCategories = {
  '笑脸': [
    '😀', '😁', '😂', '🤣', '😊', '😍', '🥰', '😘', '😋', '😜',
    '🤔', '😐', '😑', '🙄', '😏', '😣', '😥', '😮', '😴', '😌',
    '😛', '😝', '😒', '😔', '😕', '🙃', '🙂', '😲', '☹️', '😖',
    '😞', '😟', '😤', '😢', '😭', '😦', '😧', '😨', '😩', '🤯',
    '😬', '😰', '😱', '🥵', '🥶', '😳', '🤪', '😵', '🥴', '😠',
    '😡', '🤬',
  ],
  '手势': [
    '👍', '👎', '👏', '🙌', '🤝', '🙏', '💪', '✌️', '🤞', '🤟',
    '👌', '🤌', '👋', '🤙', '👊', '✊', '🫶', '🤲', '👐', '🫰',
  ],
  '爱心': [
    '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍', '🤎', '💔',
    '💕', '💞', '💓', '💗', '💖', '💘', '💝', '💟', '❣️', '💌',
  ],
  '庆祝': [
    '🎉', '🎊', '🎈', '🎁', '🎂', '🍰', '🥳', '✨', '⭐', '🌟',
    '💫', '🔥', '💯', '🏆', '🥇', '🎯', '🎮', '🎵', '🎶', '🎤',
  ],
  '日常': [
    '💬', '💭', '🗨️', '👀', '💤', '🍀', '🌈', '☀️', '🌙', '⚡',
    '☕', '🍺', '🍻', '🍜', '🍔', '🍕', '🍎', '🍉', '🐶', '🐱',
    '🌹', '🌸', '🌻', '🍀', '🌍', '🚗', '✈️', '🏠', '📱', '💻',
  ],
};

typedef ChatEmojiSelected = void Function(String emoji);

/// 聊天输入框上方的表情选择面板。
class ChatEmojiPanel extends StatefulWidget {
  const ChatEmojiPanel({
    super.key,
    required this.onEmojiSelected,
    this.darkOverlay = false,
  });

  final ChatEmojiSelected onEmojiSelected;

  /// 深色背景（弹幕、视频浮层等）下使用浅色控件。
  final bool darkOverlay;

  @override
  State<ChatEmojiPanel> createState() => _ChatEmojiPanelState();
}

class _ChatEmojiPanelState extends State<ChatEmojiPanel> {
  late String _category;

  @override
  void initState() {
    super.initState();
    _category = kChatEmojiCategories.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    final emojis = kChatEmojiCategories[_category] ?? const <String>[];
    final dark = widget.darkOverlay;
    final bg = dark
        ? Colors.white.withValues(alpha: 0.08)
        : Theme.of(context).colorScheme.surfaceContainerLow;

    return Material(
      color: bg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: kChatEmojiCategories.keys.map((name) {
                final selected = name == _category;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(name),
                    selected: selected,
                    onSelected: (_) => setState(() => _category = name),
                    visualDensity: VisualDensity.compact,
                    selectedColor: dark
                        ? Colors.white.withValues(alpha: 0.22)
                        : null,
                    backgroundColor: dark
                        ? Colors.white.withValues(alpha: 0.06)
                        : null,
                    labelStyle: TextStyle(
                      fontSize: 13,
                      color: dark
                          ? (selected ? Colors.white : Colors.white70)
                          : (selected ? Colors.white : Colors.black),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            height: 180,
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: emojis.length,
              itemBuilder: (context, index) {
                final emoji = emojis[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => widget.onEmojiSelected(emoji),
                    child: Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
