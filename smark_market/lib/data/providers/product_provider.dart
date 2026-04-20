import 'package:flutter/material.dart';
import '../models/search_result_model.dart';
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
      if (_products.isEmpty) _setError(AppMessages.noResults);
    } else {
      _setError(response.message);
    }
    _setLoading(false);
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
