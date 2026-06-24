// lib/Provider/product_provider.dart
import 'dart:io';

import 'package:faap/Views/Auth Screens/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../Api Services/api_service.dart';
import '../Api Services/response.dart';
import '../Model/product.dart';
import '../Repositories/product_repository.dart';
import '../Views/Product/product_details_screen.dart';
import '../main.dart';

// Providers
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(apiServiceProvider));
});

// Products list state - Main provider with scan functionality
final productsProvider =
    StateNotifierProvider<ProductsNotifier, ApiResponse<List<Product>>>((ref) {
      return ProductsNotifier(ref, ref.watch(productRepositoryProvider));
    });

// Loading state for scan operation
final scanLoadingProvider = StateProvider<bool>((ref) => false);

// Notifiers
class ProductsNotifier extends StateNotifier<ApiResponse<List<Product>>> {
  final ProductRepository _repository;
  final Ref _ref;
  final ImagePicker _imagePicker = ImagePicker();

  ProductsNotifier(this._ref, this._repository)
    : super(ApiResponse.success([]));

  // // Helper method to convert FoodProductAnalysis to Product
  // Product _convertAnalysisToProduct(Product analysis) {
  //   String mapRiskLevel(String riskLevel) {
  //     switch (riskLevel.toLowerCase()) {
  //       case 'safe':
  //         return 'Good to Eat';
  //       case 'low_risk':
  //         return 'Low Risk';
  //       case 'moderate_risk':
  //         return 'Moderate Risk';
  //       case 'high_risk':
  //         return 'High Risk';
  //       default:
  //         return 'Unknown';
  //     }
  //   }
  //
  //   return Product(
  //     title: analysis.name,
  //     description: analysis.description,
  //     image: analysis.image,
  //     status: mapRiskLevel(analysis.risk_level),
  //     riskLevel: analysis.risk_level,
  //     harmfulIngredients: analysis.ingredientsList,
  //   );
  // }

