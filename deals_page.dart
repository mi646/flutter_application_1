import 'package:flutter/material.dart';

class DealsPage extends StatelessWidget {
  const DealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deals')),
      body: const Center(child: Text('Special deals coming soon!')),
    );
  }
}
