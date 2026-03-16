import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/repositories/auth_repository.dart';
import '../welcome/welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;
  const HomeScreen({super.key, this.userData});

  Future<void> _logout(BuildContext context) async {
    await AuthRepository.logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final nombre = userData?['nombre'] ?? 'Usuario';
    final email = userData?['email'] ?? '';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('SM',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 13)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text('Smart Market',
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 18)),
                  ]),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded,
                        color: AppColors.textSecondary),
                    onPressed: () => _logout(context),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        nombre.isNotEmpty
                            ? nombre[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('¡Hola, $nombre!',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(email,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 13),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 32),
              const Text(
                'Autenticación completada ✅',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5),
              ),
              const SizedBox(height: 8),
              const Text(
                'El sistema funciona correctamente.',
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.6),
              ),
              const SizedBox(height: 24),
              ...[
                ('Registro de usuario', Icons.person_add_outlined),
                ('Inicio de sesión', Icons.login_rounded),
                ('Recuperación de contraseña', Icons.lock_reset_rounded),
                ('JWT Token activo', Icons.token_outlined),
                ('Encriptación bcrypt', Icons.security_rounded),
              ].map((item) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(children: [
                      Icon(item.$2, color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Text(item.$1,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('✓',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                    ]),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}