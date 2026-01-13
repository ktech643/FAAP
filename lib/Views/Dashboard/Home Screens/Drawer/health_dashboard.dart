import 'package:faap/UI Helper/colors.dart';
import 'package:faap/UI Helper/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final String week;
  final double score;
  ChartData(this.week, this.score);
}

class HealthDashboard extends StatelessWidget {
  const HealthDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Health Dashboard'),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Grid
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  children: [
                    _buildStatCard('85', 'Health Score'),
                    _buildStatCard('120', 'Scanned'),
                    _buildStatCard('30', 'Days Active'),
                  ],
                ),
                SizedBox(height: 24.h),
                // Health Score Over Time
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Health Score Over Time',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '85',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 48.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '+5%',
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Last 30 Days',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        height: 148.h,
                        child: SfCartesianChart(
                          plotAreaBorderWidth: 0,
                          primaryXAxis: CategoryAxis(
                            isVisible: false,
                            majorGridLines: MajorGridLines(width: 0),
                          ),
                          primaryYAxis: NumericAxis(
                            isVisible: false,
                            majorGridLines: MajorGridLines(width: 0),
                          ),
                          series: <CartesianSeries<ChartData, String>>[
                            SplineSeries<ChartData, String>(
                              dataSource: [
                                ChartData('Wk 1', 80),
                                ChartData('Wk 2', 82),
                                ChartData('Wk 3', 85),
                                ChartData('Wk 4', 85),
                              ],
                              xValueMapper: (ChartData data, _) => data.week,
                              yValueMapper: (ChartData data, _) => data.score,
                              color: Colors.white,
                              width: 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                // Key Statistics
                Text(
                  'Key Statistics',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  children: [
                    _buildStatCard2('25', 'High-Risk Additives Avoided'),
                    _buildStatCard2('82', 'Average Health Score'),
                  ],
                ),
                SizedBox(height: 24.h),
                // Dietary Insights
                Text(
                  'Dietary Insights',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    border: Border.all(
                      color: AppColors.secondary.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    "You've shown a consistent improvement in your health score over the past month. Keep up the great work!",
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard2(String value, String label) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
