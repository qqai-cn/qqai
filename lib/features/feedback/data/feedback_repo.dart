import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constant/api_constant.dart';
import '../../../util/api_base_client.dart';

final feedbackRepoProvider = Provider<IFeedbackRepo>((ref) => FeedbackRepo());

abstract class IFeedbackRepo {
  Future<bool> submitFeedback({
    required int type,
    required String content,
    String? contact,
    String? appVersion,
    String? platform,
  });
}

class FeedbackRepo implements IFeedbackRepo {
  @override
  Future<bool> submitFeedback({
    required int type,
    required String content,
    String? contact,
    String? appVersion,
    String? platform,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.MEMBER_FEEDBACK_CREATE,
      RequestType.post,
      data: {
        'type': type,
        'content': content.trim(),
        if (contact != null && contact.trim().isNotEmpty)
          'contact': contact.trim(),
        if (appVersion != null && appVersion.trim().isNotEmpty)
          'appVersion': appVersion.trim(),
        if (platform != null && platform.trim().isNotEmpty)
          'platform': platform.trim(),
      },
    );
    final raw = response.data;
    if (raw is Map && raw['code'] == 0) {
      return true;
    }
    final msg = raw is Map ? (raw['msg'] as String?) : null;
    throw Exception(msg ?? '提交失败');
  }
}
