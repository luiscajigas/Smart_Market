import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_messages.dart';
import '../../data/providers/history_provider.dart';
import '../../data/providers/product_provider.dart';
import '../../data/providers/settings_provider.dart';

class SavingsCard extends StatelessWidget {
  const SavingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final historyProvider = context.watch<HistoryProvider>();
    final productProvider = context.watch<ProductProvider>();
    final isDark = settingsProvider.isDarkMode;

    final monthlyBudget = settingsProvider.monthlyBudget;
    final now = DateTime.now();
    final monthlySpent = historyProvider.history.fold<double>(0.0, (sum, row) {
      final createdAt = row['created_at'];
      final dt = DateTime.tryParse(createdAt?.toString() ?? '');
      if (dt == null) return sum;
      if (dt.year != now.year || dt.month != now.month) return sum;
      final price = row['price'];
      final value = price is num ? price.toDouble() : double.tryParse('$price');
      return sum + (value ?? 0.0);
    });

    final projectedSavings =
        productProvider.groupedProducts.fold<double>(0.0, (sum, p) {
      return sum + p.savings;
    });

    final pct = monthlyBudget > 0
        ? (monthlySpent / monthlyBudget * 100).clamp(0, 999).round()
        : 0;

    return GestureDetector(
      onTap: () => _showUpdateBudgetDialog(context),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.primaryGradientGreen
              : AppColors.primaryGradientBlue,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (isDark ? AppColors.primaryGreen : AppColors.primaryBlue)
                  .withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppMessages.monthlyBudgetTitle,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${AppMessages.savingsTab}: \$${projectedSavings.toStringAsFixed(0)}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\$${monthlySpent.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            Text(
              '${AppMessages.budgetSpent} ${AppMessages.ofBudgetPrefix}\$${monthlyBudget.toStringAsFixed(0)}${AppMessages.ofBudgetSuffix}',
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct / 100,
                backgroundColor: Colors.black.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 6),
            Text('$pct${AppMessages.usedPercentageSuffix}',
                style: const TextStyle(color: Colors.black54, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  void _showUpdateBudgetDialog(BuildContext context) {
    final settingsProvider = context.read<SettingsProvider>();
    final primaryColor = settingsProvider.isDarkMode
        ? AppColors.primaryGreen
        : AppColors.primaryBlue;
    final controller = TextEditingController(
        text: settingsProvider.monthlyBudget.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(AppMessages.editBudgetTitle,
            style: TextStyle(
                color: Theme.of(context).textTheme.titleLarge?.color)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            labelText: AppMessages.monthlyBudgetTitle,
            labelStyle:
                TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
            enabledBorder:
                UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppMessages.cancelAction,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color)),
          ),
          ElevatedButton(
            onPressed: () {
              final newVal = double.tryParse(controller.text);
              if (newVal != null) {
                settingsProvider.setMonthlyBudget(newVal);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppMessages.saveBudgetSuccess)),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: Text(AppMessages.saveAction),
          ),
        ],
      ),
    );
  }
}
