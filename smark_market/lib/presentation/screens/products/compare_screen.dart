import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_messages.dart';
import '../../../data/providers/product_provider.dart';
import '../../../data/providers/favorites_provider.dart';
import '../../../data/providers/settings_provider.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/search_result_model.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});
  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;
    await context.read<ProductProvider>().searchProducts(query);

    if (mounted && context.read<ProductProvider>().errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.read<ProductProvider>().errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    context.watch<SettingsProvider>();
    final searchResponse = productProvider.lastSearch;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppMessages.compareTitle,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  Text(AppMessages.compareSubtitle,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 16),

                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onSubmitted: _performSearch,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: AppMessages.searchProductHint,
                      hintStyle: const TextStyle(color: AppColors.textHint),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppColors.primary),
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (productProvider.isLoading)
              const Expanded(
                  child: Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary)))
            else if (searchResponse == null)
              Expanded(
                child: Center(
                  child: Text(AppMessages.startComparingPrompt,
                      style: const TextStyle(color: AppColors.textSecondary)),
                ),
              )
            else if (productProvider.groupedProducts.isEmpty)
              Expanded(
                child: Center(
                  child: Text(AppMessages.noProductsFound,
                      style: const TextStyle(color: AppColors.textSecondary)),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: productProvider.groupedProducts.length,
                  itemBuilder: (_, i) => _ProductComparisonCard(
                    product: productProvider.groupedProducts[i],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProductComparisonCard extends StatelessWidget {
  final Product product;
  const _ProductComparisonCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: product.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.shopping_cart_outlined,
                                    color: AppColors.primary, size: 24),
                          ),
                        )
                      : const Icon(Icons.shopping_cart_outlined,
                          color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        product.category,
                        style: const TextStyle(
                            color: AppColors.textHint, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Consumer<FavoritesProvider>(
                  builder: (context, favorites, _) {
                    // Search for the original result of this product for favorites
                    final resultsForThisProduct = context
                        .read<ProductProvider>()
                        .products
                        .where((p) => p.name == product.name);

                    if (resultsForThisProduct.isEmpty) return const SizedBox();

                    final bestResult = resultsForThisProduct.firstWhere(
                      (p) => p.source == product.bestSupermarket,
                      orElse: () => resultsForThisProduct.first,
                    );

                    final isFav = favorites.isFavorite(bestResult);
                    return IconButton(
                      onPressed: () => favorites.toggleFavorite(bestResult),
                      icon: Icon(
                        isFav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFav ? Colors.red : AppColors.textHint,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              AppMessages.pricesPerSupermarket,
              style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            ...product.prices.entries.map((entry) {
              final isBest = entry.key == product.bestSupermarket;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isBest
                      ? AppColors.primary.withOpacity(0.08)
                      : AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isBest
                        ? AppColors.primary.withOpacity(0.3)
                        : AppColors.border,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _getLogo(entry.key),
                        const SizedBox(width: 10),
                        Text(
                          entry.key.toUpperCase(),
                          style: TextStyle(
                            color: isBest
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            fontWeight:
                                isBest ? FontWeight.w800 : FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          _formatPrice(entry.value),
                          style: TextStyle(
                            color: isBest
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                        if (isBest) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.primary, size: 18),
                        ],
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () => context
                              .read<ProductProvider>()
                              .trackProductClick(product,
                                  supermarket: entry.key),
                          icon: const Icon(Icons.shopping_bag_outlined,
                              size: 20, color: AppColors.primary),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            padding: const EdgeInsets.all(4),
                            minimumSize: const Size(32, 32),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
            if (product.prices.length > 1) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.savings_outlined,
                        color: Colors.green, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      '${AppMessages.savingsPrefix}${_formatPrice(product.savings)}${AppMessages.buyingAt}${product.bestSupermarket}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _getLogo(String source) {
    Color color;
    switch (source.toLowerCase()) {
      case 'alkosto':
        color = const Color(0xFF0033A0);
        break;
      case 'exito':
      case 'éxito':
        color = const Color(0xFFFFD100);
        break;
      case 'jumbo':
        color = const Color(0xFF00A34D);
        break;
      default:
        color = AppColors.primary;
    }
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  String _formatPrice(double price) {
    return '\$${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
