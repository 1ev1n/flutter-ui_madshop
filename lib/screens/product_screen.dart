import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../services/cart_service.dart';

class ProductScreen extends StatefulWidget {
  final String id;
  final String name;
  final String price;
  final String imageUrl;
  final String description;

  const ProductScreen({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    _cartService.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cartService.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  bool get isInCart => _cartService.hasItem(widget.id);

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
            size: 100,
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
            size: 100,
            color: AppColors.textSecondary,
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение товара
            Container(
              width: double.infinity,
              height: 300,
              color: AppColors.divider,
              child: widget.imageUrl.isNotEmpty
                  ? _buildImage(widget.imageUrl)
                  : const Icon(
                      Icons.shopping_bag,
                      size: 100,
                      color: AppColors.textSecondary,
                    ),
            ),
            // Информация о товаре
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: AppTextStyles.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.price,
                    style: AppTextStyles.priceLarge,
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Описание',
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 32),
                  // Кнопка добавления в корзину
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isInCart ? null : _showAddToCartDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        isInCart ? 'В корзине' : 'Добавить в корзину',
                        style: AppTextStyles.button,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

