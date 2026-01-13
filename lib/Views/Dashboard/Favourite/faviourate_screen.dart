import 'package:faap/Model/product.dart';
import 'package:faap/Provider/product_provider.dart';
import 'package:faap/UI Helper/colors.dart';
import 'package:faap/UI Helper/custom_appbar.dart';
import 'package:faap/UI Helper/custom_imageloader.dart';
import 'package:faap/Views/Dashboard/Home%20Screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FaviourateScreen extends ConsumerStatefulWidget {
  const FaviourateScreen({super.key});

  @override
  ConsumerState<FaviourateScreen> createState() => _FaviourateScreenState();
}

class _FaviourateScreenState extends ConsumerState<FaviourateScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Watch products provider for reactive updates
    final productsResponse = ref.watch(productsProvider);
    final allProducts = productsResponse.data ?? [];

    // Filter only favorited products
    final favoriteProducts = allProducts.where((p) => p.isFavorite).toList();

    // Apply search filter if query is not empty
    final filteredProducts =
        _searchQuery.isEmpty
            ? favoriteProducts
            : favoriteProducts
                .where(
                  (p) => p.title.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
                )
                .toList();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        leading: SizedBox.shrink(),
        title: 'Favorites',
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Field
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search favorites...',
                hintStyle: TextStyle(color: AppColors.secondary),
                prefixIcon: Icon(Icons.search, color: AppColors.secondary),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Content Area
            Expanded(
              child:
                  productsResponse.isLoading && favoriteProducts.isEmpty
                      ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                      : productsResponse.isError
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64.sp,
                              color: AppColors.secondary,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Failed to load favorites',
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              productsResponse.message ?? 'Unknown error',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24.h),
                            ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(productsProvider.notifier)
                                    .getProducts();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      )
                      : filteredProducts.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _searchQuery.isEmpty
                                  ? Icons.favorite_border
                                  : Icons.search_off,
                              size: 64.sp,
                              color: AppColors.secondary,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No favorites yet'
                                  : 'No results found',
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'Start scanning products and add them to favorites!'
                                  : 'Try a different search term',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                      : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return FavoriteProductCard(product: product);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

// Product Card for Favorites
class FavoriteProductCard extends ConsumerWidget {
  final Product product;

  const FavoriteProductCard({super.key, required this.product});

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'safe':
      case 'low_risk':
        return Colors.green;
      case 'moderate_risk':
      case 'caution':
        return Colors.orange;
      case 'high_risk':
      case 'danger':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getRiskText(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'safe':
        return 'Safe';
      case 'low_risk':
        return 'Low Risk';
      case 'moderate_risk':
        return 'Moderate Risk';
      case 'caution':
        return 'Caution';
      case 'high_risk':
        return 'High Risk';
      case 'danger':
        return 'Danger';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Card(
        color: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                CustomImageLoader(
                  imageUrl: product.image ?? '',
                  height: 120.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 12.w,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Title
                      Text(
                        product.title,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      // Risk Level
                      Row(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: _getRiskColor(product.riskLevel),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _getRiskText(product.riskLevel),
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Favorite Button (Red heart since it's favorited)
            Positioned(
              top: 8.h,
              right: 8.w,
              child: IconButton(
                icon: Icon(Icons.favorite, color: Colors.red, size: 24.sp),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  padding: EdgeInsets.all(8.w),
                ),
                onPressed: () async {
                  if (product.id != null) {
                    final result = await ref
                        .read(productsProvider.notifier)
                        .toggleFavorite(product);

                    if (result.isError && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            result.message ?? 'Failed to update favorite',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
