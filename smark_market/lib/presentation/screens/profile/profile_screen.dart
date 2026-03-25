import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../welcome/welcome_screen.dart';
import '../home/main_shell.dart';
import '../home/supermarket_map_screen.dart';
import 'feature_placeholder_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;
  const ProfileScreen({super.key, this.userData});

  void _navigateToTab(BuildContext context, int index) {
    final mainShellState = context.findAncestorStateOfType<MainShellState>();
    if (mainShellState != null) {
      mainShellState.updateIndex(index);
    }
  }

  void _navigateToPlaceholder(BuildContext context, String title, String description, IconData icon) {
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

  @override
  Widget build(BuildContext context) {
    final nombre = userData?['nombre'] ?? 'Usuario';
    final email = userData?['email'] ?? '';
    final initial = nombre.isNotEmpty ? nombre[0].toUpperCase() : 'U';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 20, offset: const Offset(0, 8))
                  ],
                ),
                child: Center(child: Text(initial, style: const TextStyle(
                  color: Colors.black, fontSize: 32, fontWeight: FontWeight.w800))),
              ),
              const SizedBox(height: 14),
              Text(nombre, style: const TextStyle(
                color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(email, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
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
                      label: 'Compras',
                      onTap: () => _navigateToTab(context, 3),
                    ),
                    _StatItem(
                      value: '\$22K', 
                      label: 'Ahorro',
                      onTap: () => _navigateToPlaceholder(
                        context, 
                        'Presupuesto', 
                        'Gestiona tu gasto mensual y visualiza tus ahorros.', 
                        Icons.account_balance_wallet_outlined
                      ),
                    ),
                    _StatItem(
                      value: '3', 
                      label: 'Recomend.',
                      onTap: () => _navigateToTab(context, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              ...[
                (Icons.notifications_outlined, 'Notificaciones', 'Alertas de precios y predicciones', () => _navigateToPlaceholder(context, 'Notificaciones', 'Recibe alertas personalizadas sobre cambios de precios y ofertas.', Icons.notifications_outlined)),
                (Icons.location_on_outlined, 'Ubicación', 'Supermercados cercanos', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupermarketMapScreen()))),
                (Icons.account_balance_wallet_outlined, 'Presupuesto', 'Gestiona tu gasto mensual', () => _navigateToPlaceholder(context, 'Presupuesto', 'Lleva un control detallado de tus gastos mensuales y ahorros.', Icons.account_balance_wallet_outlined)),
                (Icons.bar_chart_rounded, 'Estadísticas', 'Análisis detallado de consumo', () => _navigateToPlaceholder(context, 'Estadísticas', 'Visualiza tus hábitos de consumo con gráficos interactivos.', Icons.bar_chart_rounded)),
                (Icons.shield_outlined, 'Privacidad', 'Configura tus datos', () => _navigateToPlaceholder(context, 'Privacidad', 'Gestiona la seguridad y privacidad de tu información.', Icons.shield_outlined)),
                (Icons.help_outline_rounded, 'Ayuda', 'Soporte y preguntas frecuentes', () => _navigateToPlaceholder(context, 'Ayuda', 'Obtén respuestas a tus dudas y contacta con soporte.', Icons.help_outline_rounded)),
              ].map((item) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  onTap: item.$4,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  tileColor: AppColors.cardBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AppColors.border)),
                  leading: Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.$1, color: AppColors.primary, size: 18),
                  ),
                  title: Text(item.$2, style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text(item.$3, style: const TextStyle(
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
                    await AuthRepository.logout();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                      (_) => false);
                  },
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text('Cerrar sesión'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
          Text(value, style: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      ),
    );
  }
}