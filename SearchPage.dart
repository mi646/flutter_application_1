import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final List<Map<String, dynamic>> allProducts;

  const SearchPage({super.key, required this.allProducts});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> _filteredProducts = [];
  late TextEditingController _searchController; // ✅ Declare controller

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(); // ✅ Initialize controller
    _filteredProducts = widget.allProducts;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = widget.allProducts
          .where((product) =>
              product['name'].toString().toLowerCase().contains(query.toLowerCase().trim()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Products"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(_searchController, _filterProducts), // ✅ FIXED: Variables are now defined
          const SizedBox(height: 10),
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(
                    child: Text(
                      "No products found!",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ✅ FIXED: _buildSearchBar now expects 2 arguments
  Widget _buildSearchBar(TextEditingController controller, Function(String) onSearch) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: controller,
        onChanged: onSearch, // ✅ Now it correctly passes a String query
        decoration: InputDecoration(
          hintText: "Search products...",
          prefixIcon: const Icon(Icons.search, color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
}
