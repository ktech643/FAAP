import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/router/app_routes.dart';
import '../providers/search_provider.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/search_type_selector.dart';
import '../widgets/recent_searches_widget.dart';
import '../widgets/search_results_widget.dart';
import '../widgets/empty_search_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    // Auto-focus search bar when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
  
  void _onSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      context.read<SearchProvider>().search(query.trim());
    }
  }
  
  void _onRecentSearchTapped(String search) {
    _searchController.text = search;
    _onSearchSubmitted(search);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: Consumer<SearchProvider>(
          builder: (context, searchProvider, _) {
            return Column(
              children: [
                // Search Header
                Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      // Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Search',
                            style: AppTypography.h3.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          IconButton(
                            onPressed: () => context.go(AppRoutes.scan),
                            icon: Icon(
                              Icons.qr_code_scanner,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(duration: 300.ms),
                      
                      const SizedBox(height: AppSpacing.lg),
                      
                      // Search Bar
                      SearchBarWidget(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onSubmitted: _onSearchSubmitted,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            searchProvider.clearResults();
                          }
                        },
                        onClear: () {
                          _searchController.clear();
                          searchProvider.clearResults();
                          _searchFocusNode.requestFocus();
                        },
                      )
                          .animate()
                          .fadeIn(delay: 200.ms)
                          .slideY(begin: -0.1, end: 0),
                      
                      const SizedBox(height: AppSpacing.md),
                      
                      // Search Type Selector
                      SearchTypeSelector(
                        selectedType: searchProvider.searchType,
                        onTypeChanged: searchProvider.setSearchType,
                      )
                          .animate()
                          .fadeIn(delay: 300.ms),
                    ],
                  ),
                ),
                
                // Search Content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: searchProvider.isSearching
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryGreen,
                            ),
                          )
                        : searchProvider.searchQuery.isEmpty
                            ? SingleChildScrollView(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Recent Searches
                                    if (searchProvider.recentSearches.isNotEmpty)
                                      RecentSearchesWidget(
                                        recentSearches: searchProvider.recentSearches,
                                        onSearchTapped: _onRecentSearchTapped,
                                        onRemove: searchProvider.removeRecentSearch,
                                        onClearAll: searchProvider.clearRecentSearches,
                                      )
                                          .animate()
                                          .fadeIn(delay: 400.ms),
                                    
                                    const SizedBox(height: AppSpacing.xl),
                                    
                                    // Popular Additives
                                    _buildPopularSection(
                                      title: 'Popular Additives',
                                      items: [
                                        {'code': 'E102', 'name': 'Tartrazine'},
                                        {'code': 'E211', 'name': 'Sodium Benzoate'},
                                        {'code': 'E621', 'name': 'MSG'},
                                        {'code': 'E951', 'name': 'Aspartame'},
                                      ],
                                      onItemTapped: (item) {
                                        context.push('${AppRoutes.additiveDetails}/${item['code']}');
                                      },
                                    )
                                        .animate()
                                        .fadeIn(delay: 500.ms),
                                  ],
                                ),
                              )
                            : searchProvider.hasResults
                                ? SearchResultsWidget(
                                    productResults: searchProvider.productResults,
                                    additiveResults: searchProvider.additiveResults,
                                    brandResults: searchProvider.brandResults,
                                    searchType: searchProvider.searchType,
                                    onProductTapped: (product) {
                                      context.push(
                                        '${AppRoutes.productDetails}/${product.id}',
                                      );
                                    },
                                    onAdditiveTapped: (additive) {
                                      context.push(
                                        '${AppRoutes.additiveDetails}/${additive.code}',
                                      );
                                    },
                                    onBrandTapped: (brand) {
                                      _searchController.text = brand;
                                      _onSearchSubmitted(brand);
                                    },
                                  )
                                : EmptySearchWidget(
                                    query: searchProvider.searchQuery,
                                    searchType: searchProvider.searchType,
                                  ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildPopularSection({
    required String title,
    required List<Map<String, String>> items,
    required Function(Map<String, String>) onItemTapped,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.h5.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: items.map((item) {
            return GestureDetector(
              onTap: () => onItemTapped(item),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                  border: Border.all(
                    color: AppColors.primaryGreen.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item['code']!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      item['name']!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}