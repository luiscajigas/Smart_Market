import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/mock_data.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/product_provider.dart';
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
    // Cargar productos destacados al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchFeaturedProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final productProvider = context.watch<ProductProvider>();

    final metadata = authProvider.currentUser?.userMetadata;
    final nombre = metadata?['full_name'] ?? 'Usuario';

    final products = productProvider.groupedProducts.take(4).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            snap: true,
            backgroundColor: AppColors.background,
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
                        Text('Hola, $nombre',
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 14)),
                        const SizedBox(height: 2),
                        const Text('¿Qué compramos hoy?',
                            style: TextStyle(
                                color: AppColors.textPrimary,
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
                    onTap: () {
                      // Redirigir a la pestaña de comparar (índice 1 en MainShell)
                      final state =
                          context.findAncestorStateOfType<MainShellState>();
                      if (state != null) {
                        state.updateIndex(1);
                      }
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 16),
                          Icon(Icons.search_rounded,
                              color: AppColors.textHint, size: 20),
                          SizedBox(width: 10),
                          Text('Buscar productos para comparar...',
                              style: TextStyle(
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
                  const Text('Supermercados cercanos',
                      style: TextStyle(
                          color: AppColors.textPrimary,
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
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const SupermarketMapScreen())),
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
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
                                    style: const TextStyle(
                                        color: AppColors.textPrimary,
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

                  // Products header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Productos destacados', //
                          style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w800)),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProductListScreen())),
                        child: const Text('Ver todos',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: productProvider.isLoading
                ? const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()))
                : SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => ProductCard(product: products[i]),
                      childCount: products.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                  ),
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
        title: const Text('Notificaciones',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.notifications_active_outlined,
                  color: AppColors.primary),
              title: Text('Oferta en Arroz',
                  style: TextStyle(color: AppColors.textPrimary)),
              subtitle: Text('Bajo un 10% en Éxito hoy.',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
            ListTile(
              leading: Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text('Búsqueda completada',
                  style: TextStyle(color: AppColors.textPrimary)),
              subtitle: Text('Encontramos 5 nuevas ofertas.',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar')),
        ],
      ),
    );
  }
}
