import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Model/product.dart';
import '../../../Provider/product_provider.dart';
import '../../../UI Helper/Product/listproduct.dart';
import '../../../UI Helper/colors.dart';
import '../../../UI Helper/custom_appbar.dart';
import '../Home Screens/product_details_screen.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch products once when the screen is opened
    Future.microtask(() => ref.read(productsProvider.notifier).getProducts());
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  Color _statusColor(String? status) {
    final s = status?.toLowerCase() ?? '';
    if (s.contains('safe') || s.contains('good')) return Colors.green;
    if (s.contains('avoid') || s.contains('high')) return Colors.red;
    if (s.contains('caution') || s.contains('low') || s.contains('moderate'))
      return Colors.yellow;
    return AppColors.disabled;
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);

    if (productsState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (productsState.isError) {
      return Center(
        child: Text(productsState.message ?? 'Failed to load products'),
      );
    }

    // Get list and sort by createdAt (newest first)
    final allProducts = List<Product>.from(productsState.data ?? []);
    allProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final now = DateTime.now();
    final todayProducts = <Product>[];
    final yesterdayProducts = <Product>[];

    for (final p in allProducts) {
      if (_isSameDay(p.createdAt, now)) {
        todayProducts.add(p);
      } else if (_isSameDay(
        p.createdAt,
        now.subtract(const Duration(days: 1)),
      )) {
        yesterdayProducts.add(p);
      }
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: AppColors.white,
      ),
      child: Scaffold(
        backgroundColor: AppColors.greyVeryLight,
        appBar: CustomAppBar(
          title: 'Scan History',
          leading: SizedBox.shrink(),
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list, color: AppColors.textPrimary),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.sort, color: AppColors.textPrimary),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            if (todayProducts.isNotEmpty) ...[
              Text(
                'Today',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              ...todayProducts.map(
                (product) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: ScanItemWidget(
                    name: product.title,
                    date: 'Scanned today at ${_formatTime(product.createdAt)}',
                    grade: product.status ?? product.riskLevel,
                    gradeColor: _statusColor(
                      product.status ?? product.riskLevel,
                    ),
                    imageUrl: product.image ?? '',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 32.h),
            ],

            if (yesterdayProducts.isNotEmpty) ...[
              Text(
                'Yesterday',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              ...yesterdayProducts.map(
                (product) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: ScanItemWidget(
                    name: product.title,
                    date:
                        'Scanned yesterday at ${_formatTime(product.createdAt)}',
                    grade: product.status ?? product.riskLevel,
                    gradeColor: _statusColor(
                      product.status ?? product.riskLevel,
                    ),
                    imageUrl: product.image ?? '',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 32.h),
            ],

            if (todayProducts.isEmpty && yesterdayProducts.isEmpty) ...[
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 48.h),
                  child: Text(
                    'No scan history available',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
