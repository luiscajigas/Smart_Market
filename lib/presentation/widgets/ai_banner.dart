import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_messages.dart';
import '../../data/providers/settings_provider.dart';

class AiBanner extends StatelessWidget {
  const AiBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final primaryColor =
        settings.isDarkMode ? AppColors.primaryGreen : AppColors.primaryBlue;
    final savingsText =
        '${AppMessages.saveAmountMonthPrefix}\$20${AppMessages.saveAmountMonthSuffix}';

    return GestureDetector(
      onTap: () => _showAiRecommendations(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(Icons.psychology_outlined,
                    color: primaryColor, size: 28),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppMessages.aiRecommends,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.titleMedium?.color,
                          fontSize: 16,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(savingsText,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 13)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).textTheme.bodySmall?.color, size: 14),
          ],
        ),
      ),
    );
  }

  void _showAiRecommendations(BuildContext context) {
    final settings = context.read<SettingsProvider>();
    final primaryColor =
        settings.isDarkMode ? AppColors.primaryGreen : AppColors.primaryBlue;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppMessages.aiRecommendationsTitle,
                style: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    fontSize: 20,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            _buildTipItem(context, AppMessages.buyGrainsAtExito,
                AppMessages.grainsExitoDesc),
            _buildTipItem(context, AppMessages.dairyAtCarulla,
                AppMessages.dairyCarullaDesc),
            _buildTipItem(context, AppMessages.proteinAtJumbo,
                AppMessages.proteinJumboDesc),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(AppMessages.understoodAction),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, String title, String desc) {
    final settings = context.read<SettingsProvider>();
    final primaryColor =
        settings.isDarkMode ? AppColors.primaryGreen : AppColors.primaryBlue;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          Text(desc,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 13)),
        ],
      ),
    );
  }
}
