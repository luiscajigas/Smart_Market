import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../data/models/mock_data.dart';
import '../../widgets/recommendation_card.dart';

class AiScreen extends StatelessWidget {
  const AiScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text('🤖', style: TextStyle(fontSize: 20))),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Smart IA',
                        style: TextStyle(
                          color: AppColors.textPrimary, fontSize: 22,
                          fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                      Text('Motor de recomendación inteligente',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  _StatChip(label: 'Ahorro mes', value: '\$22.000', icon: '💰'),
                  const SizedBox(width: 10),
                  _StatChip(label: 'Predicciones', value: '3 activas', icon: '🔮'),
                ],
              ),
              const SizedBox(height: 24),

              const Text('Recomendaciones activas',
                style: TextStyle(
                  color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              const Text('Basadas en tus patrones de compra',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 14),

              ...MockData.recommendations.map((r) => RecommendationCard(rec: r)),

              const SizedBox(height: 24),

              // Consumo
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
                            color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...[
                      ('Arroz Diana', '🌾', 'Cada 15 días', 0.9),
                      ('Leche Alpina', '🥛', 'Cada 7 días', 0.7),
                      ('Huevos AA', '🥚', 'Cada 10 días', 0.6),
                      ('Pan tajado', '🍞', 'Cada 5 días', 0.8),
                    ].map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: [
                          Text(item.$2, style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item.$1, style: const TextStyle(
                                      color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
                                    Text(item.$3, style: const TextStyle(
                                      color: AppColors.textHint, fontSize: 11)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: LinearProgressIndicator(
                                    value: item.$4,
                                    backgroundColor: AppColors.border,
                                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
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

              const SizedBox(height: 20),

              // Ubicación
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF7C4DFF).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('📍 Optimización por ubicación',
                      style: TextStyle(
                        color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    ...[
                      ('Carulla', '0.8km', '\$187.400', true),
                      ('Éxito', '1.2km', '\$182.300', false),
                      ('Jumbo', '2.8km', '\$178.900', false),
                    ].map((s) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: s.$4 ? AppColors.primary.withOpacity(0.1) : AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: s.$4 ? AppColors.primary.withOpacity(0.4) : AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Text(s.$1, style: TextStyle(
                            color: s.$4 ? AppColors.primary : AppColors.textPrimary,
                            fontWeight: FontWeight.w600, fontSize: 13))),
                          Text(s.$2, style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
                          const SizedBox(width: 12),
                          Text(s.$3, style: TextStyle(
                            color: s.$4 ? AppColors.primary : AppColors.textSecondary,
                            fontWeight: FontWeight.w700, fontSize: 13)),
                          if (s.$4) ...[
                            const SizedBox(width: 6),
                            const Text('✓', style: TextStyle(
                              color: AppColors.primary, fontWeight: FontWeight.w800)),
                          ],
                        ],
                      ),
                    )),
                    const SizedBox(height: 8),
                    const Text(
                      '⚡ Recomendación: Carulla por eficiencia general (precio + distancia)',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4)),
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
  const _StatChip({required this.label, required this.value, required this.icon});

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
                Text(label, style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
                Text(value, style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}