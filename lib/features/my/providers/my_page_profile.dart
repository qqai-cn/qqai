import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/profile_models.dart';
import '../data/repos/profile_repo.dart';

part 'my_page_profile.g.dart';

@riverpod
Future<BlogMyPageResp> myPageProfile(Ref ref) async {
  return ref.watch(profileRepoProvider).getMyPage();
}
