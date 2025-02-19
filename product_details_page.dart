import 'package:flutter/material.dart';
import 'dart:ui'; // For blur effect

class CandyDetailPage extends StatelessWidget {
  final Map<String, String> product;
  final Function(Map<String, String>) addToCart;

  CandyDetailPage({required this.product, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.deepOrangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Column(
            children: [
              // Image with Curved Bottom
              ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                child: Image.asset(
                  product['image']!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              // Card for Details
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Name
                      Text(
                        product['name']!,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),

                      // Price
                      Text(
                        "Price: ${product['price']!}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Description
                      const Text(
                        "Indulge in the delicious world of sweet treats with our premium selection of candies! Made with high-quality ingredients and a burst of flavors, this candy is perfect for every sweet lover.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // **Blurred AppBar for Better Back Button Visibility**
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.black.withOpacity(0.2), // Slight tint for visibility
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          product['name']!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => addToCart(product),
        icon: const Icon(Icons.shopping_cart),
        label: const Text("Add to Cart"),
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
