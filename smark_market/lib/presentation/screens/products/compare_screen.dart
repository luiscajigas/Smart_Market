import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/providers/product_provider.dart';
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
                  const Text('Comparar precios',
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  const Text('Encuentra el mejor precio por supermercado',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 14)),
                  const SizedBox(height: 16),

                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onSubmitted: _performSearch,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Buscar producto (ej. Leche, Arroz...)',
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
              const Expanded(
                child: Center(
                  child: Text('Busca algo para empezar a comparar',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              )
            else if (searchResponse.results.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('No se encontraron productos',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: searchResponse.results.length,
                  itemBuilder: (_, i) => _ProductResultCard(
                    result: searchResponse.results[i],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProductResultCard extends StatelessWidget {
  final ProductResult result;
  const _ProductResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSourceColor(result.source).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    result.source.toUpperCase(),
                    style: TextStyle(
                      color: _getSourceColor(result.source),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                if (result.brand != null)
                  Text(
                    result.brand!,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (result.images.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      result.images.first,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        color: AppColors.border.withOpacity(0.2),
                        child: const Icon(Icons.image_not_supported_rounded,
                            color: AppColors.textHint),
                      ),
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            _formatPrice(result.price),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (result.oldPrice != null)
                            Text(
                              _formatPrice(result.oldPrice!),
                              style: const TextStyle(
                                color: AppColors.textHint,
                                fontSize: 13,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (result.url != null)
                  IconButton(
                    onPressed: () {
                      // TODO: Implement URL launcher
                    },
                    icon: const Icon(Icons.open_in_new_rounded,
                        color: AppColors.primary, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getSourceColor(String source) {
    switch (source.toLowerCase()) {
      case 'alkosto':
        return const Color(0xFF0033A0); // Azul Alkosto
      case 'exito':
      case 'éxito':
        return const Color(0xFFFFD100); // Amarillo Éxito
      case 'jumbo':
        return const Color(0xFF00A34D); // Verde Jumbo
      default:
        return AppColors.primary;
    }
  }

  String _formatPrice(double price) {
    return '\$${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
