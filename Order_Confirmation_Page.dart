import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart'; // Import main.dart to access BottomNavBar

class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Confirmation")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Your order has been placed successfully!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // ✅ Reset navigation and explicitly set the tab to Home
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomNavBar(initialIndex: 0), // ✅ Force Home Tab
                  ),
                  (route) => false, // ✅ Remove all previous routes
                );
              },
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
