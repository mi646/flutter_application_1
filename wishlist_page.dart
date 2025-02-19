import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/provider/wishlist_provider.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItems = wishlistProvider.wishlistItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // ✅ Back button
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: wishlistItems.isEmpty
          ? const Center(
              child: Text(
                'Your wishlist is empty!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: wishlistItems.length,
                    itemBuilder: (context, index) {
                      final product = wishlistItems[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // ✅ Rounded corners
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12), // ✅ Better spacing
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8), // ✅ Rounded image
                            child: Image.asset(
                              product['image'] ?? 'assets/default_image.png',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            product['name'] ?? 'Unknown Product',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            "Price: \$${(double.tryParse(product['price'].toString().replaceAll('\$', '')) ?? 0.0).toStringAsFixed(2)}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              wishlistProvider.toggleWishlist(product);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ✅ Floating "Clear Wishlist" Button
                if (wishlistItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          wishlistProvider.clearWishlist(); // ✅ Clear wishlist function
                        },
                        icon: const Icon(Icons.delete_forever),
                        label: const Text("Clear Wishlist"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
