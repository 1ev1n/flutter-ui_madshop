import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../widgets/product_card.dart';
import '../services/cart_service.dart';
import 'favourites_screen.dart';
import 'cart_screen.dart';
import 'onboarding/login_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    _cartService.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cartService.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  // Все товары
  final List<Map<String, String>> products = [
    {
      'id': '1',
      'name': 'Lorem ipsum dolor sit amet consectetur',
      'price': '\$17,00',
      'imageUrl': 'assets/images/2289C231-211F-4850-B7AF-5EF0F942B4F7.png',
      'description': 'Lorem ipsum dolor sit amet consectetur adipiscing elit.',
    },
    {
      'id': '2',
      'name': 'Lorem ipsum dolor sit amet consectetur',
      'price': '\$17,00',
      'imageUrl': 'assets/images/32EB245A-E30D-4D15-B57A-23A577C43459.png',
      'description': 'Lorem ipsum dolor sit amet consectetur adipiscing elit.',
    },
    {
      'id': '3',
      'name': 'Lorem ipsum dolor sit amet consectetur',
      'price': '\$17,00',
      'imageUrl': 'assets/images/333CBBCA-9390-4C5A-A60A-21E776BF77D2.png',
      'description': 'Lorem ipsum dolor sit amet consectetur adipiscing elit.',
    },
    {
      'id': '4',
      'name': 'Lorem ipsum dolor sit amet consectetur',
      'price': '\$17,00',
      'imageUrl': 'assets/images/92265483-9E7E-4FC3-A355-16CCA677C11C.png',
      'description': 'Lorem ipsum dolor sit amet consectetur adipiscing elit.',
    },
    {
      'id': '5',
      'name': 'Lorem ipsum dolor sit amet consectetur',
      'price': '\$17,00',
      'imageUrl': 'assets/images/92CAF77E-01B5-48CD-8DC9-DD5D205768ED.png',
      'description': 'Lorem ipsum dolor sit amet consectetur adipiscing elit.',
    },
    {
      'id': '6',
      'name': 'Lorem ipsum dolor sit amet consectetur',
      'price': '\$17,00',
      'imageUrl': 'assets/images/AB90E177-EBD5-42AF-A94E-05F24787DEE2.png',
      'description': 'Lorem ipsum dolor sit amet consectetur adipiscing elit.',
    },
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FavouritesScreen()),
      ).then((_) => setState(() => _currentIndex = 0));
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartScreen()),
      ).then((_) => setState(() => _currentIndex = 0));
    }
  }

  List<Map<String, String>> get filteredProducts {
    if (_searchQuery.isEmpty) {
      return products;
    }
    return products.where((product) {
      final name = product['name']!.toLowerCase();
      final description = product['description']!.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || description.contains(query);
    }).toList();
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти из аккаунта?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
            child: const Text(
              'Выйти',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Shop',
          style: AppTextStyles.title,
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Выйти',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Декоративные элементы фона
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.decorativeBlue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.decorativeBlueLight,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Контент
          Column(
            children: [
              // Поле поиска
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Поиск товаров...',
                    hintStyle: TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              // Сетка товаров
              Expanded(
                child: filteredProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 80,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Товары не найдены',
                              style: AppTextStyles.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Попробуйте другой запрос',
                              style: AppTextStyles.bodySecondary,
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
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
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_bag_outlined),
                if (_cartService.itemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
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
                        '${_cartService.itemCount}',
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
            activeIcon: Stack(
              children: [
                const Icon(Icons.shopping_bag),
                if (_cartService.itemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
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
                        '${_cartService.itemCount}',
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
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}

