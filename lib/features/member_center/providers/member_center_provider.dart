import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/member_center_models.dart';
import '../data/member_center_repo.dart';

final memberCenterProvider = FutureProvider.autoDispose<MemberCenterData>((
  ref,
) {
  return ref.read(memberCenterRepoProvider).getMemberCenter();
});
