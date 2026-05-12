import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_messages.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/product_provider.dart';
import '../../../data/providers/settings_provider.dart';
import '../../../data/providers/favorites_provider.dart';
import '../../../data/providers/location_provider.dart';
import '../../../data/providers/history_provider.dart';
import '../../../data/models/search_result_model.dart';
import '../../../data/models/product_model.dart';
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
    // Load featured products and favorites on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProductProvider>().fetchFeaturedProducts();
        context.read<FavoritesProvider>().refresh();
        final location = context.read<LocationProvider>();
        location.startTracking();
        location.loadSupermarketLocations();
        context.read<HistoryProvider>().loadHistory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final productProvider = context.watch<ProductProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();
    final locationProvider = context.watch<LocationProvider>();
    final settings = context.watch<SettingsProvider>();
    final primaryColor =
        settings.isDarkMode ? AppColors.primaryGreen : AppColors.primaryBlue;

    final metadata = authProvider.currentUser?.userMetadata;
    final name = metadata?['full_name'] ?? 'User';

    // Prioritize favorites from FavoritesProvider, then from ProductProvider history
    List<Product> displayProducts = [];
    bool isUsingFavorites = false;

    if (favoritesProvider.favorites.isNotEmpty) {
      displayProducts = favoritesProvider.favorites.take(4).map((fav) {
        return Product(
          id: fav.url ?? fav.name,
          name: fav.name,
          category: fav.category ?? 'General',
          imageEmoji: '🛒',
          imageUrl: fav.images.isNotEmpty ? fav.images.first : null,
          buyUrl: fav.url,
          prices: {fav.source: fav.price},
          urls: fav.url != null ? {fav.source: fav.url!} : {},
          unit: 'ud',
        );
      }).toList();
      isUsingFavorites = true;
    } else if (productProvider.favoriteProducts.isNotEmpty) {
      // Fallback to purchase history products
      displayProducts = productProvider.favoriteProducts.take(4).toList();
      isUsingFavorites = true;
    } else if (!favoritesProvider.isLoading &&
        !productProvider.isFeaturedLoading) {
      // Fallback to featured products ONLY if not loading favorites/history
      displayProducts = productProvider.groupedProducts.take(4).toList();
      isUsingFavorites = false;
    }

    final hasProducts = displayProducts.isNotEmpty;
    final isLoading =
        favoritesProvider.isLoading || productProvider.isFeaturedLoading;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        key: const PageStorageKey('home_scroll_view'),
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
                      icon: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: primaryColor.withOpacity(0.3)),
                            ),
                          ),
                          Icon(Icons.notifications_none_rounded,
                              color: primaryColor, size: 20),
                        ],
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
                  if (locationProvider.isSupermarketsLoading)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: LinearProgressIndicator(minHeight: 2),
                    )
                  else if (locationProvider.supermarketsError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              locationProvider.supermarketsError!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => locationProvider
                                .loadSupermarketLocations(),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: locationProvider.supermarketChains.length,
                      itemBuilder: (_, i) {
                        final shop = locationProvider.supermarketChains[i];
                        final distanceKm =
                            locationProvider.distanceKmToChain(shop.id);

                        return GestureDetector(
                          key: ValueKey('supermarket_${shop.id}'),
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
                                    color: primaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(shop.logo,
                                      style: TextStyle(
                                          color: primaryColor,
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
                                Text(
                                    distanceKm == null
                                        ? '— km'
                                        : '${distanceKm.toStringAsFixed(1)} km',
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
                ],
              ),
            ),
          ),

          // Products Section (Header + Grid/Empty)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isUsingFavorites
                            ? AppMessages.yourFavorites
                            : AppMessages.featuredProducts,
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.titleMedium?.color,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                      TextButton(
                        onPressed: () {
                          final state =
                              context.findAncestorStateOfType<MainShellState>();
                          if (state != null) {
                            state.updateIndex(isUsingFavorites ? 3 : 1);
                          }
                        },
                        child: Text(AppMessages.seeAllAction,
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: hasProducts
                      ? GridView.builder(
                          key: const ValueKey('home_products_grid_stable'),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                          ),
                          itemCount: displayProducts.length,
                          itemBuilder: (context, index) {
                            final product = displayProducts[index];
                            return ProductCard(
                              key: ValueKey('prod_home_${product.id}'),
                              product: product,
                            );
                          },
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    isUsingFavorites
                                        ? AppMessages.noFavorites
                                        : AppMessages.noResults,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color),
                                  ),
                          ),
                        ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    final settings = context.read<SettingsProvider>();
    final primaryColor =
        settings.isDarkMode ? AppColors.primaryGreen : AppColors.primaryBlue;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(AppMessages.notificationsTitle,
            style: TextStyle(
                color: Theme.of(context).textTheme.titleLarge?.color)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.notifications_active_outlined,
                  color: primaryColor),
              title: Text(AppMessages.riceOfferTitle,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.titleSmall?.color)),
              subtitle: Text(AppMessages.riceOfferDesc,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color)),
            ),
            ListTile(
              leading:
                  const Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text(AppMessages.searchCompletedTitle,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.titleSmall?.color)),
              subtitle: Text(AppMessages.searchCompletedDesc,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color)),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppMessages.closeAction,
                  style: TextStyle(color: primaryColor))),
        ],
      ),
    );
  }
}
