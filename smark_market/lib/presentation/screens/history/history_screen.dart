import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isLoading = true;
  List<dynamic> _history = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final supabase = Supabase.instance.client;
      // Consultamos la tabla 'results' que es donde el backend guarda las búsquedas
      final response = await supabase
          .from('results')
          .select()
          .order('created_at', ascending: false)
          .limit(20);

      if (mounted) {
        setState(() {
          _history = response;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error cargando historial: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatDate(String dateStr) {
    try {
      final d = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(d).inDays;
      if (diff == 0) return 'Hoy';
      if (diff == 1) return 'Ayer';
      return 'Hace $diff días';
    } catch (e) {
      return 'Reciente';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Historial de Búsquedas',
                    style: TextStyle(
                      color: AppColors.textPrimary, fontSize: 24,
                      fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  const Text('Lo que has comparado recientemente',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _SummaryItem(
                          label: 'Búsquedas', 
                          value: '${_history.length}', 
                          color: AppColors.primary
                        ),
                        Container(width: 1, height: 40, color: AppColors.border),
                        const _SummaryItem(
                          label: 'Estado', 
                          value: 'Sincronizado', 
                          color: Color(0xFF00BCD4)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _history.isEmpty
                  ? const Center(
                      child: Text('No hay búsquedas recientes', 
                        style: TextStyle(color: AppColors.textSecondary)))
                  : RefreshIndicator(
                      onRefresh: _fetchHistory,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _history.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) {
                          final h = _history[i];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48, height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.inputBackground,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.search_rounded, 
                                      color: AppColors.primary, size: 24)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(h['query'] ?? 'Sin consulta', 
                                        style: const TextStyle(
                                          color: AppColors.textPrimary, 
                                          fontSize: 14, 
                                          fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 2),
                                      Text(h['title'] ?? 'Producto',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary, 
                                          fontSize: 12)),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Text('\$${h['price']}',
                                            style: const TextStyle(
                                              color: AppColors.primary, 
                                              fontSize: 12, 
                                              fontWeight: FontWeight.bold)),
                                          const Text(' · ',
                                            style: TextStyle(color: AppColors.textHint)),
                                          Text(_formatDate(h['created_at'] ?? ''),
                                            style: const TextStyle(
                                              color: AppColors.textHint, 
                                              fontSize: 12)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded, 
                                  color: AppColors.textHint),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w800)),
      ],
    );
  }
}