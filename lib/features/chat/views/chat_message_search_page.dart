import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/chat/data/models/chat_models.dart';
import 'package:qqai/features/chat/data/repos/chat_repo.dart';
import 'package:qqai/util/conversation_list_time_format.dart';

class ChatMessageSearchPage extends ConsumerStatefulWidget {
  const ChatMessageSearchPage({
    super.key,
    required this.conversationId,
    this.conversationTitle,
  });

  final int conversationId;
  final String? conversationTitle;

  @override
  ConsumerState<ChatMessageSearchPage> createState() =>
      _ChatMessageSearchPageState();
}

class _ChatMessageSearchPageState extends ConsumerState<ChatMessageSearchPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;
  List<ChatMessageDto> _results = [];
  bool _loading = false;
  bool _loadingMore = false;
  String? _error;
  String _keyword = '';
  int _pageNo = 1;
  bool _hasMore = true;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _loadingMore || !_hasMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 120) {
      _loadMore();
    }
  }

  void _onKeywordChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _search(value.trim());
    });
  }

  Future<void> _search(String keyword) async {
    if (keyword.isEmpty) {
      setState(() {
        _keyword = '';
        _results = [];
        _error = null;
        _loading = false;
        _hasMore = true;
        _pageNo = 1;
      });
      return;
    }

    setState(() {
      _keyword = keyword;
      _loading = true;
      _error = null;
      _pageNo = 1;
      _hasMore = true;
    });

    try {
      final page = await ref.read(chatRepoProvider).searchMessages(
            conversationId: widget.conversationId,
            keyword: keyword,
            pageNo: 1,
            pageSize: _pageSize,
          );
      if (!mounted || keyword != _keyword) return;
      final list = [...?page.list];
      setState(() {
        _results = list;
        _loading = false;
        _hasMore = list.length >= _pageSize;
        _pageNo = 2;
      });
    } catch (e) {
      if (!mounted || keyword != _keyword) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_keyword.isEmpty || _loading || _loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    try {
      final page = await ref.read(chatRepoProvider).searchMessages(
            conversationId: widget.conversationId,
            keyword: _keyword,
            pageNo: _pageNo,
            pageSize: _pageSize,
          );
      if (!mounted) return;
      final list = [...?page.list];
      setState(() {
        _results = [..._results, ...list];
        _loadingMore = false;
        _hasMore = list.length >= _pageSize;
        if (list.isNotEmpty) _pageNo++;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  void _openChat() {
    context.pop();
    if (context.canPop()) {
      context.pop();
    }
  }

  Widget _highlightText(String text) {
    final keyword = _keyword;
    if (keyword.isEmpty) {
      return Text(text, maxLines: 3, overflow: TextOverflow.ellipsis);
    }
    final lowerText = text.toLowerCase();
    final lowerKeyword = keyword.toLowerCase();
    final spans = <TextSpan>[];
    var start = 0;
    while (true) {
      final index = lowerText.indexOf(lowerKeyword, start);
      if (index < 0) {
        if (start < text.length) {
          spans.add(TextSpan(text: text.substring(start)));
        }
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(
        TextSpan(
          text: text.substring(index, index + keyword.length),
          style: const TextStyle(
            color: Color(0xFF1976D2),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
      start = index + keyword.length;
    }
    return RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(style: context.typo.body, children: spans),
    );
  }

  String _messagePreview(ChatMessageDto message) {
    final content = message.content?.trim();
    if (content != null && content.isNotEmpty) return content;
    return switch (message.type) {
      2 => '[图片]',
      3 => '[语音]',
      4 => '[文件]',
      5 => '[视频]',
      _ => '[消息]',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '搜索聊天内容',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
          onChanged: _onKeywordChanged,
          onSubmitted: _search,
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                _search('');
              },
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_keyword.isEmpty) {
      return Center(
        child: Text(
          '输入关键词查找聊天记录',
          style: context.typo.body.copyWith(color: Colors.grey[600]),
        ),
      );
    }
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('搜索失败', style: context.typo.body),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => _search(_keyword),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }
    if (_results.isEmpty) {
      return Center(
        child: Text(
          '未找到相关消息',
          style: context.typo.body.copyWith(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _results.length + (_loadingMore ? 1 : 0),
      separatorBuilder: (_, _) => const Divider(height: 1, indent: 16),
      itemBuilder: (context, index) {
        if (index >= _results.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final message = _results[index];
        return ListTile(
          title: _highlightText(_messagePreview(message)),
          subtitle: Text(
            formatConversationListTime(message.createTime),
            style: context.typo.caption.copyWith(color: Colors.grey[600]),
          ),
          onTap: _openChat,
        );
      },
    );
  }
}
