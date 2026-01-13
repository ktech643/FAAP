import 'package:faap/UI Helper/colors.dart';
import 'package:faap/UI Helper/custom_appbar.dart';
import 'package:faap/UI Helper/custom_notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample notifications data
    final notifications = [
      {
        'title': 'Welcome to Scan App!',
        'message':
            'Thank you for joining us. Start scanning your favorite products.',
        'time': '2 hours ago',
        'icon': Icons.notifications,
        'isRead': false,
      },
      {
        'title': 'New Feature Available',
        'message': 'Check out the new barcode scanning feature in the app.',
        'time': '1 day ago',
        'icon': Icons.star,
        'isRead': false,
      },
      {
        'title': 'Profile Updated',
        'message': 'Your profile information has been successfully updated.',
        'time': '3 days ago',
        'icon': Icons.person,
        'isRead': true,
      },
      {
        'title': 'Security Alert',
        'message':
            'We noticed a login from a new device. If this wasn\'t you, please change your password.',
        'time': '1 week ago',
        'icon': Icons.security,
        'isRead': true,
      },
      {
        'title': 'App Update Available',
        'message':
            'A new version of the app is available. Update now for the latest features.',
        'time': '2 weeks ago',
        'icon': Icons.system_update,
        'isRead': true,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Notifications'),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return CustomNotificationCard(
            title: notification['title'] as String,
            message: notification['message'] as String,
            time: notification['time'] as String,
            icon: notification['icon'] as IconData,
            isRead: notification['isRead'] as bool,
            onTap: () {
              // Handle notification tap
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped: ${notification['title']}')),
              );
            },
          );
        },
      ),
    );
  }
}
