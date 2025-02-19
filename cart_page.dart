import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import 'checkout_page.dart'; // ✅ Import the Checkout Page

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;
    final totalAmount = cartProvider.totalAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.blueAccent,
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8), // Rounded corners for image
                          child: Image.asset(
                            item['image'] ?? 'assets/default_image.png', // ✅ Default image if null
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          item['name'] ?? 'Unknown Item',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          "Price: \$${(double.tryParse(item['price'].toString().replaceAll('\$', '')) ?? 0.0).toStringAsFixed(2)}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            cartProvider.removeFromCart(index);
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Total and Checkout Button Section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ Unique "Total" Design - Simple, Clean, and Modern
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total:",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "\$${totalAmount.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60), // Spacing for Floating Checkout Button
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: cartItems.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CheckoutPage()),
                );
              },
              icon: const Icon(Icons.shopping_bag),
              label: const Text("Proceed to Checkout"),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            )
          : null, // Hide button if cart is empty
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
