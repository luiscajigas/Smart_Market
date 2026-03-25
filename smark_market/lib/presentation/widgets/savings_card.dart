import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/mock_data.dart';

class SavingsCard extends StatelessWidget {
  const SavingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final pct = (MockData.monthlySpent / MockData.monthlyBudget * 100).round();

    return GestureDetector(
      onTap: () => _showUpdateBudgetDialog(context),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
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
                const Text('Presupuesto del mes',
                    style: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w500)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Ahorro: \$${MockData.monthlySaved.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\$${MockData.monthlySpent.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Colors.black, fontSize: 32,
                fontWeight: FontWeight.w800, letterSpacing: -1,
              ),
            ),
            Text(
              'de \$${MockData.monthlyBudget.toStringAsFixed(0)} presupuestado',
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
            Text('$pct% utilizado',
                style: const TextStyle(color: Colors.black54, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  void _showUpdateBudgetDialog(BuildContext context) {
    final controller = TextEditingController(text: MockData.monthlyBudget.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text('Editar Presupuesto', style: TextStyle(color: AppColors.textPrimary)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            labelText: 'Presupuesto Mensual',
            labelStyle: TextStyle(color: AppColors.textHint),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              // En un caso real, esto actualizaría el estado o la DB
              final newVal = double.tryParse(controller.text);
              if (newVal != null) {
                // Simulamos actualización
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Presupuesto actualizado (Simulación)')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Guardar', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}