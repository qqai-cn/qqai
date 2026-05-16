import 'package:geolocator/geolocator.dart';

/// 读取当前位置；无权限或服务未开启时返回 null。
Future<({double latitude, double longitude})?> readBlogFeedGeoPosition() async {
  if (!await Geolocator.isLocationServiceEnabled()) {
    return null;
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return null;
  }

  final position = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.medium,
    ),
  );
  return (latitude: position.latitude, longitude: position.longitude);
}
