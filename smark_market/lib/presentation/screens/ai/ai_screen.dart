import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/product_model.dart';
import '../../../data/providers/product_provider.dart';
import '../../../data/providers/location_provider.dart';
import '../../../data/providers/settings_provider.dart';
import '../../widgets/recommendation_card.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().determinePosition();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final locationProvider = context.watch<LocationProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    final products = productProvider.groupedProducts;
    final nearbySupermarkets = locationProvider.getNearbySupermarkets();

    // Lógica real de ahorro basada en presupuesto
    final totalSavingsProyected =
        products.fold(0.0, (sum, p) => sum + p.savings);
    final budgetPercent = settingsProvider.monthlyBudget > 0
        ? (totalSavingsProyected / settingsProvider.monthlyBudget)
            .clamp(0.0, 1.0)
        : 0.0;

    final recommendations = products
        .where((p) => p.prices.length > 1)
        .map((p) => AiRecommendation(
              title: 'Ahorra en ${p.name}',
              description:
                  'El mejor precio está en ${p.bestSupermarket}. Ahorras \$${p.savings.toStringAsFixed(0)} comparado con el más caro.',
              type: 'saving',
              savingAmount: p.savings,
              icon: '💰',
            ))
        .take(3)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                        child: Text('🤖', style: TextStyle(fontSize: 20))),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Smart IA',
                          style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5)),
                      Text('Motor de recomendación inteligente',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  _StatChip(
                      label: 'Ahorro proyectado',
                      value: '\$${totalSavingsProyected.toStringAsFixed(0)}',
                      icon: '💰'),
                  const SizedBox(width: 10),
                  _StatChip(
                      label: 'Impacto presupuesto',
                      value: '${(budgetPercent * 100).toStringAsFixed(1)}%',
                      icon: '🔮'),
                ],
              ),
              const SizedBox(height: 24),

              const Text('Recomendaciones activas',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              const Text('Basadas en tus patrones de compra',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 14),

              if (recommendations.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('No hay recomendaciones suficientes todavía',
                        style: TextStyle(color: AppColors.textSecondary)),
                  ),
                )
              else
                ...recommendations.map((r) => RecommendationCard(rec: r)),

              const SizedBox(height: 24),

              // Análisis de consumo real
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('📊', style: TextStyle(fontSize: 20)),
                        SizedBox(width: 8),
                        Text('Análisis de consumo',
                            style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (products.isEmpty)
                      const Text('Buscando productos para analizar...',
                          style: TextStyle(color: AppColors.textHint))
                    else
                      ...products.take(4).map((p) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              children: [
                                const Text('🛒',
                                    style: TextStyle(fontSize: 18)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(p.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color:
                                                        AppColors.textPrimary,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text('Analizado',
                                              style: TextStyle(
                                                  color: AppColors.textHint,
                                                  fontSize: 11)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(3),
                                        child: const LinearProgressIndicator(
                                          value: 0.8,
                                          backgroundColor: AppColors.border,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppColors.primary),
                                          minHeight: 5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Ubicación Real
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFF7C4DFF).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('📍 Supermercados cercanos',
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    if (locationProvider.isLoading)
                      const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary))
                    else if (locationProvider.error != null)
                      Text(locationProvider.error!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12))
                    else if (nearbySupermarkets.isEmpty)
                      const Text('No se detectaron supermercados cerca.',
                          style: TextStyle(
                              color: AppColors.textHint, fontSize: 12))
                    else
                      ...nearbySupermarkets.take(3).map((s) {
                        final shop = s['supermarket'] as SupermarketLocation;
                        final distance = s['distance'] as double;
                        final isNearest = nearbySupermarkets.indexOf(s) == 0;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isNearest
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.inputBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: isNearest
                                    ? AppColors.primary.withOpacity(0.4)
                                    : AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(shop.name,
                                      style: TextStyle(
                                          color: isNearest
                                              ? AppColors.primary
                                              : AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13)),
                                  Text(shop.address,
                                      style: const TextStyle(
                                          color: AppColors.textHint,
                                          fontSize: 10)),
                                ],
                              )),
                              Text('${distance.toStringAsFixed(1)} km',
                                  style: const TextStyle(
                                      color: AppColors.textHint, fontSize: 12)),
                              if (isNearest) ...[
                                const SizedBox(width: 8),
                                const Icon(Icons.check_circle,
                                    color: AppColors.primary, size: 16),
                              ],
                            ],
                          ),
                        );
                      }),
                    const SizedBox(height: 8),
                    if (nearbySupermarkets.isNotEmpty)
                      Text(
                          '⚡ Recomendación: ${(nearbySupermarkets.first['supermarket'] as SupermarketLocation).name} es el más cercano a tu ubicación actual.',
                          style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label, value, icon;
  const _StatChip(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppColors.textHint, fontSize: 11)),
                Text(value,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
