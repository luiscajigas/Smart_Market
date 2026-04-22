import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_messages.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/settings_provider.dart';
import '../welcome/welcome_screen.dart';
import '../home/main_shell.dart';
import '../home/supermarket_map_screen.dart';
import 'feature_placeholder_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _navigateToTab(BuildContext context, int index) {
    final mainShellState = context.findAncestorStateOfType<MainShellState>();
    if (mainShellState != null) {
      mainShellState.updateIndex(index);
    }
  }

  void _navigateToPlaceholder(
      BuildContext context, String title, String description, IconData icon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FeaturePlaceholderScreen(
          title: title,
          description: description,
          icon: icon,
        ),
      ),
    );
  }

  void _showBudgetDialog(BuildContext context) {
    final settings = context.read<SettingsProvider>();
    final controller =
        TextEditingController(text: settings.monthlyBudget.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(AppMessages.monthlyBudgetTitle,
            style: const TextStyle(color: AppColors.textPrimary)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            labelText: AppMessages.amountLabel,
            labelStyle: const TextStyle(color: AppColors.textHint),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.border)),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppMessages.cancelAction,
                style: const TextStyle(color: AppColors.textHint)),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null) {
                settings.setMonthlyBudget(value);
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text(AppMessages.saveAction,
                style: const TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final settings = context.read<SettingsProvider>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(AppMessages.selectLanguageTitle,
            style: const TextStyle(color: AppColors.textPrimary)),
        content: SizedBox(
          width: double.maxFinite,
          child: DropdownButton<String>(
            value: settings.language,
            isExpanded: true,
            dropdownColor: AppColors.cardBackground,
            iconEnabledColor: AppColors.textPrimary,
            underline: Container(height: 1, color: AppColors.border),
            items: [
              DropdownMenuItem(
                value: 'es',
                child: Text(AppMessages.spanishLabel,
                    style: const TextStyle(color: AppColors.textPrimary)),
              ),
              DropdownMenuItem(
                value: 'en',
                child: Text(AppMessages.englishLabel,
                    style: const TextStyle(color: AppColors.textPrimary)),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              settings.setLanguage(value);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final metadata = authProvider.currentUser?.userMetadata;

    final name = metadata?['full_name'] ?? 'User';
    final email = authProvider.currentUser?.email ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(AppMessages.profileTitle,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 24),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8))
                  ],
                ),
                child: Center(
                    child: Text(initial,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.w800))),
              ),
              const SizedBox(height: 14),
              Text(name,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(email,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 14)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      value: '6',
                      label: AppMessages.purchasesLabel,
                      onTap: () => _navigateToTab(context, 3),
                    ),
                    _StatItem(
                      value:
                          '\$${(settingsProvider.monthlyBudget / 1000).toStringAsFixed(0)}K',
                      label: AppMessages.goalLabel,
                      onTap: () => _showBudgetDialog(context),
                    ),
                    _StatItem(
                      value: '3',
                      label: AppMessages.recommendationsLabel,
                      onTap: () => _navigateToTab(context, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ...[
                (
                  Icons.notifications_outlined,
                  AppMessages.notificationsLabel,
                  AppMessages.notificationsDesc,
                  () {}
                ),
                (
                  Icons.location_on_outlined,
                  AppMessages.locationLabel,
                  AppMessages.locationDesc,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SupermarketMapScreen()))
                ),
                (
                  Icons.account_balance_wallet_outlined,
                  AppMessages.budgetLabel,
                  AppMessages.budgetDesc,
                  () => _showBudgetDialog(context)
                ),
                (
                  Icons.language_rounded,
                  AppMessages.languageLabel,
                  AppMessages.languageDesc,
                  () => _showLanguageDialog(context)
                ),
                (
                  Icons.bar_chart_rounded,
                  AppMessages.statisticsLabel,
                  AppMessages.statisticsDesc,
                  () => _navigateToPlaceholder(
                      context,
                      AppMessages.statisticsLabel,
                      'Visualize your consumption habits with interactive charts.',
                      Icons.bar_chart_rounded)
                ),
                (
                  Icons.shield_outlined,
                  AppMessages.privacyLabel,
                  AppMessages.privacyDesc,
                  () {}
                ),
                (
                  Icons.help_outline_rounded,
                  AppMessages.helpLabel,
                  AppMessages.helpDesc,
                  () => _navigateToPlaceholder(
                      context,
                      AppMessages.helpLabel,
                      'Get answers to your questions and contact support.',
                      Icons.help_outline_rounded)
                ),
              ].map((item) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      onTap: item.$4,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      tileColor: AppColors.cardBackground,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(color: AppColors.border)),
                      leading: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            Icon(item.$1, color: AppColors.primary, size: 18),
                      ),
                      title: Text(item.$2,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                      subtitle: Text(item.$3,
                          style: const TextStyle(
                              color: AppColors.textHint, fontSize: 11)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded,
                          color: AppColors.textHint, size: 14),
                    ),
                  )),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await context.read<AuthProvider>().logout();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const WelcomeScreen()),
                        (_) => false);
                  },
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: Text(AppMessages.signOutAction),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
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

class _StatItem extends StatelessWidget {
  final String value, label;
  final VoidCallback? onTap;
  const _StatItem({required this.value, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      ),
    );
  }
}
