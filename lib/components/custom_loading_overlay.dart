import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';

import '../../config/translations/strings_enum.dart';

/// this method will show black overlay which look like dialog
/// and it will have loading animation inside of it
/// this will make sure user cant interact with ui until
/// any (async) method is executing cuz it will wait for async function
/// to end and then it will dismiss the overlay
Future<void> showLoadingOverLay({
  required BuildContext context,
  required Future<dynamic> Function() asyncFunction,
  String? msg,
}) async {
  // 显示加载对话框
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (context) => Center(
      child: _getLoadingIndicator(msg: msg),
    ),
  );

  try {
    await asyncFunction();
  } catch (error) {
    Logger().e(error);
    Logger().e(StackTrace.current);
  } finally {
    // 关闭加载对话框
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

Widget _getLoadingIndicator({String? msg}) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 20.w,
      vertical: 10.h,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.r),
      color: Colors.white,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/app_icon.png', height: 45.h),
        SizedBox(width: 8.h),
        Text(
          msg ?? Strings.loading,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}
