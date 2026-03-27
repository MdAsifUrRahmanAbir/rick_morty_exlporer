import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../../routes/app_pages.dart';

class AppSnackBar {
  AppSnackBar._();

  static void success(String message) {
    _showSnackBar(
      message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_rounded,
    );
  }

  static void error(String message) {
    _showSnackBar(
      message,
      backgroundColor: AppColors.error,
      icon: Icons.warning_rounded,
    );
  }

  static void info(String message) {
    _showSnackBar(
      message,
      backgroundColor: AppColors.info,
      icon: Icons.info_rounded,
    );
  }

  static void warning(String message) {
    _showSnackBar(
      message,
      backgroundColor: AppColors.warning,
      icon: Icons.warning_amber_rounded,
    );
  }

  static void _showSnackBar(
    String message, {
    required Color backgroundColor,
    required IconData icon,
  }) {
    AppPages.messengerKey.currentState?.hideCurrentSnackBar();
    AppPages.messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            AppPages.messengerKey.currentState?.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
