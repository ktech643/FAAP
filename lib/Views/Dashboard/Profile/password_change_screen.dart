import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:faap/UI Helper/Buttons/primary_button.dart';
import 'package:faap/UI Helper/colors.dart';
import 'package:faap/UI Helper/custom_appbar.dart';
import 'package:faap/UI Helper/inputfields.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _savePassword() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically call an API to change the password
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
      Navigator.of(context).pop();
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return _validatePassword(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: 'Change Password'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your current password and choose a new one.',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 24.h),
              PrimaryInputField(
                controller: _currentPasswordController,
                labelText: 'Current Password',
                hintText: 'Enter current password',
                isPassword: true,
                validator: _validatePassword,
              ),
              SizedBox(height: 16.h),
              PrimaryInputField(
                controller: _newPasswordController,
                labelText: 'New Password',
                hintText: 'Enter new password',
                isPassword: true,
                validator: _validatePassword,
              ),
              SizedBox(height: 16.h),
              PrimaryInputField(
                controller: _confirmPasswordController,
                labelText: 'Confirm New Password',
                hintText: 'Confirm new password',
                isPassword: true,
                validator: _validateConfirmPassword,
              ),
              SizedBox(height: 32.h),
              PrimaryButton(text: 'Change Password', onPressed: _savePassword),
            ],
          ),
        ),
      ),
    );
  }
}
