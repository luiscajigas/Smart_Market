import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AiBanner extends StatelessWidget {
  const AiBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text('🤖', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('IA recomienda',
                    style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                SizedBox(height: 2),
                Text(
                  'Puedes ahorrar \$22.000 este mes comprando en 2 supermercados.',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textHint, size: 14),
        ],
      ),
    );
  }
}