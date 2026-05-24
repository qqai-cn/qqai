import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

const _sourceApplication = 'qqai';

/// 打开高德地图查看位置；优先唤起 App，失败则使用 uri.amap.com 网页。
Future<bool> openAmapLocation({
  double? latitude,
  double? longitude,
  String? name,
  String? keyword,
}) async {
  final poiName = name?.trim();
  final label = (poiName != null && poiName.isNotEmpty) ? poiName : '位置';
  final hasCoord = _isValidCoord(latitude, longitude);

  if (hasCoord) {
    final lat = latitude!;
    final lon = longitude!;
    final appUri = _buildViewMapUri(lat: lat, lon: lon, poiname: label);
    final webUri = Uri.parse(
      'https://uri.amap.com/marker?position=$lon,$lat&name=${Uri.encodeComponent(label)}',
    );
    return _launchAmap(appUri: appUri, webUri: webUri);
  }

  final kw = keyword?.trim();
  if (kw == null || kw.isEmpty) return false;

  final appUri = _buildPoiSearchUri(keyword: kw);
  final webUri = Uri.parse(
    'https://uri.amap.com/search?query=${Uri.encodeComponent(kw)}',
  );
  return _launchAmap(appUri: appUri, webUri: webUri);
}

bool _isValidCoord(double? lat, double? lon) {
  if (lat == null || lon == null || lat.isNaN || lon.isNaN) return false;
  return lat.abs() <= 90 && lon.abs() <= 180;
}

Uri? _buildViewMapUri({
  required double lat,
  required double lon,
  required String poiname,
}) {
  if (kIsWeb) return null;
  if (Platform.isIOS) {
    return Uri(
      scheme: 'iosamap',
      host: 'viewMap',
      queryParameters: {
        'sourceApplication': _sourceApplication,
        'poiname': poiname,
        'lat': lat.toString(),
        'lon': lon.toString(),
        'dev': '0',
      },
    );
  }
  if (Platform.isAndroid) {
    return Uri(
      scheme: 'androidamap',
      host: 'viewMap',
      queryParameters: {
        'sourceApplication': _sourceApplication,
        'poiname': poiname,
        'lat': lat.toString(),
        'lon': lon.toString(),
        'dev': '0',
      },
    );
  }
  return null;
}

Uri? _buildPoiSearchUri({required String keyword}) {
  if (kIsWeb) return null;
  if (Platform.isIOS) {
    return Uri(
      scheme: 'iosamap',
      host: 'poi',
      queryParameters: {
        'sourceApplication': _sourceApplication,
        'keywords': keyword,
      },
    );
  }
  if (Platform.isAndroid) {
    return Uri(
      scheme: 'androidamap',
      host: 'poi',
      queryParameters: {
        'sourceApplication': _sourceApplication,
        'keywords': keyword,
      },
    );
  }
  return null;
}

Future<bool> _launchAmap({Uri? appUri, required Uri webUri}) async {
  if (appUri != null) {
    if (await canLaunchUrl(appUri)) {
      final ok = await launchUrl(appUri, mode: LaunchMode.externalApplication);
      if (ok) return true;
    }
  }
  if (await canLaunchUrl(webUri)) {
    return launchUrl(webUri, mode: LaunchMode.externalApplication);
  }
  return false;
}
