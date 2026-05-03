import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constant/api_constant.dart';
import '../../../util/api_base_client.dart';
import 'friend_models.dart';

final friendRepoProvider = Provider<IFriendRepo>((ref) => FriendRepo());

abstract class IFriendRepo {
  Future<bool> updateRemark({
    required int friendUserId,
    required String remark,
  });

  Future<List<FriendPendingDto>> listPendingIncoming();

  Future<List<FriendPendingDto>> listPendingOutgoing();

  Future<List<FriendLetterGroupDto>> listFriendsGrouped();

  Future<bool> applyFriend({
    required int friendUserId,
    String? applyMessage,
  });

  Future<bool> acceptFriend({required int applicantUserId});

  Future<bool> rejectFriend({required int applicantUserId});

  Future<bool> deleteFriend({required int friendUserId});
}

void _ensureOk(Map<String, dynamic> root) {
  final code = root['code'];
  if (code != null && code != 0) {
    throw Exception(root['msg']?.toString() ?? '业务错误');
  }
}

class FriendRepo implements IFriendRepo {
  @override
  Future<bool> updateRemark({
    required int friendUserId,
    required String remark,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.FRIEND_REMARK,
      RequestType.put,
      data: {
        'friendUserId': friendUserId,
        'remark': remark,
      },
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _ensureOk(root);
    return root['data'] == true;
  }

  @override
  Future<List<FriendPendingDto>> listPendingIncoming() async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.FRIEND_PENDING_INCOMING,
      RequestType.get,
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _ensureOk(root);
    final data = root['data'];
    if (data is! List) return [];
    return data
        .map(
          (e) => FriendPendingDto.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }

  @override
  Future<List<FriendPendingDto>> listPendingOutgoing() async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.FRIEND_PENDING_OUTGOING,
      RequestType.get,
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _ensureOk(root);
    final data = root['data'];
    if (data is! List) return [];
    return data
        .map(
          (e) => FriendPendingDto.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }

  @override
  Future<List<FriendLetterGroupDto>> listFriendsGrouped() async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.FRIEND_LIST_GROUPED,
      RequestType.get,
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _ensureOk(root);
    final data = root['data'];
    if (data is! List) return [];
    return data
        .map(
          (e) =>
              FriendLetterGroupDto.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }

  @override
  Future<bool> applyFriend({
    required int friendUserId,
    String? applyMessage,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.FRIEND_APPLY,
      RequestType.post,
      data: {
        'friendUserId': friendUserId,
        if (applyMessage != null && applyMessage.isNotEmpty)
          'applyMessage': applyMessage,
      },
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _ensureOk(root);
    return root['data'] == true;
  }

  @override
  Future<bool> acceptFriend({required int applicantUserId}) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.FRIEND_ACCEPT,
      RequestType.post,
      data: {'applicantUserId': applicantUserId},
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _ensureOk(root);
    return root['data'] == true;
  }

  @override
  Future<bool> rejectFriend({required int applicantUserId}) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.FRIEND_REJECT,
      RequestType.post,
      data: {'applicantUserId': applicantUserId},
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _ensureOk(root);
    return root['data'] == true;
  }

  @override
  Future<bool> deleteFriend({required int friendUserId}) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.FRIEND_DELETE,
      RequestType.delete,
      queryParameters: {'friendUserId': friendUserId},
    );
    final root = Map<String, dynamic>.from(response.data as Map);
    _ensureOk(root);
    return root['data'] == true;
  }
}
