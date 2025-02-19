import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 189, 48, 78),
      title: Row(
        children: [
          Icon(Icons.shopping_cart, size: 30), // Adjusted icon size
          SizedBox(width: 10),
          Flexible(
            child: Text(
              'YOUR DOLLAR STORE WITH MORE',
              style: TextStyle(fontSize: 18), // Adjusted text size
              overflow: TextOverflow.ellipsis, // Handle long text overflow
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, size: 28), // Adjusted icon size for visibility
          onPressed: () {
            // Search functionality
          },
        ),
        IconButton(
          icon: Icon(Icons.account_circle, size: 28), // Adjusted icon size for visibility
          onPressed: () {
            // Navigate to profile
          },
        ),
      ],
    );
  }
}
