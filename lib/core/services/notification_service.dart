import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._init();
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  NotificationService._init();
  
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }
  
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    print('Notification tapped: ${response.payload}');
  }
  
  Future<void> requestPermissions() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    final ios = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    
    if (android != null) {
      await android.requestNotificationsPermission();
    }
    
    if (ios != null) {
      await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }
  
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'faap_scan_channel',
      'FAAP Scan Notifications',
      channelDescription: 'Notifications for FAAP Scan app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }
  
  Future<void> scheduleWeeklyHealthReport() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('weeklyHealthReport') ?? true;
    
    if (!isEnabled) return;
    
    const androidDetails = AndroidNotificationDetails(
      'weekly_report_channel',
      'Weekly Health Reports',
      channelDescription: 'Weekly health report notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // Schedule for every Sunday at 10 AM
    await _notifications.zonedSchedule(
      1001, // Fixed ID for weekly report
      'Your Weekly Health Report',
      'Check your food additive consumption trends!',
      _nextSundayTenAM(),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }
  
  DateTime _nextSundayTenAM() {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, 10);
    
    while (scheduledDate.weekday != DateTime.sunday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }
    
    return scheduledDate;
  }
  
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
  
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
  
  // Notification types
  Future<void> showHighRiskProductNotification(String productName) async {
    await showNotification(
      title: '⚠️ High Risk Product Detected',
      body: '$productName contains harmful additives. Tap to see alternatives.',
      payload: 'high_risk_product',
    );
  }
  
  Future<void> showScanStreakNotification(int days) async {
    await showNotification(
      title: '🎉 Great Job!',
      body: 'You\'ve scanned products for $days days in a row!',
      payload: 'scan_streak',
    );
  }
  
  Future<void> showHealthImprovementNotification() async {
    await showNotification(
      title: '📈 Health Score Improved!',
      body: 'Your weekly health score has improved. Keep it up!',
      payload: 'health_improvement',
    );
  }
}