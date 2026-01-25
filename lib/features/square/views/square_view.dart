import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qqai/features/square/views/square_item_view.dart';

import '../../../constant/constant.dart';
import '../providers/square_providers.dart';

class SquareView extends ConsumerStatefulWidget {
  const SquareView({super.key});

  @override
  ConsumerState<SquareView> createState() => _SquareViewState();
}

class _SquareViewState extends ConsumerState<SquareView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final squareState = ref.watch(squareProvider);
    final squareNotifier = ref.read(squareProvider.notifier);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400.0,
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 1.0,
        childAspectRatio: 1.sw > Constant.SQUARE_SPLIT_WIDTH ? 5 / 4 : 5 / 4,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return SquareItemView();
      },
    );
  }
}
