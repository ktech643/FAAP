import 'package:faap/UI Helper/colors.dart';
import 'package:faap/UI Helper/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DietPreference extends StatefulWidget {
  const DietPreference({super.key});

  @override
  State<DietPreference> createState() => _DietPreferenceState();
}

class _DietPreferenceState extends State<DietPreference> {
  bool vegetarian = true;
  bool vegan = false;
  bool glutenFree = true;
  bool dairyFree = false;
  bool nuts = true;
  bool dairy = false;
  bool soy = false;
  bool shellfish = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Dietary Preferences'),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Text(
                        'Dietary Restrictions',
                        style: GoogleFonts.inter(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      title: Text(
                        'Vegetarian',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      value: vegetarian,
                      onChanged: (value) {
                        setState(() {
                          vegetarian = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                      checkColor: Colors.white,
                    ),
                    Divider(height: 1, color: Colors.grey[300]),
                    CheckboxListTile(
                      title: Text(
                        'Vegan',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      value: vegan,
                      onChanged: (value) {
                        setState(() {
                          vegan = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                      checkColor: Colors.white,
                    ),
                    Divider(height: 1, color: Colors.grey[300]),
                    CheckboxListTile(
                      title: Text(
                        'Gluten-Free',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      value: glutenFree,
                      onChanged: (value) {
                        setState(() {
                          glutenFree = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                      checkColor: Colors.white,
                    ),
                    Divider(height: 1, color: Colors.grey[300]),
                    CheckboxListTile(
                      title: Text(
                        'Dairy-Free',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      value: dairyFree,
                      onChanged: (value) {
                        setState(() {
                          dairyFree = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                      checkColor: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Text(
                        'Allergen Alerts',
                        style: GoogleFonts.inter(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      title: Text(
                        'Nuts',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      value: nuts,
                      onChanged: (value) {
                        setState(() {
                          nuts = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                      checkColor: Colors.white,
                    ),
                    Divider(height: 1, color: Colors.grey[300]),
                    CheckboxListTile(
                      title: Text(
                        'Dairy',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      value: dairy,
                      onChanged: (value) {
                        setState(() {
                          dairy = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                      checkColor: Colors.white,
                    ),
                    Divider(height: 1, color: Colors.grey[300]),
                    CheckboxListTile(
                      title: Text(
                        'Soy',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      value: soy,
                      onChanged: (value) {
                        setState(() {
                          soy = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                      checkColor: Colors.white,
                    ),
                    Divider(height: 1, color: Colors.grey[300]),
                    CheckboxListTile(
                      title: Text(
                        'Shellfish',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      value: shellfish,
                      onChanged: (value) {
                        setState(() {
                          shellfish = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                      checkColor: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: OutlinedButton(
                        onPressed: () {
                          // Add custom preference
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.grey[400]!,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.all(16.w),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.add, color: Colors.grey[600]),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                'Add Custom Preference',
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.w),
              child: ElevatedButton(
                onPressed: () {
                  // Save changes
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 56.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                ),
                child: Text(
                  'Save Changes',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