  // Scan product function that handles camera and analysis
  Future<ApiResponse<Product?>> scanProduct() async {
    try {
      // Open camera to take picture
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        return ApiResponse.error('No image selected');
      }

      final imageFile = File(pickedFile.path);

      // Call repository to analyze image with Gemini
      final result = await _repository.scanProductGemini(imageFile);

      if (result.isSuccess && result.data != null) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(analysis: result.data!),
          ),
        );

        // Edge function automatically saves the product to the database now.
        // Refresh the local products list from Supabase to show the new scan in history
        await getProducts();

        return ApiResponse.success(result.data);
      } else {
        return ApiResponse.error(result.message ?? 'Failed to scan product');
      }
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  // Scan product from a provided image file (used for capturing from existing camera view)
  Future<ApiResponse<Product?>> scanProductFromFile(File imageFile) async {
    try {
      // Call repository to analyze image with Gemini
      final result = await _repository.scanProductGemini(imageFile);

      if (result.isSuccess && result.data != null) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(analysis: result.data!),
          ),
        );

        // Edge function automatically saves the product to the database now.
        // Refresh the local products list from Supabase to show the new scan in history
        await getProducts();

        return ApiResponse.success(result.data!);
      } else {
        return ApiResponse.error(result.message ?? 'Failed to scan product');
      }
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  // Add product to the list and persist to Supabase (if user is authenticated)
  Future<void> addProduct(Product product) async {
    // Update local state immediately (optimistic update)
    if (state.data != null) {
      final updatedProducts = [...state.data!, product];
      state = ApiResponse.success(updatedProducts);
    } else {
      state = ApiResponse.success([product]);
    }

    try {
      final email = _ref.read(userProvider).userData.email ?? '';
      if (email.isEmpty) {
        // No user email; cannot persist remotely
        return;
      }

      final result = await _repository.setProduct(email, product);
      if (result.isSuccess && result.data != null) {
        // Update local state with the product that now has the Supabase ID
        final createdProduct = result.data!;
        if (state.data != null) {
          // Replace the product without ID with the one that has ID
          final updatedProducts = state.data!.map<Product>((p) {
            if (p == product) {
              return createdProduct;
            }
            return p;
          }).toList();
          state = ApiResponse.success(updatedProducts);
        } else {
          state = ApiResponse.success([createdProduct]);
        }
      } else {
        // Set error but keep local state; user can retry later
        state = ApiResponse.error(result.message ?? 'Failed to save product');
      }
    } catch (e) {
      state = ApiResponse.error('Failed to save product: $e');
    }
  }

  // Get all products from Supabase for the current user
  Future<void> getProducts() async {
    try {
      final email = _ref.read(userProvider).userData.email ?? '';
      if (email.isEmpty) {
        state = ApiResponse.error('No user email available');
        return;
      }

      // Only show full-screen loading if we don't have any data yet
      if (state.data == null || state.data!.isEmpty) {
        state = ApiResponse.loading();
      }
      
      final result = await _repository.getAllProducts(email);
      if (result.isSuccess) {
        state = ApiResponse.success(result.data ?? []);
      } else {
        state = ApiResponse.error(result.message ?? 'Failed to fetch products');
      }
    } catch (e) {
      state = ApiResponse.error('Failed to fetch products: $e');
    }
  }

  Future<void> addProducts(List<Product> products) async {
    // Fetch products from Supabase at products table filtered by owner
    try {
      final email = _ref.read(userProvider).userData.email ?? '';
      if (email.isEmpty) {
        state = ApiResponse.error('No user email available');
        return;
      }

      // Only show full-screen loading if we don't have any data yet
      if (state.data == null || state.data!.isEmpty) {
        state = ApiResponse.loading();
      }
      
      final result = await _repository.getAllProducts(email);

      if (result.isSuccess) {
        state = ApiResponse.success(result.data ?? []);
      } else {
        state = ApiResponse.error(result.message ?? 'Failed to fetch products');
      }
    } catch (e) {
      state = ApiResponse.error('Failed to fetch products: $e');
    }
  }

  // Clear all products
  void clearProducts() {
    state = ApiResponse.success([]);
  }

  // Remove a specific product
  void removeProduct(int index) {
    if (state.data != null && index < state.data!.length) {
      final updatedProducts = [...state.data!];
      updatedProducts.removeAt(index);
      state = ApiResponse.success(updatedProducts);
    }
  }

  // Toggle favorite status for a product
  Future<ApiResponse<void>> toggleFavorite(Product product) async {
    try {
      // Check if product has a valid ID
      if (product.id == null || product.id!.isEmpty) {
        return ApiResponse.error('Product ID is required. Please refresh and try again.');
      }

      // Calculate the new favorite status
      final newFavoriteStatus = !product.isFavorite;
      
      // Update local state immediately (optimistic update)
      if (state.data != null) {
        final updatedProducts = state.data!.map<Product>((p) {
          if (p.id == product.id) {
            p.isFavorite = newFavoriteStatus;
            return p;
          }
          return p;
        }).toList();
        state = ApiResponse.success(updatedProducts);
      }

      // Update in Supabase with the new status
      final email = _ref.read(userProvider).userData.email ?? '';
      if (email.isEmpty) {
        // Revert on error
        if (state.data != null) {
          final revertedProducts = state.data!.map<Product>((p) {
            if (p.id == product.id) {
              p.isFavorite = product.isFavorite; // Revert to original
              return p;
            }
            return p;
          }).toList();
          state = ApiResponse.success(revertedProducts);
        }
        return ApiResponse.error('No user email available');
      }

      final result = await _repository.updateProductFavorite(
        product.id!,
        newFavoriteStatus, // Send the correct new status
      );

      if (!result.isSuccess) {
        // Revert on error
        if (state.data != null) {
          final revertedProducts = state.data!.map<Product>((p) {
            if (p.id == product.id) {
              p.isFavorite = product.isFavorite; // Revert to original
              return p;
            }
            return p;
          }).toList();
          state = ApiResponse.success(revertedProducts);
        }
        return ApiResponse.error(result.message ?? 'Failed to update favorite');
      }

      return ApiResponse.success(null);
    } catch (e) {
      // Revert on exception
      if (state.data != null) {
        final revertedProducts = state.data!.map<Product>((p) {
          if (p.id == product.id) {
            p.isFavorite = product.isFavorite; // Revert to original
            return p;
          }
          return p;
        }).toList();
        state = ApiResponse.success(revertedProducts);
      }
      return ApiResponse.error('Failed to update favorite: $e');
    }
  }
}
