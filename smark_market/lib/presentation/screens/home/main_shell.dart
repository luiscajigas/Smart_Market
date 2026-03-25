import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'home_screen.dart';
import '../products/compare_screen.dart';
import '../ai/ai_screen.dart';
import '../history/history_screen.dart';
import '../profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const MainShell({super.key, this.userData});

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  void updateIndex(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(userData: widget.userData),
      const CompareScreen(),
      const AiScreen(),
      const HistoryScreen(),
      ProfileScreen(userData: widget.userData),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                _NavItem(icon: Icons.home_rounded, label: 'Inicio', index: 0, current: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
                _NavItem(icon: Icons.compare_arrows_rounded, label: 'Comparar', index: 1, current: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
                _NavItem(icon: Icons.auto_awesome_rounded, label: 'IA', index: 2, current: _currentIndex, onTap: (i) => setState(() => _currentIndex = i), isAi: true),
                _NavItem(icon: Icons.receipt_long_rounded, label: 'Historial', index: 3, current: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
                _NavItem(icon: Icons.person_rounded, label: 'Perfil', index: 4, current: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
              ],
            ),
          ),
        ),
      ),
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

    if (isAi) {
      return Expanded(
        child: GestureDetector(
          onTap: () => onTap(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44, height: 32,
                decoration: BoxDecoration(
                  gradient: isActive
                      ? AppColors.primaryGradient
                      : const LinearGradient(colors: [AppColors.border, AppColors.border]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 18,
                  color: isActive ? Colors.black : AppColors.textHint),
              ),
              const SizedBox(height: 2),
              Text(label, style: TextStyle(
                fontSize: 10,
                color: isActive ? AppColors.primary : AppColors.textHint,
                fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22,
              color: isActive ? AppColors.primary : AppColors.textHint),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(
              fontSize: 10,
              color: isActive ? AppColors.primary : AppColors.textHint,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}