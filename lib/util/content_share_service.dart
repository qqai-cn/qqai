import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web/web.dart' as web;

import '../components/blog/network_image_carousel_pages.dart';
import '../constant/api_constant.dart';
import '../features/blog/data/models/blog_page_model.dart';
import '../router/app_routes.dart';
import 'media_url.dart';

/// 分享到外部渠道时使用的标题、摘要、链接与封面。
class ContentSharePayload {
  const ContentSharePayload({
    required this.title,
    required this.summary,
    required this.url,
    this.imageUrl,
  });

  final String title;
  final String summary;
  final String url;
  final String? imageUrl;
}

ContentSharePayload buildBlogSharePayload(BlogItem blog) {
  final creator = blog.creatorName?.trim();
  final titleRaw = blog.title?.trim();
  final title = (titleRaw != null && titleRaw.isNotEmpty)
      ? titleRaw
      : ((creator != null && creator.isNotEmpty) ? '@$creator 的作品' : '千千Ai 精彩内容');

  final content = blog.content?.replaceAll(RegExp(r'\s+'), ' ').trim() ?? '';
  final summary = content.isNotEmpty
      ? (content.length > 120 ? '${content.substring(0, 120)}…' : content)
      : '来自千千Ai的精彩内容，快来看看吧';

  final cover = resolveMediaUrl(resolveBlogCoverUrl(blog));
  return ContentSharePayload(
    title: title,
    summary: summary,
    url: buildBlogShareUrl(blog),
    imageUrl: cover,
  );
}

String buildBlogShareUrl(BlogItem blog) {
  final id = blog.id;
  if (id == null || id <= 0) return ApiConstant.BASE_URL;
  final path = blog.blogType == 2
      ? Routes.blogVideoDetailView
      : Routes.blogImgDetailView;
  if (kIsWeb) {
    final origin = Uri.base.origin;
    if (origin.isNotEmpty) {
      return '$origin$path?id=$id';
    }
  }
  return '${ApiConstant.BASE_URL}$path?id=$id';
}

bool isWeChatInAppBrowser() {
  if (!kIsWeb) return false;
  final ua = web.window.navigator.userAgent.toLowerCase();
  return ua.contains('micromessenger');
}

Future<bool> shareToWechatFriend(
  BuildContext context,
  ContentSharePayload payload,
) async {
  if (isWeChatInAppBrowser()) {
    if (!context.mounted) return false;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('分享到微信好友'),
        content: const Text('请点击右上角「···」，选择「发送给朋友」或「分享到朋友圈」。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
    return true;
  }

  final text = '${payload.title}\n${payload.url}';
  await Clipboard.setData(ClipboardData(text: text));

  if (!kIsWeb) {
    final wechatUri = Uri.parse('weixin://');
    if (await canLaunchUrl(wechatUri)) {
      await launchUrl(wechatUri, mode: LaunchMode.externalApplication);
    }
  }

  if (context.mounted) {
    _showShareSnackBar(
      context,
      kIsWeb ? '链接已复制，请打开微信粘贴发送给好友' : '链接已复制，请在微信中粘贴发送给好友',
    );
  }
  return true;
}

Future<bool> shareToQqFriend(
  BuildContext context,
  ContentSharePayload payload,
) async {
  final query = <String, String>{
    'url': payload.url,
    'title': payload.title,
    'summary': payload.summary,
  };
  final image = payload.imageUrl?.trim();
  if (image != null && image.isNotEmpty) {
    query['pics'] = image;
  }

  final shareUri = Uri.https('connect.qq.com', '/widget/shareqq/index.html', query);
  final launched = await launchUrl(
    shareUri,
    mode: LaunchMode.externalApplication,
    webOnlyWindowName: '_blank',
  );
  if (!launched && context.mounted) {
    _showShareSnackBar(context, '无法打开 QQ 分享，请稍后重试');
  }
  return launched;
}

Future<bool> copyShareLink(
  BuildContext context,
  ContentSharePayload payload,
) async {
  await Clipboard.setData(ClipboardData(text: payload.url));
  if (context.mounted) {
    _showShareSnackBar(context, '链接已复制');
  }
  return true;
}

String buildAppFriendShareText(ContentSharePayload payload) {
  return '${payload.title}\n${payload.url}';
}

void _showShareSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
}
