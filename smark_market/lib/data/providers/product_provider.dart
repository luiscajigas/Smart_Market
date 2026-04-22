import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/search_result_model.dart';
import '../models/product_model.dart';
import '../datasources/api_service.dart';
import '../services/history_service.dart';
import '../../../core/constants/app_messages.dart';
import '../../../core/constants/app_states.dart';

class ProductProvider extends ChangeNotifier {
  late HistoryService _historyService;
  bool _isLoading = false;
  String? _errorMessage;
  List<ProductResult> _products = [];
  SearchResponse? _lastSearch;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ProductResult> get products => _products;
  SearchResponse? get lastSearch => _lastSearch;

  ProductProvider() {
    _historyService = HistoryService(Supabase.instance.client);
  }

  // Products grouped for comparison
  List<Product> get groupedProducts {
    final Map<String, List<ProductResult>> grouped = {};
    for (var p in _products) {
      final key = (p.brand ?? 'Generic').toLowerCase() +
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
      final urls = <String, String>{};
      for (var r in results) {
        prices[r.source] = r.price;
        if (r.url != null) urls[r.source] = r.url!;
      }

      // Find best price for main buyUrl
      String? bestUrl;
      if (prices.isNotEmpty) {
        final bestSuper =
            prices.entries.reduce((a, b) => a.value < b.value ? a : b).key;
        bestUrl = urls[bestSuper];
      }

      return Product(
        id: e.key,
        name: results.first.name,
        category: results.first.category ?? 'General',
        imageEmoji: '🛒',
        imageUrl:
            results.first.images.isNotEmpty ? results.first.images.first : null,
        buyUrl: bestUrl,
        urls: urls,
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

  /// Search products by query
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

      // Record this search in history
      if (_products.isNotEmpty) {
        _recordSearchPattern(query, _products.first.category);
      }

      if (_products.isEmpty) _setError(AppMessages.noResults);
    } else {
      _setError(response.message);
    }
    _setLoading(false);
  }

  /// Track product click and record purchase intent
  Future<void> trackProductClick(Product product, {String? supermarket}) async {
    final superName = supermarket ?? product.bestSupermarket;
    final url = product.urls[superName] ?? product.buyUrl;

    if (url != null) {
      // Record in history first
      final price = product.prices[superName] ?? product.minPrice;
      await _historyService.recordEntry(
        name: product.name,
        price: price,
        category: product.category,
        source: AppStates.sourcePurchase,
      );

      // Open the link
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }

      // Reload featured products
      fetchFeaturedProducts();
    }
  }

  List<Product> _favoriteProducts = [];
  List<Product> get favoriteProducts => _favoriteProducts;

  /// Fetch featured products based on purchase history
  Future<void> fetchFeaturedProducts() async {
    try {
      final result = await _historyService.fetchUserHistory(limit: 10);

      if (result.isSuccess) {
        final List<Product> favs = [];
        final seenNames = <String>{};

        for (var item in result.data) {
          if (item['source'] != AppStates.sourcePurchase) continue;

          final name = item['name'] as String;
          if (!seenNames.contains(name)) {
            favs.add(Product(
              id: item['id'].toString(),
              name: name,
              category: item['category'] ?? 'General',
              imageEmoji: '🛒',
              prices: {'Supermercado': (item['price'] as num).toDouble()},
              unit: 'ud',
              buyUrl: item['url'],
            ));
            seenNames.add(name);
          }
        }
        _favoriteProducts = favs;
        notifyListeners();
      }

      // If no favorites or as complement, load general featured products
      if (_favoriteProducts.isEmpty) {
        _setLoading(true);
        final searchResponse = await ApiService.searchProducts('arroz');
        if (searchResponse.success && searchResponse.data != null) {
          _lastSearch = SearchResponse.fromList(searchResponse.data!, 'arroz');
          _products = _lastSearch!.results;
        }
        _setLoading(false);
      }
    } catch (e) {
      debugPrint('Error loading featured products: $e');
      _setLoading(false);
    }
  }

  /// Record search pattern in history
  Future<void> _recordSearchPattern(String query, String? category) async {
    await _historyService.recordEntry(
      name: query,
      price: 0,
      category: category ?? 'General',
      source: AppStates.sourceSearch,
    );
  }
}
