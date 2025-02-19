import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/candy_page.dart';
import 'package:flutter_application_1/screens/beauty_page.dart';
import 'package:flutter_application_1/screens/cards_page.dart';
import 'package:flutter_application_1/screens/decoration_page.dart';
import 'package:flutter_application_1/screens/kitchen_page.dart';
import 'package:flutter_application_1/screens/hardware_page.dart';
import 'package:flutter_application_1/screens/party_page.dart';
import 'package:flutter_application_1/screens/school_page.dart';
import 'package:flutter_application_1/provider/cart_provider.dart';
import 'package:flutter_application_1/screens/wishlist_page.dart';
import 'package:flutter_application_1/provider/wishlist_provider.dart';
import 'package:provider/provider.dart';

// categories two run
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dollar Store',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController(); // ✅ Fix: Initialize immediately

  List<Map<String, String>> _allProducts = []; // ✅ Example product list
  List<Map<String, String>> _filteredProducts = []; // ✅ Filtered products list

  @override
  void initState() {
    super.initState();
    // ✅ Initialize products list
    _allProducts = [
      {'name': 'Chocolate Bar', 'price': '\$5.99', 'image': 'assets/images/choclate7.jpg'},
      {'name': 'Notebook', 'price': '\$3.99', 'image': 'assets/images/notebook.jpg'},
      {'name': 'Kitchen Set', 'price': '\$12.99', 'image': 'assets/images/kitchen1.jpg'},
      {'name': 'Party Supplies', 'price': '\$7.99', 'image': 'assets/images/party3.jpg'},
      {'name': 'Gift Cards', 'price': '\$5.00', 'image': 'assets/images/card6.jpg'},
      {'name': 'Beauty Kit', 'price': '\$9.99', 'image': 'assets/images/beauty6.jpg'},
    ];

    _filteredProducts = List.from(_allProducts); // ✅ Start with all products
  }

  @override
  void dispose() {
    _searchController.dispose(); // ✅ Dispose controller to prevent memory leaks
    super.dispose();
  }

  // ✅ Search function to filter products
  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _allProducts
          .where((product) =>
              product['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _addToCart(Map<String, String> product) {
    Provider.of<CartProvider>(context, listen: false).addToCart(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product['name']} added to cart!"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Dollar Store With More"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            color: Colors.red,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishlistPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchBar(_searchController, _filterProducts), // ✅ No more LateInitializationError
            const SizedBox(height: 10),
          
            const SizedBox(height: 10),
            _buildCategories(),
            const SizedBox(height: 10),
            _buildFeaturedSection(), // ✅ Featured Products Section
            const SizedBox(height: 10),
            _buildProductGrid(),
          ],
        ),
      ),
    );
  }

  // ✅ Fixed Search Bar function
  Widget _buildSearchBar(TextEditingController controller, Function(String) onSearch) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: controller,
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: "Search products...",
          prefixIcon: const Icon(Icons.search),
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



  // ✅ Featured Products Section
  Widget _buildFeaturedSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        "Featured Products",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  // ✅ Build Product Grid
  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          return _buildProductCard(_filteredProducts[index], index, context);
        },
      ),
    );
  }

  // Product Card Widget
  Widget _buildProductCard(Map<String, String> product, int index, BuildContext context) {
    return Consumer<WishlistProvider>(
      builder: (context, wishlistProvider, child) {
        final isFavorite = wishlistProvider.isFavorite(product);

        return Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: Colors.grey.withOpacity(0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 110, //  Set a fixed height for better alignment
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
              const SizedBox(height: 3),
              SingleChildScrollView(
                child: Padding(
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
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () => _addToCart(product),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
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
              ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildCategories() {
    final List<String> categories = ['Candy', 'Beauty', 'cards', 'decoration', 'kitchen', 'hardware', 'party', 'school'];
    final List<String> categoryImages = [
      'assets/images/Candy.webp',
      'assets/images/Beauty.webp',
      'assets/images/Cards.webp',
      'assets/images/Decoration.webp',
      'assets/images/Kitchen.webp',
      'assets/images/Hardware.jpg',
      'assets/images/Party.webp',
      'assets/images/books.jpg',
      
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Categories",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (categories[index] == 'Candy') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CandyPage(
                          products: [
                            {
                              'id': 'product1',
                              'name': 'Hersheys',
                              'price': '\$2.99',
                              'image': 'assets/images/choclate1.jpg',
                              'description': 'Rich and creamy chocolate with a smooth texture.'
                            },
                            {
                              'id': 'product2',
                              'name': 'Lindt',
                              'price': '\$10.99',
                              'image': 'assets/images/choclate2.jpg',
                              'description': 'Rich and creamy chocolate with a smooth texture.'
                            },
                             {
                              'id': 'product3',
                              'name': 'Cadbury',
                              'price': '\$10.99',
                              'image': 'assets/images/choclate3.jpg',
                              'description': 'Rich and creamy chocolate with a smooth texture.'
                            },
                             {
                              'id': 'product4',
                              'name': 'Ghirardelli',
                              'price': '\$10.99',
                              'image': 'assets/images/choclate4.jpg',
                              'description': 'Rich and creamy chocolate with a smooth texture.'
                            },
                             {
                              'id': 'product5',
                              'name': 'Dove',
                              'price': '\$10.99',
                              'image': 'assets/images/choclate5.jpg',
                              'description': 'Rich and creamy chocolate with a smooth texture.'
                            },
                             {
                              'id': 'product6',
                              'name': 'Godiva',
                              'price': '\$10.99',
                              'image': 'assets/images/choclate6.jpg',
                              'description': 'Rich and creamy chocolate with a smooth texture.'
                            },
                             {
                              'id': 'product7',
                              'name': 'Milka',
                              'price': '\$10.99',
                              'image': 'assets/images/choclate7.jpg',
                              'description': 'Rich and creamy chocolate with a smooth texture.'
                            },
                             {
                              'id': 'product8',
                              'name': 'Ferrero Rocher',
                              'price': '\$10.99',
                              'image': 'assets/images/choclate8.jpg',
                              'description': 'Rich and creamy chocolate with a smooth texture.'
                            },
                             {
                              'id': 'product9',
                              'name': 'Nestlé',
                              'price': '\$10.99',
                              'image': 'assets/images/choclate9.jpg',
                              'description': 'Rich and creamy chocolate with a smooth texture.'
                            },
                             {
                              'id': 'product10',
                              'name': 'Toblerone',
                              'price': '\$10.99',
                              'image': 'assets/images/choclate10.jpg',
                              'description': 'Rich and creamy chocolate with a smooth texture.'
                            },
                             {
                              'id': 'product11',
                              'name': 'Kit Kat',
                              'price': '\$10.99',
                              'image': 'assets/images/choclate11.jpg',
                              'description': 'Rich and creamy chocolate with a smooth texture.'
                            },
                             {
                              'id': 'product12',
                              'name': 'M&M',
                              'price': '\$10.99',
                              'image': 'assets/images/choclate12.jpg',
                              'description': 'Rich and creamy chocolate with a smooth texture.'
                            },
                             {
                              'id': 'product13',
                              'name': 'Snickers',
                              'price': '\$10.99',
                              'image': 'assets/images/choclate13.jpg',
                              'description': 'Rich and creamy chocolate with a smooth texture.'
                            },
                          ],
                          addToCart: _addToCart,
                        ),
                      ),
                    );
                  } else if (categories[index] == 'Beauty') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BeautyPage(
                          products: [
                            {
                              'id': 'product14',
                              'name': 'beauty1',
                              'price': '\$9.99',
                              'image': 'assets/images/beauty1.jpg',
                              'description': 'A high-quality, long-lasting lipstick with a smooth matte finish.',
                            },
                            {
                              'id': 'product15',
                              'name': 'beauty2',
                              'price': '\$9.99',
                              'image': 'assets/images/beauty2.jpg',
                              'description': 'A high-quality, long-lasting lipstick with a smooth matte finish.',
                            },
                            {
                              'id': 'product16',
                              'name': 'beauty3',
                              'price': '\$9.99',
                              'image': 'assets/images/beauty3.jpg',
                              'description': 'A high-quality, long-lasting lipstick with a smooth matte finish.',
                            },
                            {
                              'id': 'product17',
                              'name': 'beauty4',
                              'price': '\$9.99',
                              'image': 'assets/images/beauty4.jpg',
                              'description': 'A high-quality, long-lasting lipstick with a smooth matte finish.',
                            },
                            {
                              'id': 'product18',
                              'name': 'beauty5',
                              'price': '\$9.99',
                              'image': 'assets/images/beauty5.jpg',
                              'description': 'A high-quality, long-lasting lipstick with a smooth matte finish.',
                            
                            },
                            {
                              'id': 'product19',
                              'name': 'beauty6',
                              'price': '\$9.99',
                              'image': 'assets/images/beauty6.jpg',
                              'description': 'A high-quality, long-lasting lipstick with a smooth matte finish.',
                            },
                            {
                              'id': 'product20',
                              'name': 'beauty7',
                              'price': '\$9.99',
                              'image': 'assets/images/beauty7.jpg',
                              'description': 'A high-quality, long-lasting lipstick with a smooth matte finish.',
                            },
                            {
                              'id': 'product21',
                              'name': 'beauty8',
                              'price': '\$9.99',
                              'image': 'assets/images/beauty8.jpg',
                              'description': 'A high-quality, long-lasting lipstick with a smooth matte finish.',
                            },
                            {
                              'id': 'product22',
                              'name': 'beauty9',
                              'price': '\$9.99',
                              'image': 'assets/images/beauty9.jpg',
                              'description': 'A high-quality, long-lasting lipstick with a smooth matte finish.',
                            },
                            {
                              'id': 'product23',
                              'name': 'beauty10',
                              'price': '\$9.99',
                              'image': 'assets/images/beauty10.jpg',
                              'description': 'A high-quality, long-lasting lipstick with a smooth matte finish.',
                            },
                            {
                              'id': 'product24',
                              'name': 'beauty11',
                              'price': '\$9.99',
                              'image': 'assets/images/beauty11.jpg',
                              'description': 'A high-quality, long-lasting lipstick with a smooth matte finish.',
                            },
                            {
                              'id': 'product25',
                              'name': 'beauty12',
                              'price': '\$9.99',
                              'image': 'assets/images/beauty12.jpg',
                              'description': 'A high-quality, long-lasting lipstick with a smooth matte finish.',
                            },
                          ],
                          addToCart: _addToCart,
                        ),
                      ),
                    );
                  }else if (categories[index] == 'cards') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CardsPage(
        products: [
          {
            'id': 'product26',
            'name': 'Gift Cards1',
            'price': '\$5.00',
            'image': 'assets/images/card1.jpg',
          },
            {
              'id': 'product27',
            'name': 'Gift Cards2',
            'price': '\$5.00',
            'image': 'assets/images/card2.jpg',
          },
            {
              'id': 'product28',
            'name': 'Gift Cards3',
            'price': '\$5.00',
            'image': 'assets/images/card3.jpg',
          },
            {
              'id': 'product29',
            'name': 'Gift Cards4',
            'price': '\$5.00',
            'image': 'assets/images/card4.jpg',
          },
            {
              'id': 'product30',
            'name': 'Gift Cards5',
            'price': '\$5.00',
            'image': 'assets/images/card5.jpg',
          },
            {
              'id': 'product31',
            'name': 'Gift Cards6',
            'price': '\$5.00',
            'image': 'assets/images/card6.jpg',
          },
            {
              'id': 'product32',
            'name': 'Gift Cards7',
            'price': '\$5.00',
            'image': 'assets/images/card7.jpg',
          },
        ],
        addToCart: _addToCart,
      ),
    ),
  );
}else if (categories[index] == 'decoration') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DecorationPage(
        products: [
          {
            'id': 'product33',
            'name': 'Decorative Vase1',
            'price': '\$12.99',
            'image': 'assets/images/decoration1.jpg',
          },
          {
            'id': 'product34',
            'name': 'Decorative Vase2',
            'price': '\$12.99',
            'image': 'assets/images/decoration2.jpg',
          },
          {
            'id': 'product35',
            'name': 'Decorative Vase3',
            'price': '\$12.99',
            'image': 'assets/images/decoration3.jpg',
          },
          {
            'id': 'product36',
            'name': 'Decorative Vase4',
            'price': '\$12.99',
            'image': 'assets/images/decoration4.jpg',
          },
          {
            'id': 'product37',
            'name': 'Decorative Vase5',
            'price': '\$12.99',
            'image': 'assets/images/decoration5.jpg',
          },
          {
            'id': 'product38',
            'name': 'Decorative Vase6',
            'price': '\$12.99',
            'image': 'assets/images/decoration6.jpg',
          },
          {
            'id': 'product39',
            'name': 'Decorative Vase7',
            'price': '\$12.99',
            'image': 'assets/images/decoration7.jpg',
          },
          {
            'id': 'product40',
            'name': 'Decorative Vase8',
            'price': '\$12.99',
            'image': 'assets/images/decoration8.jpg',
          },
          {
            'id': 'product41',
            'name': 'Decorative Vase9',
            'price': '\$12.99',
            'image': 'assets/images/decoration9.jpg',
          },
          {
            'id': 'product42',
            'name': 'Decorative Vase10',
            'price': '\$12.99',
            'image': 'assets/images/decoration10.jpg',
          },
        ],
        addToCart: _addToCart,
      ),
    ),
  );
}
else if (categories[index] == 'kitchen') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => KitchenPage(
        products: [
          {
            'id': 'product43',
            'name': 'Pan1',
            'price': '\$15.99',
            'image': 'assets/images/kitchen1.jpg',
          },
          {
            'id': 'product44',
            'name': 'Pan2',
            'price': '\$15.99',
            'image': 'assets/images/kitchen2.jpg',
          },
          {
            'id': 'product45',
            'name': 'Pan3',
            'price': '\$15.99',
            'image': 'assets/images/kitchen3.jpg',
          },
          {
            'id': 'product46',
            'name': 'Pan4',
            'price': '\$15.99',
            'image': 'assets/images/kitchen4.jpg',
          },
          {
            'id': 'product47',
            'name': 'Pan5',
            'price': '\$15.99',
            'image': 'assets/images/kitchen5.jpg',
          },
          {
            'id': 'product48',
            'name': 'Pan6',
            'price': '\$15.99',
            'image': 'assets/images/kitchen6.jpg',
          },
          {
            'id': 'product49',
            'name': 'Pan7',
            'price': '\$15.99',
            'image': 'assets/images/kitchen7.jpg',
          },
          {
            'id': 'product50',
            'name': 'Pan8',
            'price': '\$15.99',
            'image': 'assets/images/kitchen8.jpg',
          },
          {
            'id': 'product51',
            'name': 'Pan9',
            'price': '\$15.99',
            'image': 'assets/images/kitchen9.jpg',
          },
          {
            'id': 'product52',
            'name': 'Pan10',
            'price': '\$15.99',
            'image': 'assets/images/kitchen9.jpg',
          },
        ],
        addToCart: _addToCart,
      ),
    ),
  );
}
else if (categories[index] == 'hardware') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HardwarePage(
        products: [
          {
            'id': 'product53',
            'name': 'Hammer1',
            'price': '\$9.99',
            'image': 'assets/images/hardware1.jpg',
          },
           {
            'id': 'product54',
            'name': 'Hammer2',
            'price': '\$9.99',
            'image': 'assets/images/hardware2.jpg',
          },
           {
            'id': 'product55',
            'name': 'Hammer3',
            'price': '\$9.99',
            'image': 'assets/images/hardware3.jpg',
          },
           {
            'id': 'product56',
            'name': 'Hammer4',
            'price': '\$9.99',
            'image': 'assets/images/hardware4.jpg',
          },
           {
            'id': 'product57',
            'name': 'Hammer5',
            'price': '\$9.99',
            'image': 'assets/images/hardware5.jpg',
          },
           {
            'id': 'product58',
            'name': 'Hammer6',
            'price': '\$9.99',
            'image': 'assets/images/hardware6.jpg',
          },
        ],
        addToCart: _addToCart,
      ),
    ),
  );
}
else if (categories[index] == 'party') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PartyPage(
        products: [
          {
            'id': 'product59',
            'name': 'Balloons Pack1',
            'price': '\$4.99',
            'image': 'assets/images/party1.jpg',
          },
          {
            'id': 'product60',
            'name': 'Balloons Pack2',
            'price': '\$4.99',
            'image': 'assets/images/party2.jpg',
          },
          {
            'id': 'product61',
            'name': 'Balloons Pack3',
            'price': '\$4.99',
            'image': 'assets/images/party3.jpg',
          },
          {
            'id': 'product62',
            'name': 'Balloons Pack4',
            'price': '\$4.99',
            'image': 'assets/images/party4.jpg',
          },
          {
            'id': 'product63',
            'name': 'Balloons Pack5',
            'price': '\$4.99',
            'image': 'assets/images/party5.jpg',
          },
          {
            'id': 'product64',
            'name': 'Balloons Pack6',
            'price': '\$4.99',
            'image': 'assets/images/party6.jpg',
          },
          {
            'id': 'product65',
            'name': 'Balloons Pack7',
            'price': '\$4.99',
            'image': 'assets/images/party7.jpg',
          },
          {
            'id': 'product66',
            'name': 'Balloons Pack8',
            'price': '\$4.99',
            'image': 'assets/images/party8.jpg',
          },
          {
            'id': 'product67',
            'name': 'Balloons Pack9',
            'price': '\$4.99',
            'image': 'assets/images/party9.jpg',
          },
         
        ],
        addToCart: _addToCart,
      ),
    ),
  );
}
else if (categories[index] == 'school') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SchoolPage(
        products: [
          {
            'id': 'product68',
            'name': 'Notebook1',
            'price': '\$3.99',
            'image': 'assets/images/school1.jpg',
          },
          {
            'id': 'product69',
            'name': 'Notebook2',
            'price': '\$3.99',
            'image': 'assets/images/school2.jpg',
          },
          {
            'id': 'product70',
            'name': 'Notebook3',
            'price': '\$3.99',
            'image': 'assets/images/school3.jpg',
          },
          {
            'id': 'product71',
            'name': 'Notebook4',
            'price': '\$3.99',
            'image': 'assets/images/school4.jpg',
          },
          {
            'id': 'product72',
            'name': 'Notebook5',
            'price': '\$3.99',
            'image': 'assets/images/school5.jpg',
          },
          {
            'id': 'product73',
            'name': 'Notebook6',
            'price': '\$3.99',
            'image': 'assets/images/school6.jpg',
          },
          {
            'id': 'product74',
            'name': 'Notebook7',
            'price': '\$3.99',
            'image': 'assets/images/school7.jpg',
          },
          {
            'id': 'product75',
            'name': 'Notebook8',
            'price': '\$3.99',
            'image': 'assets/images/school8.jpg',
          },
          {
            'id': 'product76',
            'name': 'Notebook9',
            'price': '\$3.99',
            'image': 'assets/images/school9.jpg',
          },
          {
            'id': 'product77',
            'name': 'Notebook10',
            'price': '\$3.99',
            'image': 'assets/images/school10.jpg',
          },
          
        ],
        addToCart: _addToCart,
      ),
    ),
  );
}





                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.purple.shade100,
                        backgroundImage: AssetImage(categoryImages[index]),
                      ),
                      const SizedBox(height: 5),
                      Text(categories[index]),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 🛒 **Cart Page**
class CartPage extends StatelessWidget {
  final List<Map<String, String>> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty!", style: TextStyle(fontSize: 18)))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(cartItems[index]['image']!, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(cartItems[index]['name']!),
                  subtitle: Text(cartItems[index]['price']!),
                );
              },
            ),
    );
  }
}