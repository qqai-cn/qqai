import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/auth_providers.dart';
import '../data/models/profile_models.dart';
import '../data/repos/profile_repo.dart';

part 'my_page_profile.g.dart';

@riverpod
Future<BlogMyPageResp> myPageProfile(Ref ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) {
    throw StateError('未登录');
  }
  return ref.read(profileRepoProvider).getMyPage();
}
