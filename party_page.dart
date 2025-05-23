import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/party_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/provider/wishlist_provider.dart';

class PartyPage extends StatelessWidget {
  final List<Map<String, String>> products;
  final Function(Map<String, String>) addToCart;

  PartyPage({required this.products, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Party Supplies',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pinkAccent, Colors.purpleAccent], // Fun party colors 🎉
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: GridView.builder(
            shrinkWrap: true, // Ensures the grid only takes as much space as needed
            physics: const AlwaysScrollableScrollPhysics(), // Makes the GridView scrollable
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two items per row
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75, // Adjust aspect ratio for a good fit
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _buildProductCard(products[index], index, context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, String> product, int index, BuildContext context) {
    return Consumer<WishlistProvider>(
      builder: (context, wishlistProvider, child) {
        final isFavorite = wishlistProvider.isFavorite(product);

        return GestureDetector(
          onTap: () {
            // Navigate to PartyDetailPage when a card is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PartyDetailPage(
                  product: product,
                  addToCart: addToCart, // Pass the addToCart function correctly
                ),
              ),
            );
          },
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            shadowColor: Colors.grey.withOpacity(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 100, // Set a fixed height for the image
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    image: DecorationImage(
                      image: AssetImage(product['image']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            wishlistProvider.toggleWishlist(product);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name']!,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        product['price']!,
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      // Adjust the button's size and positioning within the card
                      SizedBox(
                        width: double.infinity,
                        height: 45, // Set a fixed height for the button to ensure visibility
                        child: ElevatedButton(
                          onPressed: () => addToCart(product),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
                            ),
                          ),
                          child: const Text("Add to Cart"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
