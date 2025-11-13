import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../services/favorites_service.dart';
import '../services/cart_service.dart';
import '../widgets/product_card.dart';
import 'shop_screen.dart';
import 'cart_screen.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  int _currentIndex = 1;
  final FavoritesService _favoritesService = FavoritesService();
  final CartService _cartService = CartService();

  // Все товары (должны совпадать с ShopScreen)
  final List<Map<String, String>> allProducts = [
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

  @override
  void initState() {
    super.initState();
    _favoritesService.addListener(_onFavoritesChanged);
    _cartService.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _favoritesService.removeListener(_onFavoritesChanged);
    _cartService.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onCartChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  List<Map<String, String>> get favoriteProducts {
    return allProducts
        .where((product) => _favoritesService.isFavorite(product['id']!))
        .toList();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ShopScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartScreen()),
      ).then((_) => setState(() => _currentIndex = 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorites = favoriteProducts;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Favourites',
          style: AppTextStyles.title,
        ),
        automaticallyImplyLeading: false,
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
          // Сетка избранных товаров
          favorites.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 80,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: AppTextStyles.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add products to favorites',
                        style: AppTextStyles.bodySecondary,
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final product = favorites[index];
                    return ProductCard(
                      id: product['id']!,
                      name: product['name']!,
                      price: product['price']!,
                      imageUrl: product['imageUrl']!,
                      description: product['description']!,
                    );
                  },
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
