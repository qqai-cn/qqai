import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/features/blog/views/blog_view.dart';

import '../providers/square_providers.dart';

class SquareBlogView extends ConsumerStatefulWidget {
  const SquareBlogView({super.key});

  @override
  ConsumerState<SquareBlogView> createState() => _SquareBlogViewState();
}

class _SquareBlogViewState extends ConsumerState<SquareBlogView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final squareState = ref.watch(squareProvider);
    final squareNotifier = ref.read(squareProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('万达广场')),
      body: BlogView(3),
    );
  }
}
