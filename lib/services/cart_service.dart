import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;
  String color;
  String size;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    this.color = 'Pink',
    this.size = 'Size M',
  });
}

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  bool hasItem(String id) {
    return _items.any((item) => item.id == id);
  }

  CartItem? getItem(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  void addItem({
    required String id,
    required String name,
    required String imageUrl,
    required double price,
    int quantity = 1,
    String color = 'Pink',
    String size = 'Size M',
  }) {
    final existingItem = getItem(id);
    if (existingItem != null) {
      // Если товар уже есть, увеличиваем количество
      existingItem.quantity += quantity;
    } else {
      // Добавляем новый товар
      _items.add(CartItem(
        id: id,
        name: name,
        imageUrl: imageUrl,
        price: price,
        quantity: quantity,
        color: color,
        size: size,
      ));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    final item = getItem(id);
    if (item != null) {
      if (quantity <= 0) {
        removeItem(id);
      } else {
        item.quantity = quantity;
        notifyListeners();
      }
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}


