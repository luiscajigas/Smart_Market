import 'product_model.dart';

class MockData {
  static const List<Supermarket> supermarkets = [
    Supermarket(id: 'exito', name: 'Éxito', logo: '🟡', distance: 1.2, rating: 4.5),
    Supermarket(id: 'jumbo', name: 'Jumbo', logo: '🔴', distance: 2.8, rating: 4.3),
    Supermarket(id: 'carulla', name: 'Carulla', logo: '🟢', distance: 0.8, rating: 4.7),
    Supermarket(id: 'metro', name: 'Metro', logo: '🔵', distance: 3.5, rating: 4.1),
  ];

  static final List<Product> products = [
    Product(
      id: '1', name: 'Arroz Diana 5kg', category: 'Granos',
      imageEmoji: '🌾', unit: 'bolsa 5kg',
      prices: {'Éxito': 18500, 'Jumbo': 19200, 'Carulla': 17800, 'Metro': 18900},
    ),
    Product(
      id: '2', name: 'Leche Alpina 1L', category: 'Lácteos',
      imageEmoji: '🥛', unit: 'litro',
      prices: {'Éxito': 3200, 'Jumbo': 2900, 'Carulla': 3400, 'Metro': 3100},
    ),
    Product(
      id: '3', name: 'Huevos AA x12', category: 'Proteínas',
      imageEmoji: '🥚', unit: 'docena',
      prices: {'Éxito': 12800, 'Jumbo': 13500, 'Carulla': 12200, 'Metro': 13000},
    ),
    Product(
      id: '4', name: 'Aceite Oleocali 1L', category: 'Despensa',
      imageEmoji: '🫙', unit: 'litro',
      prices: {'Éxito': 9800, 'Jumbo': 9200, 'Carulla': 10200, 'Metro': 9500},
    ),
    Product(
      id: '5', name: 'Pan tajado Bimbo', category: 'Panadería',
      imageEmoji: '🍞', unit: 'paquete',
      prices: {'Éxito': 5600, 'Jumbo': 5400, 'Carulla': 5900, 'Metro': 5500},
    ),
    Product(
      id: '6', name: 'Pollo entero', category: 'Proteínas',
      imageEmoji: '🍗', unit: 'kg',
      prices: {'Éxito': 8900, 'Jumbo': 8400, 'Carulla': 9200, 'Metro': 8600},
    ),
    Product(
      id: '7', name: 'Pasta Doria 500g', category: 'Granos',
      imageEmoji: '🍝', unit: '500g',
      prices: {'Éxito': 3800, 'Jumbo': 3600, 'Carulla': 4000, 'Metro': 3700},
    ),
    Product(
      id: '8', name: 'Yogur Alpina 200g', category: 'Lácteos',
      imageEmoji: '🍦', unit: '200g',
      prices: {'Éxito': 2100, 'Jumbo': 1900, 'Carulla': 2300, 'Metro': 2000},
    ),
  ];

  static final List<PurchaseHistory> history = [
    PurchaseHistory(product: 'Arroz Diana 5kg', emoji: '🌾', supermarket: 'Carulla', price: 17800, date: DateTime.now().subtract(const Duration(days: 14)), quantity: 1),
    PurchaseHistory(product: 'Leche Alpina 1L', emoji: '🥛', supermarket: 'Jumbo', price: 2900, date: DateTime.now().subtract(const Duration(days: 6)), quantity: 4),
    PurchaseHistory(product: 'Huevos AA x12', emoji: '🥚', supermarket: 'Carulla', price: 12200, date: DateTime.now().subtract(const Duration(days: 9)), quantity: 1),
    PurchaseHistory(product: 'Pan tajado', emoji: '🍞', supermarket: 'Metro', price: 5500, date: DateTime.now().subtract(const Duration(days: 3)), quantity: 2),
    PurchaseHistory(product: 'Pollo entero', emoji: '🍗', supermarket: 'Jumbo', price: 8400, date: DateTime.now().subtract(const Duration(days: 2)), quantity: 1),
    PurchaseHistory(product: 'Aceite Oleocali', emoji: '🫙', supermarket: 'Jumbo', price: 9200, date: DateTime.now().subtract(const Duration(days: 20)), quantity: 1),
  ];

  static const List<AiRecommendation> recommendations = [
    AiRecommendation(
      title: 'Ahorra \$22.000 este mes',
      description: 'Compra arroz en Carulla y lácteos en Jumbo. Basado en tus patrones de compra.',
      type: 'saving', savingAmount: 22000, icon: '💰',
    ),
    AiRecommendation(
      title: 'Leche en 2 días',
      description: 'Tu última compra fue hace 5 días. Promedio de reposición: 7 días. Actualmente 10% más barata en Jumbo.',
      type: 'prediction', savingAmount: 320, icon: '🔮',
    ),
    AiRecommendation(
      title: 'Carulla más eficiente hoy',
      description: 'Tu carrito habitual es \$5.000 más caro en Éxito, pero Carulla queda a solo 0.8km.',
      type: 'location', savingAmount: 5000, icon: '📍',
    ),
  ];

  static const double monthlyBudget = 250000;
  static const double monthlySpent = 187400;
  static const double monthlySaved = 22000;
}