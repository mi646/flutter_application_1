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
  String _paymentMethod = 'Credit Card'; // Default selection

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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (value) => value!.isEmpty ? "Please enter your name" : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Shipping Address"),
                validator: (value) => value!.isEmpty ? "Please enter your address" : null,
                onSaved: (value) => _address = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? "Please enter your phone number" : null,
                onSaved: (value) => _phone = value!,
              ),
              const SizedBox(height: 20),

              const Text(
                "Payment Method",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text("Complete Order"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
