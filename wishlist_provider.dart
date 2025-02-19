import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Map<String, String>> _wishlistItems = [];

  // To get the list of wishlist items
  List<Map<String, String>> get wishlistItems => List.unmodifiable(_wishlistItems);

  // To add/remove items from the wishlist
  void toggleWishlist(Map<String, String> product) {
    final existingIndex = _wishlistItems.indexWhere((item) => item['name'] == product['name']);

    if (existingIndex != -1) {
      _wishlistItems.removeAt(existingIndex); // Remove if already exists
    } else {
      _wishlistItems.add(product); // Add if not exists
    }

    notifyListeners();
  }

  // To check if a product is already in the wishlist
  bool isFavorite(Map<String, String> product) {
    return _wishlistItems.any((item) => item['name'] == product['name']);
  }

  // ✅ NEW: Clear all items from the wishlist
  void clearWishlist() {
    _wishlistItems.clear(); // Empty the wishlist
    notifyListeners(); // Notify listeners to update UI
  }
}
