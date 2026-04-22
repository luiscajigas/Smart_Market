import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_messages.dart';
import '../../../data/providers/favorites_provider.dart';
import '../../../data/providers/history_provider.dart';
import '../../../data/providers/settings_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load history when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().loadHistory();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final primaryColor =
        settings.isDarkMode ? AppColors.primaryGreen : AppColors.primaryBlue;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppMessages.historyTitle,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.titleLarge?.color,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5)),
                  Text(AppMessages.historySubtitle,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 13)),
                  const SizedBox(height: 16),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: primaryColor,
                    labelColor: primaryColor,
                    unselectedLabelColor:
                        Theme.of(context).textTheme.bodySmall?.color,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(text: AppMessages.historyTab),
                      Tab(text: AppMessages.favoritesTab),
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
    return Consumer<HistoryProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.history.isEmpty) {
          return Center(
              child: Text(AppMessages.noHistory,
                  style: const TextStyle(color: AppColors.textSecondary)));
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadHistory(),
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: provider.history.length,
            itemBuilder: (context, index) {
              final item = provider.history[index];
              final isPurchase = item['source'] == 'purchase';
              final settings = context.watch<SettingsProvider>();
              final primaryColor = settings.isDarkMode
                  ? AppColors.primaryGreen
                  : AppColors.primaryBlue;

              return Card(
                color: Theme.of(context).colorScheme.surface,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: isPurchase
                          ? primaryColor.withAlpha(77)
                          : Theme.of(context).dividerColor.withOpacity(0.1),
                      width: isPurchase ? 1.5 : 1,
                    )),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (isPurchase
                              ? primaryColor
                              : Theme.of(context).textTheme.bodySmall?.color ??
                                  AppColors.textHint)
                          .withAlpha(26),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPurchase
                          ? Icons.shopping_cart_checkout_rounded
                          : Icons.history_rounded,
                      color: isPurchase
                          ? primaryColor
                          : Theme.of(context).textTheme.bodySmall?.color,
                      size: 20,
                    ),
                  ),
                  title: Text(item['name'] ?? AppMessages.productLabel,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item['price'] != null && item['price'] > 0)
                        Text('\$${item['price']} COP',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600)),
                      Text(
                          isPurchase
                              ? AppMessages.purchaseAccess
                              : AppMessages.searchPerformed,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 11)),
                    ],
                  ),
                  trailing: isPurchase
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryColor.withAlpha(26),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(AppMessages.purchaseLabel,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        )
                      : Text(item['category'] ?? '',
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 10)),
                ),
              );
            },
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
          return Center(
              child: Text(AppMessages.noFavorites,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color)));
        }
        final settings = context.watch<SettingsProvider>();
        final primaryColor = settings.isDarkMode
            ? AppColors.primaryGreen
            : AppColors.primaryBlue;

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: favs.favorites.length,
          itemBuilder: (context, index) {
            final product = favs.favorites[index];
            return Card(
              color: Theme.of(context).colorScheme.surface,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.1))),
              child: ListTile(
                leading: const Icon(Icons.favorite_rounded, color: Colors.red),
                title: Text(product.name,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.bold)),
                subtitle: Text(
                    '\$${product.price.toStringAsFixed(0)} ${product.currency}',
                    style: TextStyle(color: primaryColor)),
                trailing: IconButton(
                  icon: Icon(Icons.delete_outline_rounded,
                      color: Theme.of(context).textTheme.bodySmall?.color),
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
