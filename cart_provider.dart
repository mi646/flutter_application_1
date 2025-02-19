import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

double get totalAmount {
  double total = 0.0;
  for (var item in _cartItems) {
    double price = double.tryParse(item['price'].toString().replaceAll('\$', '')) ?? 0.0; // ✅ Remove "$" if present
    int quantity = (item['quantity'] is int) ? item['quantity'] : int.tryParse(item['quantity'].toString()) ?? 1;

    total += price * quantity;
  }
  return total; // ✅ Now it's always a double
}


  void addToCart(Map<String, dynamic> product) {
    int index = _cartItems.indexWhere((item) => item['id'] == product['id']);

    if (index != -1) {
      // ✅ If product already in cart, increase quantity
      _cartItems[index]['quantity'] += 1;
    } else {
      // ✅ Add product with default quantity 1
      _cartItems.add({
        'id': product['id'], // Unique ID for the product
        'name': product['name'],
        'price': product['price'], // ✅ Store as double
        'image': product['image'] ?? 'assets/default_image.png',
        'quantity': 1, // ✅ Default quantity 1
      });
    }
    notifyListeners(); // Notify UI to update
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      if (_cartItems[index]['quantity'] > 1) {
        _cartItems[index]['quantity'] -= 1; // ✅ Reduce quantity instead of removing immediately
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners(); // Notify UI to update after removal
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
