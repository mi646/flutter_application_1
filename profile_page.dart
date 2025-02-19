import 'dart:convert';  // For json encoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Collect form data
      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      // Send data to backend (MongoDB through an API)
     final response = await http.post(
  Uri.parse('http://10.0.2.2:3000/api/users'), // Local backend URL
  headers: {'Content-Type': 'application/json'},
  body: json.encode({
    'name': name,
    'email': email,
    'password': password,
  }),
);


      if (response.statusCode == 200) {
        // If registration is successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration Successful'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // If there was an error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration Failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Welcome! Create your account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Join us and enjoy great deals!",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                _buildTextField(_nameController, "Full Name", Icons.person),
                const SizedBox(height: 16),
                _buildTextField(_emailController, "Email", Icons.email, isEmail: true),
                const SizedBox(height: 16),
                _buildPasswordField(_passwordController, "Password", Icons.lock, isPassword: true),
                const SizedBox(height: 16),
                _buildPasswordField(_confirmPasswordController, "Confirm Password", Icons.lock, isPassword: true, isConfirm: true),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        'Login',
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
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blueAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        fillColor: Colors.white,
        filled: true,
      ),
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      validator: (value) => value!.isEmpty ? "Please enter $label" : null,
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, IconData icon,
      {bool isPassword = false, bool isConfirm = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isConfirm ? !_isConfirmPasswordVisible : !_isPasswordVisible,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blueAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        fillColor: Colors.white,
        filled: true,
        suffixIcon: IconButton(
          icon: Icon(
            isConfirm ? (_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off) : (_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
            color: Colors.blueAccent,
          ),
          onPressed: () {
            setState(() {
              if (isConfirm) {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              } else {
                _isPasswordVisible = !_isPasswordVisible;
              }
            });
          },
        ),
      ),
      validator: isConfirm ? (value) => value != _passwordController.text ? "Passwords do not match" : null : null,
    );
  }
}
