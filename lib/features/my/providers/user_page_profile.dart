import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/profile_models.dart';
import '../data/repos/profile_repo.dart';

final userPageProfileProvider =
    FutureProvider.family<BlogMyPageResp, int>((ref, userId) {
  return ref.read(profileRepoProvider).getUserPage(userId);
});
