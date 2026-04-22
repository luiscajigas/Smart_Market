import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_messages.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/settings_provider.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../widgets/sm_button.dart';
import '../../widgets/sm_text_field.dart';
import '../../widgets/logo_widget.dart';
import 'verify_code_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    await AuthRepository.requestPasswordReset(
        email: _emailController.text.trim());

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerifyCodeScreen(email: _emailController.text.trim()),
      ),
    );
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
                const LogoWidget(size: 48, showText: false),
                const SizedBox(height: 32),
                Text(
                  AppMessages.recoverPasswordTitle,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppMessages.enterEmailInstructions,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 15),
                ),
                const SizedBox(height: 40),
                SmTextField(
                  controller: _emailController,
                  label: AppMessages.emailLabel,
                  hint: AppMessages.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _sendCode(),
                  prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return AppMessages.emailRequired;
                    if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(v))
                      return AppMessages.invalidEmail;
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) => SmButton(
                    label: AppMessages.sendCodeAction,
                    onPressed: _sendCode,
                    isLoading: auth.isLoading,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  AppMessages.emailExpiryInfo,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(color: AppColors.textHint, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
