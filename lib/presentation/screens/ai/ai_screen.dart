import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_messages.dart';
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

    // Real saving logic based on budget
    final totalSavingsProjected =
        products.fold(0.0, (sum, p) => sum + p.savings);
    final budgetPercent = settingsProvider.monthlyBudget > 0
        ? (totalSavingsProjected / settingsProvider.monthlyBudget)
            .clamp(0.0, 1.0)
        : 0.0;

    final recommendations = products
        .where((p) => p.prices.length > 1)
        .map((p) => AiRecommendation(
              title: '${AppMessages.saveOnPrefix}${p.name}',
              description:
                  '${AppMessages.bestPriceAtPrefix}${p.bestSupermarket}.${AppMessages.comparedToExpensiveSuffix}',
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
                      gradient: settingsProvider.isDarkMode
                          ? AppColors.primaryGradientGreen
                          : AppColors.primaryGradientBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                        child: Text('🤖', style: TextStyle(fontSize: 20))),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppMessages.aiTitle,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.titleLarge?.color,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5)),
                      Text(AppMessages.aiSubtitle,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 13)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  _StatChip(
                      label: AppMessages.projectedSavings,
                      value: '\$${totalSavingsProjected.toStringAsFixed(0)}',
                      icon: '💰'),
                  const SizedBox(width: 10),
                  _StatChip(
                      label: AppMessages.budgetImpact,
                      value: '${(budgetPercent * 100).toStringAsFixed(1)}%',
                      icon: '🔮'),
                ],
              ),
              const SizedBox(height: 24),

              Text(AppMessages.activeRecommendations,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.titleMedium?.color,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(AppMessages.basedOnPatterns,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 13)),
              const SizedBox(height: 14),

              if (recommendations.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(AppMessages.notEnoughRecommendations,
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodySmall?.color)),
                  ),
                )
              else
                ...recommendations.map((r) => RecommendationCard(rec: r)),

              const SizedBox(height: 24),

              // Real consumption analysis
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: Theme.of(context).dividerColor.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('📊', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(AppMessages.consumptionAnalysis,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.color,
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (products.isEmpty)
                      Text(AppMessages.searchingToAnalyze,
                          style: const TextStyle(color: AppColors.textHint))
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
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(AppMessages.analyzedLabel,
                                              style: const TextStyle(
                                                  color: AppColors.textHint,
                                                  fontSize: 11)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(3),
                                        child: LinearProgressIndicator(
                                          value: 0.8,
                                          backgroundColor: Theme.of(context)
                                              .dividerColor
                                              .withOpacity(0.1),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  settingsProvider.isDarkMode
                                                      ? AppColors.primaryGreen
                                                      : AppColors.primaryBlue),
                                          minHeight: 6,
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

              // Real Location
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFF7C4DFF).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📍 ${AppMessages.nearbySupermarkets}',
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.titleSmall?.color,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    if (locationProvider.isLoading)
                      Center(
                          child: CircularProgressIndicator(
                              color: settingsProvider.isDarkMode
                                  ? AppColors.primaryGreen
                                  : AppColors.primaryBlue))
                    else if (locationProvider.error != null)
                      Text(locationProvider.error!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12))
                    else if (nearbySupermarkets.isEmpty)
                      Text(AppMessages.noResults,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 12))
                    else
                      ...nearbySupermarkets.take(3).map((s) {
                        final shop = s['supermarket'] as SupermarketLocation;
                        final distance = s['distance'] as double;
                        final isNearest = nearbySupermarkets.indexOf(s) == 0;
                        final primaryColor = settingsProvider.isDarkMode
                            ? AppColors.primaryGreen
                            : AppColors.primaryBlue;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isNearest
                                ? primaryColor.withOpacity(0.1)
                                : Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: isNearest
                                    ? primaryColor.withOpacity(0.4)
                                    : Theme.of(context)
                                        .dividerColor
                                        .withOpacity(0.1)),
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
                                              ? primaryColor
                                              : Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13)),
                                  Text(shop.address,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.color,
                                          fontSize: 10)),
                                ],
                              )),
                              Text('${distance.toStringAsFixed(1)} km',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                      fontSize: 12)),
                              if (isNearest) ...[
                                const SizedBox(width: 8),
                                Icon(Icons.check_circle,
                                    color: primaryColor, size: 16),
                              ],
                            ],
                          ),
                        );
                      }),
                    const SizedBox(height: 12),
                    if (nearbySupermarkets.isNotEmpty)
                      Row(
                        children: [
                          const Text('⚡', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${AppMessages.nearestSupermarketRecommendation}${(nearbySupermarkets.first['supermarket'] as SupermarketLocation).name}${AppMessages.nearestSupermarketSuffix}',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
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
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 11)),
                  Text(value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.titleMedium?.color,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
