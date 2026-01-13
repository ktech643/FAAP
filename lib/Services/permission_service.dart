import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Check if notification permission is granted
  static Future<bool> isNotificationPermissionGranted() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  /// Request notification permission
  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Check if notification permission is permanently denied
  static Future<bool> isNotificationPermissionPermanentlyDenied() async {
    final status = await Permission.notification.status;
    return status.isPermanentlyDenied;
  }

  /// Open app settings
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}







