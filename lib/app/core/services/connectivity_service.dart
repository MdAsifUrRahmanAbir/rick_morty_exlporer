import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/app_colors.dart';

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();

  static Future<bool> isConnected() async {
    try {
      final List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      return result.any((r) => r != ConnectivityResult.none);
    } catch (e) {
      // Fallback: assume connected if plugin is missing or fails
      // This prevents the MissingPluginException from crashing the API layer
      debugPrint("Connectivity check failed: $e");
      return true; 
    }
  }

  static void showNoInternetToast() {
    Fluttertoast.showToast(
      msg: "No Internet Connection",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black.withValues(alpha: 0.8),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  static void showModernToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? Colors.redAccent : AppColors.primary,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
