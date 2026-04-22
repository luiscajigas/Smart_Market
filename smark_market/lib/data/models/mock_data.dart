import 'product_model.dart';

class MockData {
  static const List<Supermarket> supermarkets = [
    Supermarket(
        id: 'alkosto',
        name: 'Alkosto',
        logo: 'AK',
        distance: 0.5,
        rating: 4.8,
        latitude: 1.2136,
        longitude: -77.2811),
    Supermarket(
        id: 'exito',
        name: 'Éxito',
        logo: 'EX',
        distance: 1.2,
        rating: 4.5,
        latitude: 1.2089,
        longitude: -77.2778),
    Supermarket(
        id: 'unico',
        name: 'Unicentro',
        logo: 'UC',
        distance: 2.1,
        rating: 4.4,
        latitude: 1.2222,
        longitude: -77.2855),
  ];

  static final List<Product> products = [
    Product(
      id: '1',
      name: 'Diana Rice 5kg',
      category: 'Grains',
      imageEmoji: '🌾',
      unit: '5kg bag',
      buyUrl: 'https://www.exito.com/arroz-diana-5kg',
      prices: {
        'Éxito': 18500,
        'Jumbo': 19200,
        'Carulla': 17800,
        'Metro': 18900
      },
    ),
    Product(
      id: '2',
      name: 'Alpina Milk 1L',
      category: 'Dairy',
      imageEmoji: '🥛',
      unit: 'liter',
      buyUrl: 'https://www.tiendaalpina.com/leche-entera-alpina-1lt',
      prices: {'Éxito': 3200, 'Jumbo': 2900, 'Carulla': 3400, 'Metro': 3100},
    ),
    Product(
      id: '3',
      name: 'AA Eggs x12',
      category: 'Proteins',
      imageEmoji: '🥚',
      unit: 'dozen',
      buyUrl: 'https://www.carulla.com/huevos-aa-x12',
      prices: {
        'Éxito': 12800,
        'Jumbo': 13500,
        'Carulla': 12200,
        'Metro': 13000
      },
    ),
    Product(
      id: '4',
      name: 'Oleocali Oil 1L',
      category: 'Pantry',
      imageEmoji: '🫙',
      unit: 'liter',
      buyUrl: 'https://www.jumbo.co/aceite-oleocali-1l',
      prices: {'Éxito': 9800, 'Jumbo': 9200, 'Carulla': 10200, 'Metro': 9500},
    ),
    Product(
      id: '5',
      name: 'Bimbo Sliced Bread',
      category: 'Bakery',
      imageEmoji: '🍞',
      unit: 'package',
      prices: {'Éxito': 5600, 'Jumbo': 5400, 'Carulla': 5900, 'Metro': 5500},
    ),
    Product(
      id: '6',
      name: 'Whole Chicken',
      category: 'Proteins',
      imageEmoji: '🍗',
      unit: 'kg',
      prices: {'Éxito': 8900, 'Jumbo': 8400, 'Carulla': 9200, 'Metro': 8600},
    ),
    Product(
      id: '7',
      name: 'Doria Pasta 500g',
      category: 'Grains',
      imageEmoji: '🍝',
      unit: '500g',
      prices: {'Éxito': 3800, 'Jumbo': 3600, 'Carulla': 4000, 'Metro': 3700},
    ),
    Product(
      id: '8',
      name: 'Alpina Yogurt 200g',
      category: 'Dairy',
      imageEmoji: '🍦',
      unit: '200g',
      prices: {'Éxito': 2100, 'Jumbo': 1900, 'Carulla': 2300, 'Metro': 2000},
    ),
  ];

  static final List<PurchaseHistory> history = [
    PurchaseHistory(
        product: 'Diana Rice 5kg',
        emoji: '🌾',
        supermarket: 'Carulla',
        price: 17800,
        date: DateTime.now().subtract(const Duration(days: 14)),
        quantity: 1),
    PurchaseHistory(
        product: 'Alpina Milk 1L',
        emoji: '🥛',
        supermarket: 'Jumbo',
        price: 2900,
        date: DateTime.now().subtract(const Duration(days: 6)),
        quantity: 4),
    PurchaseHistory(
        product: 'AA Eggs x12',
        emoji: '🥚',
        supermarket: 'Carulla',
        price: 12200,
        date: DateTime.now().subtract(const Duration(days: 9)),
        quantity: 1),
    PurchaseHistory(
        product: 'Sliced Bread',
        emoji: '🍞',
        supermarket: 'Metro',
        price: 5500,
        date: DateTime.now().subtract(const Duration(days: 3)),
        quantity: 2),
    PurchaseHistory(
        product: 'Whole Chicken',
        emoji: '🍗',
        supermarket: 'Jumbo',
        price: 8400,
        date: DateTime.now().subtract(const Duration(days: 2)),
        quantity: 1),
    PurchaseHistory(
        product: 'Oleocali Oil',
        emoji: '🫙',
        supermarket: 'Jumbo',
        price: 9200,
        date: DateTime.now().subtract(const Duration(days: 20)),
        quantity: 1),
  ];

  static const List<AiRecommendation> recommendations = [
    AiRecommendation(
      title: 'Save \$22,000 this month',
      description:
          'Buy rice at Carulla and dairy at Jumbo. Based on your purchase patterns.',
      type: 'saving',
      savingAmount: 22000,
      icon: '💰',
    ),
    AiRecommendation(
      title: 'Milk in 2 days',
      description:
          'Your last purchase was 5 days ago. Average replenishment: 7 days. Currently 10% cheaper at Jumbo.',
      type: 'prediction',
      savingAmount: 320,
      icon: '🔮',
    ),
    AiRecommendation(
      title: 'Carulla more efficient today',
      description:
          'Your usual basket is \$5,000 more expensive at Éxito, but Carulla is only 0.8km away.',
      type: 'location',
      savingAmount: 5000,
      icon: '📍',
    ),
  ];

  static const double monthlyBudget = 250000;
  static const double monthlySpent = 187400;
  static const double monthlySaved = 22000;
}
