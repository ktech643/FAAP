import 'package:faap/UI Helper/Buttons/primary_button.dart';
import 'package:faap/UI Helper/colors.dart';
import 'package:faap/UI Helper/custom_appbar.dart';
import 'package:faap/UI Helper/inputfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _additiveNameController = TextEditingController();
  final TextEditingController _harmDescriptionController =
      TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  String? _selectedCategory;

  final List<String> _categories = [
    'Bug Report',
    'Feature Suggestion',
    'General Feedback',
    'Recommend Harmful Additive',
    'Other',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    _additiveNameController.dispose();
    _harmDescriptionController.dispose();
    _sourceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: 'Feedback & Bug Report',
        transparent: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subject
              Text(
                'Subject',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              PrimaryInputField(
                controller: _subjectController,
                hintText: 'e.g., App crashes on scan',
                filled: true,
                fillColor: AppColors.greyVeryLight,
                enabledBorderColor: AppColors.border,
                focusBorderColor: AppColors.primary,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              // Category
              Text(
                'Category',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              DropdownButtonFormField<String>(
                dropdownColor: AppColors.white,
                value: _selectedCategory,
                hint: Text(
                  'Select a category',
                  style: GoogleFonts.inter(
                    color: AppColors.secondary,
                    fontSize: 16.sp,
                  ),
                ),
                borderRadius: BorderRadius.circular(10.r),
                items:
                    _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(
                          category,
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.disabled, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.primary, width: 1),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              // Message
              Text(
                'Message',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              UniversalInputField(
                controller: _messageController,
                maxLines: 6,
                hintText: 'Please describe the issue in detail...',
                filled: true,
                fillColor: AppColors.greyVeryLight,
                enabledBorderColor: AppColors.border,
                focusBorderColor: AppColors.primary,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              // Additional fields for Recommend Harmful Additive
              if (_selectedCategory == 'Recommend Harmful Additive') ...[
                Text(
                  'Additive Name',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
                PrimaryInputField(
                  controller: _additiveNameController,
                  hintText: 'e.g., Artificial Sweetener X',
                  filled: true,
                  fillColor: AppColors.greyVeryLight,
                  enabledBorderColor: AppColors.border,
                  focusBorderColor: AppColors.primary,
                  validator: (value) {
                    if (_selectedCategory == 'Recommend Harmful Additive' &&
                        (value == null || value.isEmpty)) {
                      return 'Please enter the additive name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                Text(
                  'Description of Harm',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
                UniversalInputField(
                  controller: _harmDescriptionController,
                  maxLines: 4,
                  hintText: 'Describe why this additive is harmful...',
                  filled: true,
                  fillColor: AppColors.greyVeryLight,
                  enabledBorderColor: AppColors.border,
                  focusBorderColor: AppColors.primary,
                  validator: (value) {
                    if (_selectedCategory == 'Recommend Harmful Additive' &&
                        (value == null || value.isEmpty)) {
                      return 'Please describe the harm';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                Text(
                  'Source/Reference (optional)',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
                PrimaryInputField(
                  controller: _sourceController,
                  hintText: 'e.g., Study link or article',
                  filled: true,
                  fillColor: AppColors.greyVeryLight,
                  enabledBorderColor: AppColors.border,
                  focusBorderColor: AppColors.primary,
                  validator: (value) {
                    return null; // Optional
                  },
                ),
                SizedBox(height: 24.h),
              ],
              // Attachments
              Text(
                'Attachments (optional)',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Attachment upload tapped')),
                  );
                },
                child: Container(
                  height: 120.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.border,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.greyVeryLight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        color: AppColors.secondary,
                        size: 32.sp,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Click to upload or drag and drop',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'PNG, JPG or GIF (MAX. 5MB)',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              // Submit Button
              PrimaryButton(
                text: 'Submit Feedback',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle submit
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feedback submitted')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: AppColors.white,
      //   selectedItemColor: AppColors.primary,
      //   unselectedItemColor: AppColors.secondary,
      //   currentIndex: 4, // Profile
      //   type: BottomNavigationBarType.fixed,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.qr_code_scanner),
      //       label: 'Scan',
      //     ),
      //     BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
      //     BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Health'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //   ],
      //   onTap: (index) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text(
      //           'Navigated to ${['Home', 'Scan', 'History', 'Health', 'Profile'][index]}',
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
