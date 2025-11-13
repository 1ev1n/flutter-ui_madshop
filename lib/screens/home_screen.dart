import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Пример данных товаров с локальными изображениями
  final List<Map<String, String>> products = [
    {
      'id': '1',
      'name': 'Смартфон Samsung Galaxy',
      'price': '29 990 ₽',
      'imageUrl': 'assets/images/2289C231-211F-4850-B7AF-5EF0F942B4F7.png',
      'description': 'Современный смартфон с отличной камерой и производительностью.',
    },
    {
      'id': '2',
      'name': 'Ноутбук MacBook Pro',
      'price': '129 990 ₽',
      'imageUrl': 'assets/images/32EB245A-E30D-4D15-B57A-23A577C43459.png',
      'description': 'Мощный ноутбук для работы и творчества.',
    },
    {
      'id': '3',
      'name': 'Наушники AirPods Pro',
      'price': '19 990 ₽',
      'imageUrl': 'assets/images/333CBBCA-9390-4C5A-A60A-21E776BF77D2.png',
      'description': 'Беспроводные наушники с шумоподавлением.',
    },
    {
      'id': '4',
      'name': 'Часы Apple Watch',
      'price': '34 990 ₽',
      'imageUrl': 'assets/images/92265483-9E7E-4FC3-A355-16CCA677C11C.png',
      'description': 'Умные часы с множеством функций для здоровья.',
    },
    {
      'id': '5',
      'name': 'Планшет iPad Air',
      'price': '49 990 ₽',
      'imageUrl': 'assets/images/92CAF77E-01B5-48CD-8DC9-DD5D205768ED.png',
      'description': 'Легкий и мощный планшет для работы и развлечений.',
    },
    {
      'id': '6',
      'name': 'Камера Canon EOS',
      'price': '89 990 ₽',
      'imageUrl': 'assets/images/AB90E177-EBD5-42AF-A94E-05F24787DEE2.png',
      'description': 'Профессиональная зеркальная камера.',
    },
  ];

  int cartItemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'MAD Shop',
          style: AppTextStyles.titleMedium,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Заголовок секции
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Каталог товаров',
                  style: AppTextStyles.title,
                ),
                Text(
                  '${products.length} товаров',
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
          ),
          // Список товаров
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  id: product['id']!,
                  name: product['name']!,
                  price: product['price']!,
                  imageUrl: product['imageUrl']!,
                  description: product['description']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

