import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/profile_models.dart';
import '../data/repos/profile_repo.dart';

part 'my_shop_profile.g.dart';

@riverpod
Future<BlogShopResp?> myShopProfile(Ref ref) async {
  return ref.watch(profileRepoProvider).getMyShop();
}
