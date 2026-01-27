import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

/// Service for handling email operations across different platforms
/// Provides fallback mechanisms for devices without email clients
class EmailService {
  /// Launch email with platform-specific fallbacks
  ///
  /// Parameters:
  ///   - context: BuildContext for showing snackbars
  ///   - email: Email address to send to
  ///   - subject: Optional email subject
  ///   - body: Optional email body
  static Future<void> launchEmail(
    BuildContext context, {
    required String email,
    String? subject,
    String? body,
  }) async {
    try {
      // Create mailto URI with optional subject and body
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          if (subject != null) 'subject': subject,
          if (body != null) 'body': body,
        },
      );

      // Try to launch with mailto scheme (primary method)
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        return;
      }

      // Platform-specific fallbacks
      if (Platform.isAndroid) {
        await _launchEmailAndroid(context, email, subject, body);
      } else if (Platform.isIOS) {
        await _launchEmailIOS(context, email, subject, body);
      } else {
        _showEmailErrorSnackbar(context, email);
      }
    } catch (e) {
      print('Error launching email: $e');
      _showEmailErrorSnackbar(context, email);
    }
  }

  /// Android-specific email launching with Gmail web fallback
  static Future<void> _launchEmailAndroid(
    BuildContext context,
    String email,
    String? subject,
    String? body,
  ) async {
    try {
      // Try Gmail web interface as fallback
      final gmailUri = Uri(
        scheme: 'https',
        host: 'mail.google.com',
        path: '/mail/u/0/',
        queryParameters: {
          'fs': '1',
          'tf': 'cm',
          'to': email,
          if (subject != null) 'su': subject,
          if (body != null) 'body': body,
        },
      );

      if (await canLaunchUrl(gmailUri)) {
        await launchUrl(gmailUri, mode: LaunchMode.externalApplication);
        return;
      }

      // If Gmail web also fails, show error with copy option
      _showEmailErrorSnackbar(context, email);
    } catch (e) {
      print('Android email fallback error: $e');
      _showEmailErrorSnackbar(context, email);
    }
  }

  /// iOS-specific email launching
  static Future<void> _launchEmailIOS(
    BuildContext context,
    String email,
    String? subject,
    String? body,
  ) async {
    try {
      // iOS has limited mailto support, try direct URI first
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          if (subject != null) 'subject': subject,
          if (body != null) 'body': body,
        },
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        return;
      }

      // Fallback to error snackbar
      _showEmailErrorSnackbar(context, email);
    } catch (e) {
      print('iOS email fallback error: $e');
      _showEmailErrorSnackbar(context, email);
    }
  }

  /// Show error snackbar with copy to clipboard functionality
  static void _showEmailErrorSnackbar(BuildContext context, String email) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Email client not available. You can reach us at: $email',
        ),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: email));
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Email copied to clipboard'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Copy email to clipboard
  static Future<void> copyEmailToClipboard(
    BuildContext context,
    String email,
  ) async {
    try {
      await Clipboard.setData(ClipboardData(text: email));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email copied: $email'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error copying to clipboard: $e');
    }
  }
}
