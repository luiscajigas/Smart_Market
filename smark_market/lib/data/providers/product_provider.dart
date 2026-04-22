import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/search_result_model.dart';
import '../models/product_model.dart';
import '../datasources/api_service.dart';
import '../../../core/constants/app_messages.dart';

class ProductProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<ProductResult> _products = [];
  SearchResponse? _lastSearch;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ProductResult> get products => _products;
  SearchResponse? get lastSearch => _lastSearch;

  // Productos agrupados para comparación
  List<Product> get groupedProducts {
    final Map<String, List<ProductResult>> grouped = {};
    for (var p in _products) {
      final key = (p.brand ?? 'Genérico').toLowerCase() +
          '_' +
          p.name
              .toLowerCase()
              .substring(0, (p.name.length > 10 ? 10 : p.name.length));
      if (!grouped.containsKey(key)) grouped[key] = [];
      grouped[key]!.add(p);
    }

    return grouped.entries.map((e) {
      final results = e.value;
      final prices = <String, double>{};
      for (var r in results) {
        prices[r.source] = r.price;
      }
      return Product(
        id: e.key,
        name: results.first.name,
        category: results.first.category ?? 'General',
        imageEmoji: '🛒',
        imageUrl:
            results.first.images.isNotEmpty ? results.first.images.first : null,
        prices: prices,
        unit: 'ud',
      );
    }).toList();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      _setError(AppMessages.emptyQuery);
      return;
    }

    _setLoading(true);
    _setError(null);

    final response = await ApiService.searchProducts(query);

    if (response.success && response.data != null) {
      _lastSearch = SearchResponse.fromList(response.data!, query);
      _products = _lastSearch!.results;

      // Registrar esta búsqueda como un "patrón de interés"
      if (_products.isNotEmpty) {
        _recordSearchPattern(query, _products.first.category);
      }

      if (_products.isEmpty) _setError(AppMessages.noResults);
    } else {
      _setError(response.message);
    }
    _setLoading(false);
  }

  Future<void> _recordSearchPattern(String query, String? category) async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user == null) return;

      await supabase.from('results').insert({
        'user_id': user.id,
        'name': query,
        'price': 0, // Es una búsqueda, no una compra
        'source': 'search',
        'category': category ?? 'General',
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error grabando patrón: $e');
    }
  }

  Future<void> fetchFeaturedProducts() async {
    _setLoading(true);
    // Simulación de productos destacados o una búsqueda por defecto
    final response = await ApiService.searchProducts('arroz');
    if (response.success && response.data != null) {
      _lastSearch = SearchResponse.fromList(response.data!, 'arroz');
      _products = _lastSearch!.results;
    }
    _setLoading(false);
  }
}
