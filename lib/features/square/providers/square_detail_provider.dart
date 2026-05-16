import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/square_model.dart';
import '../data/repos/square_repo.dart';

part 'square_detail_provider.g.dart';

@Riverpod(keepAlive: true)
class SquareDetail extends _$SquareDetail {
  @override
  Future<SquareItem> build(int squareId) async {
    if (squareId <= 0) {
      throw '无效的广场';
    }
    return ref.read(squareRepoProvider).getSquareDetail(squareId);
  }
}
