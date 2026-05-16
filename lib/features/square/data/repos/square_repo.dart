import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constant/api_constant.dart';
import '../../../../util/api_base_client.dart';
import '../../../blog/data/blog_page_parse.dart';
import '../../../blog/data/models/blog_page_model.dart';
import '../models/square_create_req_vo.dart';
import '../models/square_model.dart';
import '../square_parse.dart';

final squareRepoProvider = Provider<ISquareRepo>((ref) => SquareRepo());

abstract class ISquareRepo {
  Future<SquarePageData> getSquarePage(
    int pageNo, {
    int pageSize = 20,
    String? squareName,
  });

  Future<List<SquareItem>> getSquareList();

  Future<SquareItem> getSquareDetail(int squareId);

  Future<BlogPageModelData> getSquareBlogsPage(
    int squareId,
    int pageNo, {
    int pageSize = 10,
  });

  Future<SquareConversationJoinResult> joinSquareConversation(int squareId);

  Future<SquareItem> createSquare(SquareCreateReqVO req);
}

class SquareRepo implements ISquareRepo {
  @override
  Future<SquarePageData> getSquarePage(
    int pageNo, {
    int pageSize = 20,
    String? squareName,
  }) async {
    final query = <String, dynamic>{
      'pageNo': pageNo,
      'pageSize': pageSize,
    };
    final name = squareName?.trim();
    if (name != null && name.isNotEmpty) {
      query['squareName'] = name;
    }
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.SQUARE_PAGE,
      RequestType.get,
      queryParameters: query,
    );
    return parseSquarePageEnvelope(response.data);
  }

  @override
  Future<List<SquareItem>> getSquareList() async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.SQUARE_LIST,
      RequestType.get,
    );
    return parseSquareListEnvelope(response.data);
  }

  @override
  Future<SquareItem> getSquareDetail(int squareId) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.squareDetailPath(squareId),
      RequestType.get,
    );
    return parseSquareDetailEnvelope(response.data);
  }

  @override
  Future<BlogPageModelData> getSquareBlogsPage(
    int squareId,
    int pageNo, {
    int pageSize = 10,
  }) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.squareBlogsPagePath(squareId),
      RequestType.get,
      queryParameters: {
        'pageNo': pageNo,
        'pageSize': pageSize,
        'squareId': squareId,
      },
    );
    return parseBlogPageEnvelope(
      response.data,
      errorMessage: '广场博客分页返回格式错误',
    );
  }

  @override
  Future<SquareConversationJoinResult> joinSquareConversation(
    int squareId,
  ) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.squareJoinConversationPath(squareId),
      RequestType.post,
    );
    return parseSquareJoinConversationEnvelope(response.data);
  }

  @override
  Future<SquareItem> createSquare(SquareCreateReqVO req) async {
    final response = await ApiBaseClient.safeApiCall(
      ApiConstant.SQUARE_CREATE,
      RequestType.post,
      data: req.toJson(),
    );
    return parseSquareDetailEnvelope(
      response.data,
      errorMessage: '创建广场返回格式错误',
    );
  }
}
