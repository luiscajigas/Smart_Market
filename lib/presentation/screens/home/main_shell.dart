import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_messages.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/settings_provider.dart';
import 'home_screen.dart';
import '../products/compare_screen.dart';
import '../ai/ai_screen.dart';
import '../history/history_screen.dart';
import '../profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  void updateIndex(int index) {
    if (_currentIndex != index) {
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() => _currentIndex = index);
    }
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const CompareScreen(),
      const AiScreen(),
      const HistoryScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          body: IndexedStack(index: _currentIndex, children: _screens),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                  top: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.1),
                      width: 1)),
            ),
            child: SafeArea(
              child: SizedBox(
                height: 60,
                child: Row(
                  children: [
                    _NavItem(
                        icon: Icons.home_rounded,
                        label: AppMessages.navHome,
                        index: 0,
                        current: _currentIndex,
                        onTap: updateIndex),
                    _NavItem(
                        icon: Icons.compare_arrows_rounded,
                        label: AppMessages.navCompare,
                        index: 1,
                        current: _currentIndex,
                        onTap: updateIndex),
                    _NavItem(
                        icon: Icons.auto_awesome_rounded,
                        label: AppMessages.navAi,
                        index: 2,
                        current: _currentIndex,
                        onTap: updateIndex,
                        isAi: true),
                    _NavItem(
                        icon: Icons.receipt_long_rounded,
                        label: AppMessages.navHistory,
                        index: 3,
                        current: _currentIndex,
                        onTap: updateIndex),
                    _NavItem(
                        icon: Icons.person_rounded,
                        label: AppMessages.navProfile,
                        index: 4,
                        current: _currentIndex,
                        onTap: updateIndex),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final void Function(int) onTap;
  final bool isAi;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
    this.isAi = false,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    final theme = Theme.of(context);
    final settings = context.watch<SettingsProvider>();
    final primaryColor =
        settings.isDarkMode ? AppColors.primaryGreen : AppColors.primaryBlue;
    final hintColor = theme.textTheme.bodySmall?.color ?? AppColors.textHint;

    if (isAi) {
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onTap(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 32,
                decoration: BoxDecoration(
                  gradient: isActive
                      ? (settings.isDarkMode
                          ? AppColors.primaryGradientGreen
                          : AppColors.primaryGradientBlue)
                      : LinearGradient(
                          colors: [
                            theme.dividerColor.withOpacity(0.1),
                            theme.dividerColor.withOpacity(0.1)
                          ],
                        ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon,
                    size: 18, color: isActive ? Colors.white : hintColor),
              ),
              const SizedBox(height: 2),
              Text(label,
                  style: TextStyle(
                      fontSize: 10,
                      color: isActive ? primaryColor : hintColor,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: isActive ? primaryColor : hintColor),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    color: isActive ? primaryColor : hintColor,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
