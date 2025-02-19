import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import 'shipping_payment_page.dart'; // ✅ Import the Shipping & Payment Page

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
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
                          borderRadius: BorderRadius.circular(8), // ✅ Rounded image corners
                          child: Image.asset(
                            item['image'] ?? 'assets/default_image.png',
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
                        trailing: Text(
                          "Qty: ${item['quantity'] ?? 1}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),

                // ✅ Unique "Total" Section - Clean and Modern
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "\$${cartProvider.totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
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
                  MaterialPageRoute(builder: (context) => const ShippingPaymentPage()),
                );
              },
              icon: const Icon(Icons.payment),
              label: const Text("Proceed to Payment"),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            )
          : null, // Hide button if cart is empty
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
