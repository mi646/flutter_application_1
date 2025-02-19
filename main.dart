import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/provider/cart_provider.dart';
import 'package:flutter_application_1/provider/wishlist_provider.dart';
// Screens
import 'package:flutter_application_1/screens/home_page.dart';
import 'package:flutter_application_1/screens/cart_page.dart' as cart_screen;
import 'package:flutter_application_1/screens/profile_page.dart';
import 'package:flutter_application_1/screens/wishlist_page.dart';
import 'package:flutter_application_1/screens/checkout_page.dart';
import 'package:flutter_application_1/screens/Shipping_Payment_Page.dart'; 
import 'package:flutter_application_1/screens/Order_Confirmation_Page.dart'; 

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your Dollar Store With More',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
      ),
      // Set the initial route to Splash Screen
      routes: {
        '/login': (context) => const LoginPage(),
        '/': (context) => const SplashScreen(), // Splash screen as the first screen
        '/home': (context) => const BottomNavBar(), // Use BottomNavBar here
        '/cart': (context) => const cart_screen.CartPage(),
        '/profile': (context) => const ProfilePage(),
        '/wishlist': (context) => const WishlistPage(),
        '/checkout': (context) => const CheckoutPage(),
        '/shipping-payment': (context) => const ShippingPaymentPage(),
        '/order-confirmation': (context) => const OrderConfirmationPage(),
      },
    );
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the home screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black background
      body: Center(
        child: Image.asset(
          'assets/images/logo.png', // Path to your logo image in assets folder
          width: 150, // Adjust the size of your logo as needed
          height: 150, // Adjust the size of your logo as needed
        ),
      ),
    );
  }
}

// Login Page
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Simulate login function
  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Validate email and password (You can replace this with actual validation)
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    // Simulate the login process (replace with actual API or validation)
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    // Show login success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login successful')),
    );

    // Redirect to home page after login
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

// Bottom Navigation Bar
class BottomNavBar extends StatefulWidget {
  final int initialIndex; // Allow setting the starting tab

  const BottomNavBar({super.key, this.initialIndex = 0}); // Default to Home tab

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Use initialIndex from constructor
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      const HomePage(),
      const cart_screen.CartPage(),
      const WishlistPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: _screens[_selectedIndex], // Change the screen based on index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
