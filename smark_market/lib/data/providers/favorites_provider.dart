import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/search_result_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  List<ProductResult> _favorites = [];
  bool _isLoading = false;

  List<ProductResult> get favorites => _favorites;
  bool get isLoading => _isLoading;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _client
          .from('favorites')
          .select()
          .eq('user_id', user.id);

      _favorites = (response as List)
          .map((item) => ProductResult.fromJson({
                ...item['product_data'],
                'is_favorite': true,
              }))
          .toList();
    } catch (e) {
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(ProductResult product) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final isExist = _favorites.any((f) => f.url == product.url);

    try {
      if (isExist) {
        await _client
            .from('favorites')
            .delete()
            .eq('user_id', user.id)
            .eq('product_url', product.url!);
        _favorites.removeWhere((f) => f.url == product.url);
        product.isFavorite = false;
      } else {
        final data = {
          'user_id': user.id,
          'product_url': product.url,
          'product_data': product.toJson(),
          'created_at': DateTime.now().toIso8601String(),
        };
        await _client.from('favorites').insert(data);
        _favorites.add(product);
        product.isFavorite = true;
      }
      notifyListeners();
    } catch (e) {
    }
  }

  bool isFavorite(ProductResult product) {
    return _favorites.any((f) => f.url == product.url);
  }
}
