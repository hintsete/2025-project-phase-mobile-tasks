import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  const TitleBar({super.key, required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Available Products",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: onSearchTap,
            icon: const Icon(Icons.search, size: 24),
          ),
        ],
      ),
    );
  }
}
