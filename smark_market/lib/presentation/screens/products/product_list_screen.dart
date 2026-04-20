import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/datasources/api_service.dart';
import '../../../data/models/search_result_model.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _isLoading = true;
  List<ProductResult> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    // Por ahora traemos una búsqueda por defecto o las últimas guardadas
    final response = await ApiService.searchProducts('arroz'); // Ejemplo
    if (mounted) {
      setState(() {
        if (response.success && response.data != null) {
          final searchResponse = SearchResponse.fromList(response.data!, 'arroz');
          _products = searchResponse.results;
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Productos Comparados',
            style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : _products.isEmpty
              ? const Center(
                  child: Text('No hay productos disponibles',
                      style: TextStyle(color: AppColors.textSecondary)))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75, // Ajustado para el diseño real
                    ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return Card(
                        color: AppColors.cardBackground,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Center(
                                  child: product.images.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            product.images.first,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error,
                                                    stackTrace) =>
                                                Icon(Icons.inventory_2_outlined,
                                                    color: AppColors.primary
                                                        .withOpacity(0.5),
                                                    size: 48),
                                          ),
                                        )
                                      : Icon(Icons.inventory_2_outlined,
                                          color: AppColors.primary
                                              .withOpacity(0.5),
                                          size: 48),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                              const SizedBox(height: 4),
                              Text(
                                  '\$${product.price.toStringAsFixed(0).replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}.")}',
                                  style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15)),
                              const SizedBox(height: 2),
                              Text(product.source.toUpperCase(),
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
