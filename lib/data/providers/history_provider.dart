import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/history_service.dart';
import '../../core/constants/app_states.dart';

class HistoryProvider extends ChangeNotifier {
  late HistoryService _historyService;
  List<Map<String, dynamic>> _history = [];
  String? _errorMessage;
  bool _isLoading = true;

  List<Map<String, dynamic>> get history =>
      _history.where((item) => item['source'] == 'purchase').toList();
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  HistoryProvider() {
    _historyService = HistoryService(Supabase.instance.client);
  }

  /// Load history from database
  Future<void> loadHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _historyService.fetchUserHistory();

    _history = result.data;
    _errorMessage = result.error;
    _isLoading = false;
    notifyListeners();
  }

  /// Record a purchase entry
  Future<bool> recordPurchase({
    required String productName,
    required double price,
    required String category,
  }) async {
    final success = await _historyService.recordEntry(
      name: productName,
      price: price,
      category: category,
      source: AppStates.sourcePurchase,
    );

    if (success) {
      // Refresh history to include the new entry
      await loadHistory();
    }

    return success;
  }

  /// Record a search entry
  Future<bool> recordSearch({
    required String query,
    required String category,
  }) async {
    final success = await _historyService.recordEntry(
      name: query,
      price: 0,
      category: category,
      source: AppStates.sourceSearch,
    );

    if (success) {
      // Refresh history to include the new entry
      await loadHistory();
    }

    return success;
  }

  /// Clear current error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
