import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_messages.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/settings_provider.dart';
import '../../widgets/sm_button.dart';
import '../../widgets/sm_text_field.dart';
import '../../widgets/logo_widget.dart';
import '../home/main_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppMessages.registerSuccessTitle),
          backgroundColor: Colors.green,
        ));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainShell()),
          (_) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(authProvider.errorMessage ?? AppMessages.registerErrorTitle),
          backgroundColor: AppColors.error,
        ));
      }
    }
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return AppMessages.passwordRequired;
    if (v.length < 8) return AppMessages.minCharacters;
    if (!v.contains(RegExp(r'[A-Z]'))) return AppMessages.uppercaseRequired;
    if (!v.contains(RegExp(r'[a-z]'))) return AppMessages.lowercaseRequired;
    if (!v.contains(RegExp(r'[0-9]'))) return AppMessages.numberRequired;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                LogoWidget(size: 48, showText: false),
                const SizedBox(height: 32),
                Text(
                  AppMessages.registerTitle,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppMessages.registerSubtitle,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      height: 1.6),
                ),
                const SizedBox(height: 40),
                SmTextField(
                  controller: _nameController,
                  label: AppMessages.fullNameLabel,
                  hint: AppMessages.fullNameHint,
                  prefixIcon:
                      const Icon(Icons.person_outline_rounded, size: 20),
                  validator: (v) {
                    if (v == null || v.isEmpty) return AppMessages.nameRequired;
                    if (v.trim().length < 2)
                      return AppMessages.minNameCharacters;
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SmTextField(
                  controller: _emailController,
                  label: AppMessages.emailLabel,
                  hint: AppMessages.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return AppMessages.emailRequired;
                    if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(v))
                      return AppMessages.invalidEmail;
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SmTextField(
                  controller: _passwordController,
                  label: AppMessages.passwordLabel,
                  hint: '••••••••',
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 20),
                SmTextField(
                  controller: _confirmController,
                  label: AppMessages.confirmPasswordLabel,
                  hint: '••••••••',
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _register(),
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return AppMessages.confirmPasswordRequired;
                    if (v != _passwordController.text)
                      return AppMessages.passwordsNoMatch;
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) => SmButton(
                    label: AppMessages.signUpAction,
                    onPressed: _register,
                    isLoading: auth.isLoading,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppMessages.alreadyHaveAccount,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 14)),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppMessages.signInAction,
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
