import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum SnackbarType { success, warning, error }

class CustomSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    required SnackbarType type,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    final snackbar = SnackBar(
      content: _SnackbarContent(
        message: message,
        type: type,
      ),
      backgroundColor: _getBackgroundColor(type),
      duration: duration,
      action: action,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.all(16.w),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}

class _SnackbarContent extends StatelessWidget {
  final String message;
  final SnackbarType type;

  const _SnackbarContent({
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          _getIcon(),
          color: Colors.white,
          size: 20.sp,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getIcon() {
    switch (type) {
      case SnackbarType.success:
        return Icons.check_circle;
      case SnackbarType.warning:
        return Icons.warning;
      case SnackbarType.error:
        return Icons.error;
    }
  }
}

Color _getBackgroundColor(SnackbarType type) {
  switch (type) {
    case SnackbarType.success:
      return const Color(0xFF22c55e); // green-500
    case SnackbarType.warning:
      return const Color(0xFFf59e0b); // amber-500
    case SnackbarType.error:
      return const Color(0xFFef4444); // red-500
  }
}

// Convenience methods for different snackbar types
class SnackbarHelper {
  static void success({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    CustomSnackbar.show(
      context: context,
      message: message,
      type: SnackbarType.success,
      duration: duration,
      action: action,
    );
  }

  static void warning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    CustomSnackbar.show(
      context: context,
      message: message,
      type: SnackbarType.warning,
      duration: duration,
      action: action,
    );
  }

  static void error({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    CustomSnackbar.show(
      context: context,
      message: message,
      type: SnackbarType.error,
      duration: duration,
      action: action,
    );
  }
}

// Extension for easy access
extension SnackbarExtension on BuildContext {
  void showSuccessSnackbar(String message, {Duration? duration}) {
    SnackbarHelper.success(
      context: this,
      message: message,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  void showWarningSnackbar(String message, {Duration? duration}) {
    SnackbarHelper.warning(
      context: this,
      message: message,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  void showErrorSnackbar(String message, {Duration? duration}) {
    SnackbarHelper.error(
      context: this,
      message: message,
      duration: duration ?? const Duration(seconds: 4),
    );
  }
}
