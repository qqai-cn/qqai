import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/blog/providers/blog_providers.dart';

class CommentPanel extends ConsumerWidget {
  const CommentPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 400,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // 标题栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  '评论 (128)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    // 关闭面板（Riverpod 或 ValueNotifier）
                    ref.read(commentPanelVisibleProvider.notifier).state = false;
                  },
                ),
              ],
            ),
          ),

          // 评论列表
          Expanded(
            child: ListView.builder(
              itemCount: 30, // 实际替换成你的评论数据
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text('用户 ${index + 1}'),
                  subtitle: Text('这条评论超级有意思啊哈哈哈～'),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                );
              },
            ),
          ),

          // 输入框
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: '写下你的评论...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
