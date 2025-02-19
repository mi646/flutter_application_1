import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/product.dart';

class ApiService {
  Future<List<Product>> fetchProducts() async {
    try {
      // Simulating API delay
      await Future.delayed(const Duration(seconds: 2));

      // Load local JSON file from assets (Replace this with actual API call)
      final String response =
          await rootBundle.loadString('assets/data/products.json');
      final List<dynamic> data = json.decode(response);

      return data.map((json) => Product(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        imageUrl: json['imageUrl'],
        price: json['price'].toDouble(),
        description: json['description'],
      )).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<String>> fetchCategories() async {
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));

    return ['Candy', 'Haba', 'Kitchen', 'Hardware', 'Stationary', 'Decoration', 'Party'];
  }

  Future<List<Product>> fetchDeals() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      final String response =
          await rootBundle.loadString('assets/data/deals.json');
      final List<dynamic> data = json.decode(response);

      return data.map((json) => Product(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        imageUrl: json['imageUrl'],
        price: json['price'].toDouble(),
        description: json['description'],
      )).toList();
    } catch (e) {
      throw Exception('Failed to load deals: $e');
    }
  }
}
