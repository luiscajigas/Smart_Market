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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(result.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              '${result.price} ${result.currency}',
              style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text('Puntuación: ${result.score.toStringAsFixed(2)}',
                style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.open_in_new_rounded, color: AppColors.primary),
          onPressed: () {
            // Open link logic could go here
          },
        ),
      ),
    );
  }
}
