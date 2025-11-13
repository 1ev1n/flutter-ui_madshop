import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../screens/product_screen.dart';
import '../services/favorites_service.dart';
import '../services/cart_service.dart';

class ProductCard extends StatefulWidget {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  final String description;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final FavoritesService _favoritesService = FavoritesService();
  final CartService _cartService = CartService();

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

  double _parsePrice(String priceString) {
    // Извлекаем число из строки типа "$17,00" (европейский формат с запятой)
    // Убираем все нецифровые символы кроме запятых и точек
    String cleaned = priceString.replaceAll(RegExp(r'[^\d,.]'), '');
    // Заменяем запятую на точку (для парсинга double)
    cleaned = cleaned.replaceAll(',', '.');
    // Парсим число
    return double.tryParse(cleaned) ?? 0.0;
  }

  void _showAddToCartDialog() {
    int quantity = 1;
    String selectedColor = 'Pink';
    String selectedSize = 'Size M';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Добавить в корзину'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Количество
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Количество:'),
                  Row(
                    children: [
                      IconButton(
                        icon: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 1),
                          ),
                          child: const Icon(Icons.remove, size: 16, color: AppColors.primary),
                        ),
                        onPressed: () {
                          if (quantity > 1) {
                            setDialogState(() {
                              quantity--;
                            });
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('$quantity', style: AppTextStyles.subtitle),
                      ),
                      IconButton(
                        icon: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 1),
                          ),
                          child: const Icon(Icons.add, size: 16, color: AppColors.primary),
                        ),
                        onPressed: () {
                          setDialogState(() {
                            quantity++;
                          });
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Цвет
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Цвет:'),
                  DropdownButton<String>(
                    value: selectedColor,
                    items: ['Pink', 'Blue', 'Black', 'White', 'Red']
                        .map((color) => DropdownMenuItem(
                              value: color,
                              child: Text(color),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedColor = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Размер
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Размер:'),
                  DropdownButton<String>(
                    value: selectedSize,
                    items: ['Size S', 'Size M', 'Size L', 'Size XL']
                        .map((size) => DropdownMenuItem(
                              value: size,
                              child: Text(size),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedSize = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final price = _parsePrice(widget.price);
                _cartService.addItem(
                  id: widget.id,
                  name: widget.name,
                  imageUrl: widget.imageUrl,
                  price: price,
                  quantity: quantity,
                  color: selectedColor,
                  size: selectedSize,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Товар добавлен в корзину (x$quantity)'),
                    backgroundColor: AppColors.success,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    // Проверяем, является ли путь локальным asset (начинается с 'assets/')
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.image_not_supported,
            size: 60,
            color: AppColors.textSecondary,
          );
        },
      );
    } else {
      // Иначе используем сетевой путь
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.image_not_supported,
            size: 60,
            color: AppColors.textSecondary,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = _favoritesService.isFavorite(widget.id);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.divider, width: 1),
      ),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductScreen(
                id: widget.id,
                name: widget.name,
                price: widget.price,
                imageUrl: widget.imageUrl,
                description: widget.description,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение товара
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 180,
                width: double.infinity,
                color: AppColors.divider,
                child: widget.imageUrl.isNotEmpty
                    ? _buildImage(widget.imageUrl)
                    : const Icon(
                        Icons.shopping_bag,
                        size: 60,
                        color: AppColors.textSecondary,
                      ),
              ),
            ),
            // Информация о товаре
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: AppTextStyles.bodySecondary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.price,
                          style: AppTextStyles.price,
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 20,
                                color: isFavorite
                                    ? AppColors.favorite
                                    : AppColors.textSecondary,
                              ),
                              onPressed: () {
                                _favoritesService.toggleFavorite(widget.id);
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 8),
                            Stack(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 20,
                                  ),
                                  onPressed: _showAddToCartDialog,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                if (_cartService.hasItem(widget.id))
                                  Positioned(
                                    right: 4,
                                    top: 4,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: AppColors.accent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

