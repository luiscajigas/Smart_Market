import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_messages.dart';
import '../../../data/models/mock_data.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/product_provider.dart';
import '../../../data/providers/settings_provider.dart';
import '../../widgets/savings_card.dart';
import '../../widgets/ai_banner.dart';
import '../../widgets/product_card.dart';
import 'main_shell.dart';
import '../products/product_list_screen.dart';
import 'supermarket_map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load featured products on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchFeaturedProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final productProvider = context.watch<ProductProvider>();
    context.watch<SettingsProvider>();

    final metadata = authProvider.currentUser?.userMetadata;
    final name = metadata?['full_name'] ?? 'User';

    // Use favorite products if they exist, otherwise featured ones
    final displayProducts = productProvider.favoriteProducts.isNotEmpty
        ? productProvider.favoriteProducts.take(4).toList()
        : productProvider.groupedProducts.take(4).toList();

    final isUsingFavorites = productProvider.favoriteProducts.isNotEmpty;
    final hasProducts = displayProducts.isNotEmpty;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            snap: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${AppMessages.hiGreeting}$name',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withOpacity(0.7),
                                fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(AppMessages.buyTodayPrompt,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.color,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5)),
                      ],
                    ),
                    IconButton(
                      onPressed: () => _showNotifications(context),
                      icon: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.3)),
                        ),
                        child: const Icon(Icons.notifications_outlined,
                            color: AppColors.primary, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // Redirect to compare tab (index 1 in MainShell)
                      final state =
                          context.findAncestorStateOfType<MainShellState>();
                      if (state != null) {
                        state.updateIndex(1);
                      }
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: Theme.of(context)
                                .dividerColor
                                .withOpacity(0.1)),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          const Icon(Icons.search_rounded,
                              color: AppColors.textHint, size: 20),
                          const SizedBox(width: 10),
                          Text(AppMessages.searchProductsHint,
                              style: const TextStyle(
                                  color: AppColors.textHint, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const SavingsCard(),
                  const SizedBox(height: 16),

                  const AiBanner(),
                  const SizedBox(height: 24),

                  // Supermarkets
                  Text(AppMessages.nearbySupermarkets,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.titleMedium?.color,
                          fontSize: 16,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: MockData.supermarkets.length,
                      itemBuilder: (_, i) {
                        final shop = MockData.supermarkets[i];
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const SupermarketMapScreen())),
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withOpacity(0.1)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(shop.logo,
                                      style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(height: 8),
                                Text(shop.name,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                                Text('${shop.distance}km',
                                    style: const TextStyle(
                                        color: AppColors.textHint,
                                        fontSize: 10)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Featured Products
                  if (hasProducts) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            isUsingFavorites
                                ? AppMessages.yourFavorites
                                : AppMessages.featuredProducts,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.color,
                                fontSize: 16,
                                fontWeight: FontWeight.w800)),
                        TextButton(
                          onPressed: () {
                            final state = context
                                .findAncestorStateOfType<MainShellState>();
                            if (state != null) {
                              state.updateIndex(1);
                            }
                          },
                          child: Text(AppMessages.seeAllAction),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
          if (hasProducts)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => ProductCard(product: displayProducts[i]),
                  childCount: displayProducts.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
              ),
            ),
          // Loading state if needed
          if (productProvider.isFeaturedLoading && !hasProducts)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(AppMessages.notificationsTitle,
            style: const TextStyle(color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.notifications_active_outlined,
                  color: AppColors.primary),
              title: Text(AppMessages.riceOfferTitle,
                  style: const TextStyle(color: AppColors.textPrimary)),
              subtitle: Text(AppMessages.riceOfferDesc,
                  style: const TextStyle(color: AppColors.textSecondary)),
            ),
            ListTile(
              leading: Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text(AppMessages.searchCompletedTitle,
                  style: const TextStyle(color: AppColors.textPrimary)),
              subtitle: Text(AppMessages.searchCompletedDesc,
                  style: const TextStyle(color: AppColors.textSecondary)),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppMessages.closeAction)),
        ],
      ),
    );
  }
}
