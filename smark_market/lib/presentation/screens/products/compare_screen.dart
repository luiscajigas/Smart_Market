import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../data/models/mock_data.dart';
import '../../../data/models/product_model.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});
  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  String _selectedCategory = 'Todos';
  final List<String> _categories = [
    'Todos', 'Granos', 'Lácteos', 'Proteínas', 'Despensa', 'Panadería'
  ];

  List<Product> get _filtered {
    if (_selectedCategory == 'Todos') return MockData.products;
    return MockData.products.where((p) => p.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Comparar precios',
                    style: TextStyle(
                      color: AppColors.textPrimary, fontSize: 24,
                      fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  const Text('Encuentra el mejor precio por supermercado',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (_, i) {
                        final cat = _categories[i];
                        final isSelected = cat == _selectedCategory;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.border),
                            ),
                            alignment: Alignment.center,
                            child: Text(cat, style: TextStyle(
                              color: isSelected ? Colors.black : AppColors.textSecondary,
                              fontSize: 13, fontWeight: FontWeight.w600)),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filtered.length,
                itemBuilder: (_, i) => _ProductCompareCard(product: _filtered[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCompareCard extends StatefulWidget {
  final Product product;
  const _ProductCompareCard({required this.product});
  @override
  State<_ProductCompareCard> createState() => _ProductCompareCardState();
}

class _ProductCompareCardState extends State<_ProductCompareCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final sortedPrices = p.prices.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(p.imageEmoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, style: const TextStyle(
                          color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                        Text(p.unit,
                          style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('\$${p.minPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w800)),
                      Text('ahorra \$${p.savings.toStringAsFixed(0)}',
                        style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(_expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                    color: AppColors.textHint, size: 20),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(color: AppColors.border, height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: sortedPrices.asMap().entries.map((e) {
                  final isBest = e.key == 0;
                  final entry = e.value;
                  final barPct = entry.value / p.maxPrice;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 70,
                          child: Text(entry.key, style: TextStyle(
                            color: isBest ? AppColors.primary : AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: isBest ? FontWeight.w700 : FontWeight.w400)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: barPct,
                              backgroundColor: AppColors.border,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isBest ? AppColors.primary : AppColors.textHint),
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 70,
                          child: Text('\$${entry.value.toStringAsFixed(0)}',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: isBest ? AppColors.primary : AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: isBest ? FontWeight.w700 : FontWeight.w400)),
                        ),
                        if (isBest) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.star_rounded, color: AppColors.primary, size: 14),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}