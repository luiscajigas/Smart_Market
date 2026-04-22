import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/product_model.dart';

class RecommendationCard extends StatelessWidget {
  final AiRecommendation rec;
  const RecommendationCard({super.key, required this.rec});

  Color get _color {
    switch (rec.type) {
      case 'saving': return AppColors.primary;
      case 'prediction': return const Color(0xFF7C4DFF);
      case 'location': return const Color(0xFF00BCD4);
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: _color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(rec.icon, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rec.title,
                  style: TextStyle(color: _color, fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(rec.description,
                  style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12, height: 1.5),
                  maxLines: 3, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}