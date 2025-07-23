import 'dart:io';
import 'package:flutter/material.dart';
import 'package:task_6/models/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Product> _products = [];

  void _addOrUpdateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    setState(() {
      if (index == -1) {
        _products.add(product);
      } else {
        _products[index] = product;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/add_update',
            arguments: {
              'onSave': _addOrUpdateProduct,
            },
          );
        },
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("July 21, 2025", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text.rich(
                        TextSpan(
                          text: "Hello, ",
                          children: [
                            TextSpan(
                              text: "Yohannes",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.notifications_none, color: Colors.black),
                  ),
                ],
              ),
            ),

        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Available Products", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/search',
                        arguments: {
                          'products': _products,
                        },
                      );
                    },
                    icon: const Icon(Icons.search, size: 24),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

      
            Expanded(
              child: _products.isEmpty
                  ? const Center(child: Text("No products added yet."))
                  : ListView.builder(
                      itemCount: _products.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, idx) {
                        final product = _products[idx];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/product_detail',
                              arguments: {
                                'product': product,
                                'onUpdate': _addOrUpdateProduct,
                              },
                            );
                          },
                          child: _productCard(product),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productCard(Product product) {
    final bool isLocalFile = product.imageUrl.startsWith('/');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
       
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: isLocalFile
                ? Image.file(File(product.imageUrl), fit: BoxFit.cover, height: 280, width: double.infinity)
                : Image.asset(product.imageUrl, fit: BoxFit.cover, height: 280, width: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(product.description, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


