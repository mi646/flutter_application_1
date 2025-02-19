import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(product.imageUrl, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text('\$${product.price.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
