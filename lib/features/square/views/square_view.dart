import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qqai/features/square/views/square_item_view.dart';

import '../providers/square_providers.dart';

class SquareView extends ConsumerStatefulWidget {
  const SquareView({super.key});

  @override
  ConsumerState<SquareView> createState() => _SquareViewState();
}

class _SquareViewState extends ConsumerState<SquareView> {
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

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Column(
        children: [
          Container(height: 50, color: Colors.green[50]),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 500.0,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                childAspectRatio: 3 / 2,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return SquareItemView();
              },
            ),
          ),
        ],
      ),
    );
  }
}
