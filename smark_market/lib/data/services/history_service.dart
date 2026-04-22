import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_states.dart';

class HistoryResult {
  final List<Map<String, dynamic>> data;
  final String? error;

  HistoryResult({required this.data, this.error});

  bool get isSuccess => error == null;
}

class HistoryService {
  final SupabaseClient _supabaseClient;

  HistoryService(this._supabaseClient);

  /// Fetch user's history from database
  Future<HistoryResult> fetchUserHistory({
    int limit = 20,
  }) async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        return HistoryResult(
          data: [],
          error: AppStates.errorUserNotFound,
        );
      }

      final response = await _supabaseClient
          .from('results')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(limit);

      final history = List<Map<String, dynamic>>.from(response);
      return HistoryResult(data: history, error: null);
    } catch (e) {
      return HistoryResult(
        data: [],
        error: AppStates.errorLoadingHistory,
      );
    }
  }

  /// Record an entry in the history table
  Future<bool> recordEntry({
    required String name,
    required double price,
    required String source,
    required String category,
  }) async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        return false;
      }

      await _supabaseClient.from('results').insert({
        'user_id': user.id,
        'name': name,
        'price': price,
        'source': source,
        'category': category,
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}
