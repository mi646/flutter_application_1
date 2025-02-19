import 'package:flutter/material.dart';
import 'order_confirmation_page.dart'; // ✅ Import Order Confirmation Page

class ShippingPaymentPage extends StatefulWidget {
  const ShippingPaymentPage({super.key});

  @override
  _ShippingPaymentPageState createState() => _ShippingPaymentPageState();
}

class _ShippingPaymentPageState extends State<ShippingPaymentPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _address = '';
  String _phone = '';
  String _paymentMethod = 'Credit Card'; // ✅ Default selection

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // ✅ Debugging - Print data to console
      print("Name: $_name");
      print("Address: $_address");
      print("Phone: $_phone");
      print("Payment Method: $_paymentMethod");

      // ✅ Navigate to Order Confirmation Page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OrderConfirmationPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shipping & Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Shipping Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildTextField("Full Name", (value) => _name = value),
              _buildTextField("Shipping Address", (value) => _address = value),
              _buildTextField("Phone Number", (value) => _phone = value, isPhone: true),
              const SizedBox(height: 20),

              const Text(
                "Payment Method",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                items: ["Credit Card", "PayPal", "Cash on Delivery"].map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
              const SizedBox(height: 80), // Space for floating button
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitForm,
        icon: const Icon(Icons.check),
        label: const Text("Complete Order"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ✅ Helper function to build text fields
  Widget _buildTextField(String label, Function(String) onSaved, {bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        validator: (value) => value!.isEmpty ? "Please enter $label" : null,
        onSaved: (value) => onSaved(value!),
      ),
    );
  }
}
