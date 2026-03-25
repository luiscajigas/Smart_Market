import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../data/models/mock_data.dart';
import '../../widgets/savings_card.dart';
import '../../widgets/ai_banner.dart';
import '../../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;
  const HomeScreen({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    final nombre = userData?['nombre'] ?? 'Usuario';
    final products = MockData.products.take(4).toList();

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
                        Text('Hola, $nombre 👋',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                        const SizedBox(height: 2),
                        const Text('¿Qué compramos hoy?',
                          style: TextStyle(
                            color: AppColors.textPrimary, fontSize: 22,
                            fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                      ],
                    ),
                    Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.notifications_outlined,
                        color: AppColors.primary, size: 20),
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
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 16),
                        Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
                        SizedBox(width: 10),
                        Text('Buscar productos...',
                          style: TextStyle(color: AppColors.textHint, fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  const SavingsCard(),
                  const SizedBox(height: 20),

                  const AiBanner(),
                  const SizedBox(height: 24),

                  // Supermarkets
                  const Text('Supermercados cercanos',
                    style: TextStyle(
                      color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: MockData.supermarkets.length,
                      itemBuilder: (_, i) {
                        final s = MockData.supermarkets[i];
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(s.logo, style: const TextStyle(fontSize: 26)),
                              const SizedBox(height: 6),
                              Text(s.name, style: const TextStyle(
                                color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text('${s.distance}km',
                                style: const TextStyle(color: AppColors.textHint, fontSize: 10)),
                            ],
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
                      const Text('Productos destacados',
                        style: TextStyle(
                          color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
                      Text('Ver todos',
                        style: TextStyle(
                          color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_, i) => ProductCard(product: products[i]),
                childCount: products.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
}