import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constant/constant.dart';
import '../presentation/providers/square_providers.dart';
import '../views/square_item_view.dart';

class SquareView extends ConsumerWidget {
  const SquareView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final squareState = ref.watch(squareProvider);
    
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400.0,
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 1.0,
        childAspectRatio: 1.sw > Constant.SQUARE_SPLIT_WIDTH ? 5 / 4 : 5 / 4,
      ),
      itemCount: squareState.items.length,
      itemBuilder: (context, index) {
        return SquareItemView();
      },
    );
  }
}
