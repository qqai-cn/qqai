import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../blog/data/models/blog_page_model.dart';

class CommentListView extends ConsumerWidget {
  final BlogItem? blogItem; // 添加 blogItem 参数

  const CommentListView({super.key, this.blogItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            width: 400,
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
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
