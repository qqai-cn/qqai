import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_typography.dart';

class CustomSnackBar {
  static void showCustomSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: context.typo.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    message,
                    style: context.typo.body.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        duration: duration ?? const Duration(seconds: 3),
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );
  }

  static void showCustomErrorSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    Color? color,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: context.typo.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    message,
                    style: context.typo.body.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        duration: duration ?? const Duration(seconds: 3),
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color ?? Colors.redAccent,
      ),
    );
  }

  static void showCustomToast({
    required BuildContext context,
    String? title,
    required String message,
    Color? color,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
        backgroundColor: color ?? Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showCustomErrorToast({
    required BuildContext context,
    String? title,
    required String message,
    Color? color,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
        backgroundColor: color ?? Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
