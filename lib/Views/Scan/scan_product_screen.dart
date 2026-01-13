import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Model/product.dart';
import '../../Provider/product_provider.dart';
import '../../UI Helper/colors.dart';

const String _referenceUrl = 'https://docs.google.com/document/d/1aNZpuM3nCVtvWs2D47U2y5luK09j7Fro/edit?usp=sharing&ouid=108232553445710667549&rtpof=true&sd=true';

Future<void> openReferenceUrl() async {
  final uri = Uri.parse(_referenceUrl);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    // ignore: avoid_print
    print('Could not launch $_referenceUrl');
  }
}

class ScanProductScreen extends ConsumerWidget {
  const ScanProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsProvider);
    final scanLoading = ref.watch(scanLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Scanner'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(productsProvider.notifier).clearProducts();
            },
            icon: const Icon(Icons.clear_all),
          ),
        ],
      ),
      body: Column(
        children: [
          // Scan Button
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    scanLoading
                        ? null
                        : () async {
                          ref.read(scanLoadingProvider.notifier).state = true;

                          final result =
                              await ref
                                  .read(productsProvider.notifier)
                                  .scanProduct();

                          ref.read(scanLoadingProvider.notifier).state = false;

                          if (result.isSuccess && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Product scanned successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else if (result.isError && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${result.message}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                icon:
                    scanLoading
                        ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Icon(Icons.camera_alt),
                label: Text(
                  scanLoading ? 'Analyzing...' : 'Scan Product',
                  style: TextStyle(fontSize: 16.sp),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ),

          // Products List
          Expanded(
            child:
                productsState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : productsState.isError
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64.sp,
                            color: Colors.red,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Error: ${productsState.message}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                    : productsState.data == null || productsState.data!.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            size: 64.sp,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No products scanned yet',
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Tap the scan button to analyze a product',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: productsState.data!.length,
                      itemBuilder: (context, index) {
                        final product = productsState.data![index];
                        return ProductCard(
                          product: product,
                          onDelete: () {
                            ref
                                .read(productsProvider.notifier)
                                .removeProduct(index);
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;

  const ProductCard({Key? key, required this.product, required this.onDelete})
    : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'good to eat':
        return Colors.green;
      case 'low risk':
        return Colors.orange;
      case 'moderate risk':
        return Colors.orange[700]!;
      case 'high risk':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and delete button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                if (product.image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.file(
                      File(product.image!),
                      width: 80.w,
                      height: 80.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(width: 12.w),

                // Product info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(product.riskLevel),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          product.riskLevel,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Delete button
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Description
            Text(
              'Description',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            Text(
              product.description,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
            ),

            // Harmful Ingredients
            if (product.harmfulIngredients!.isNotEmpty) ...[
              SizedBox(height: 16.h),
              Text(
                'Harmful Ingredients',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),
              ...product.harmfulIngredients!.map(
                (ingredient) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: ingredient.getBackgroundColor(),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: ingredient.getStatusColor()),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          ingredient.getStatusIcon(),
                          size: 20.sp,
                          color: ingredient.getStatusColor(),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ingredient.ingredientName,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ingredient.getStatusColor(),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                ingredient.risk,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                ingredient.getRiskLevelDisplay(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ingredient.getStatusColor(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            // Reference / Citation
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: openReferenceUrl,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.link, size: 18.sp, color: Colors.blue),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Source: Study / Guidance (tap to open)',
                        style: TextStyle(fontSize: 12.sp, color: Colors.blue),
                      ),
                    ),
                    Text(
                      'View',
                      style: TextStyle(fontSize: 12.sp, color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
