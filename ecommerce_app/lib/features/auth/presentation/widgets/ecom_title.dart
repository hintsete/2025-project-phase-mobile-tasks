import 'package:flutter/material.dart';

class EcomTitle extends StatelessWidget {
  const EcomTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade700),
      ),
      child: const Text(
        'ECOM',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          letterSpacing: 2,
          fontFamily: 'poppins'
        ),
      ),
    );
  }
}
