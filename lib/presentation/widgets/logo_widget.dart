import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_messages.dart';
import '../../data/providers/settings_provider.dart';

class LogoWidget extends StatelessWidget {
  final double size;
  final bool showText;

  const LogoWidget({super.key, this.size = 60, this.showText = true});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final primaryColor =
        settings.isDarkMode ? AppColors.primaryGreen : AppColors.primaryBlue;
    final primaryGradient = settings.isDarkMode
        ? AppColors.primaryGradientGreen
        : AppColors.primaryGradientBlue;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: primaryGradient,
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.4),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size * 0.28),
              child: Image.asset(
                'assets/images/icon.jpg',
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if the image does not exist yet
                  return Text(
                    'SM',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: size * 0.36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 14),
          Text(
            'Smart Market',
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppMessages.yourSmartMarket,
            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.color
                  ?.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }
}
