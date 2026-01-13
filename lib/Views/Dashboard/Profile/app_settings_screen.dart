import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:faap/UI Helper/colors.dart';
import 'package:faap/UI Helper/custom_appbar.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  String selectedLanguage = 'English';
  String selectedRegion = 'United States';
  String dateFormat = 'MM/DD/YYYY';
  String timeFormat = '12-hour';
  String units = 'Imperial';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'App Settings'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language section
            Text(
              'Language',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildLanguageOption('English'),
                  Divider(height: 1, color: AppColors.border),
                  _buildLanguageOption('Spanish'),
                  Divider(height: 1, color: AppColors.border),
                  _buildLanguageOption('French'),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            // Region section
            Text(
              'Region',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildRegionOption('United States'),
                  Divider(height: 1, color: AppColors.border),
                  _buildRegionOption('United Kingdom'),
                  Divider(height: 1, color: AppColors.border),
                  _buildRegionOption('European Union'),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            // Regional Formats section
            Text(
              'Regional Formats',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildFormatOption('Date Format', dateFormat),
                  Divider(height: 1, color: AppColors.border),
                  _buildFormatOption('Time Format', timeFormat),
                  Divider(height: 1, color: AppColors.border),
                  _buildFormatOption('Units', units),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    final isSelected = selectedLanguage == language;
    return ListTile(
      title: Text(
        language,
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
        ),
      ),
      trailing:
          isSelected
              ? Icon(Icons.check_circle, color: AppColors.primary)
              : null,
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });
      },
    );
  }

  Widget _buildRegionOption(String region) {
    final isSelected = selectedRegion == region;
    return ListTile(
      title: Text(
        region,
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
        ),
      ),
      trailing:
          isSelected
              ? Icon(Icons.check_circle, color: AppColors.primary)
              : null,
      onTap: () {
        setState(() {
          selectedRegion = region;
        });
      },
    );
  }

  Widget _buildFormatOption(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.inter(fontSize: 16.sp, color: AppColors.textPrimary),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(width: 8.w),
          Icon(Icons.chevron_right, color: AppColors.secondary),
        ],
      ),
      onTap: () => _showFormatDialog(title),
    );
  }

  void _showFormatDialog(String title) {
    List<String> options = [];
    String currentValue = '';

    switch (title) {
      case 'Date Format':
        options = ['MM/DD/YYYY', 'DD/MM/YYYY', 'YYYY-MM-DD'];
        currentValue = dateFormat;
        break;
      case 'Time Format':
        options = ['12-hour', '24-hour'];
        currentValue = timeFormat;
        break;
      case 'Units':
        options = ['Imperial', 'Metric'];
        currentValue = units;
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                options.map((option) {
                  return RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: currentValue,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          switch (title) {
                            case 'Date Format':
                              dateFormat = value;
                              break;
                            case 'Time Format':
                              timeFormat = value;
                              break;
                            case 'Units':
                              units = value;
                              break;
                          }
                        });
                        Navigator.of(context).pop();
                      }
                    },
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}
