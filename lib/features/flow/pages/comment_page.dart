import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../blog/domain/blog_page_model.dart';

class CommentPage extends ConsumerWidget {
  final BlogItem? blogItem;  // 添加 blogItem 参数

  const CommentPage({super.key, this.blogItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 现在可以使用 blogItem 了
    // 例如：blogItem?.id, blogItem?.content, blogItem?.zan 等

    return Material(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            width: 400,
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                // 标题栏 - 可以使用 blogItem 的数据
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '评论 (${blogItem?.zan ?? 128})',  // 使用 blogItem 的点赞数
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          // ref.read(commentPanelVisibleProvider.notifier).state = false;
                        },
                      ),
                    ],
                  ),
                ),

                // 评论列表
                Expanded(
                  child: ListView.builder(
                    itemCount: 30,
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
                        onPressed: () {
                          // 可以在这里使用 blogItem?.id 来提交评论
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}