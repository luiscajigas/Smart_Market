import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/providers/favorites_provider.dart';
import '../../../data/models/search_result_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchHistory() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('results')
          .select()
          .order('created_at', ascending: false)
          .limit(20);

      if (mounted) {
        setState(() {
          _history = List<Map<String, dynamic>>.from(response);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Historial y Favoritos',
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5)),
                  const SizedBox(height: 16),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.primary,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: const [
                      Tab(text: 'Historial'),
                      Tab(text: 'Favoritos'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHistoryTab(),
                  _buildFavoritesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_history.isEmpty) {
      return const Center(
          child: Text('No hay búsquedas recientes',
              style: TextStyle(color: AppColors.textSecondary)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final item = _history[index];
        return Card(
          color: AppColors.cardBackground,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: AppColors.border)),
          child: ListTile(
            leading:
                const Icon(Icons.history_rounded, color: AppColors.textHint),
            title: Text(item['name'] ?? 'Producto',
                style: const TextStyle(
                    color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
            subtitle: Text('\$${item['price']} COP',
                style: const TextStyle(color: AppColors.primary)),
            trailing: Text(item['source']?.toString().toUpperCase() ?? '',
                style:
                    const TextStyle(color: AppColors.textHint, fontSize: 10)),
          ),
        );
      },
    );
  }

  Widget _buildFavoritesTab() {
    return Consumer<FavoritesProvider>(
      builder: (context, favs, _) {
        if (favs.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (favs.favorites.isEmpty) {
          return const Center(
              child: Text('No tienes productos favoritos',
                  style: TextStyle(color: AppColors.textSecondary)));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: favs.favorites.length,
          itemBuilder: (context, index) {
            final product = favs.favorites[index];
            return Card(
              color: AppColors.cardBackground,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: AppColors.border)),
              child: ListTile(
                leading: const Icon(Icons.favorite_rounded, color: Colors.red),
                title: Text(product.name,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold)),
                subtitle: Text(
                    '\$${product.price.toStringAsFixed(0)} ${product.currency}',
                    style: const TextStyle(color: AppColors.primary)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.textHint),
                  onPressed: () => favs.toggleFavorite(product),
                ),
              ),
            );
          },
        );
      },
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
        Text(label,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: color, fontSize: 16, fontWeight: FontWeight.w800)),
      ],
    );
  }
}
