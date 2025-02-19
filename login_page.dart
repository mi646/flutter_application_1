import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'profile_page.dart'; // Ensuring correct navigation to Register page
import 'package:flutter/widgets.dart'; // Import WidgetsBinding for delayed navigation

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        final email = _emailController.text.trim().toLowerCase();
        final password = _passwordController.text;

        print('🔹 Sending Login Request...');
        print('🔹 Email: $email, Password: $password');

        final response = await http.post(
          Uri.parse('http://10.0.2.2:3001/login'), // Ensure same port as Register API
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': email, 'password': password}),
        );

        print('🔹 Response Status Code: ${response.statusCode}');
        print('🔹 Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          print('🔹 Parsed Response Data: $responseData');

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', responseData['token']); // Save the token

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Successful!'), backgroundColor: Colors.green),
          );

          // Delay navigation until after the current frame
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          });
        } else {
          // Handle error response safely
          try {
            final responseData = json.decode(response.body);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseData['message'] ?? 'Invalid credentials'), backgroundColor: Colors.red),
            );
          } catch (e) {
            print('❌ Error Parsing Response: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unexpected error. Please try again later.'), backgroundColor: Colors.red),
            );
          }
        }
      } catch (e) {
        print('❌ Login Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(_emailController, "Email", Icons.email, isEmail: true),
                const SizedBox(height: 16),
                _buildPasswordField(_passwordController, "Password", Icons.lock),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 5,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfilePage()),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter $label';
        if (isEmail && !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: IconButton(
          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
    );
  }
}
