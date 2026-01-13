import 'package:faap/UI Helper/Product/listproduct.dart';
import 'package:faap/UI Helper/colors.dart';
import 'package:faap/UI Helper/custom_appbar.dart';
import 'package:faap/Views/Dashboard/Home%20Screens/product_details_screen.dart';
import 'package:faap/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Provider/product_provider.dart';

class SeeAllProductsScreen extends ConsumerStatefulWidget {
  const SeeAllProductsScreen({super.key});

  @override
  ConsumerState<SeeAllProductsScreen> createState() =>
      _SeeAllProductsScreenState();
}

class _SeeAllProductsScreenState extends ConsumerState<SeeAllProductsScreen> {
  @override
  void initState() {
    super.initState();
    // Load products on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productsProvider.notifier).getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final response = ref.watch(productsProvider);
    final products = response.data ?? [];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(title: 'All Products'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Builder(
            builder: (context) {
              if (response.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              if (response.isError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(response.message ?? 'Failed to load products'),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed:
                            () =>
                                ref
                                    .read(productsProvider.notifier)
                                    .getProducts(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (products.isEmpty) {
                return Center(child: Text('No products found'));
              }

              return ListView.separated(
                itemCount: products.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final product = products[index];
                  final name = product.title; // non-nullable
                  final date = 'Scanned';
                  final grade = product.status; // non-nullable
                  final gradeColor = getStatusColor(product.riskLevel ?? '');
                  final imageUrl = product.image.toString();

                  return ScanItemWidget(
                    name: name,
                    date: date,
                    grade: grade ?? 'N/A',
                    gradeColor: gradeColor,
                    imageUrl: imageUrl,
                    onTap: () {
                      navigatorKey.currentState?.push(
                        //ProductDetailsScreen()
                        MaterialPageRoute(
                          builder:
                              (_) => ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Color getStatusColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high_risk':
        return Colors.red;
      case 'moderate_risk':
        return Colors.orange;
      case 'low_risk':
        return Colors.green;
      case 'safe':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
