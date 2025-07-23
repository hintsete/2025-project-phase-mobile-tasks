import 'dart:io';
import 'package:flutter/material.dart';
import 'package:task_6/models/product.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  RangeValues _priceRange = const RangeValues(0, 100);
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();


  Map<String, String> _productCategories = {
    'p1': 'Leather',
    'p2': 'Shoes',
    'p3': 'Bags',
    'p4': 'Accessories',
    
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null && args['products'] != null) {
      _allProducts = List<Product>.from(args['products']);
      _filteredProducts = List<Product>.from(_allProducts);
      _filterProducts();
    }
  }

  void _filterProducts() {
    final searchQuery = _searchController.text.toLowerCase().trim();
    final categoryQuery = _categoryController.text.toLowerCase().trim();

    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final matchesTitle = product.title.toLowerCase().contains(searchQuery);
        final inPriceRange =
            product.price >= _priceRange.start && product.price <= _priceRange.end;

        final productCategory = _productCategories[product.id]?.toLowerCase() ?? '';

        final matchesCategory = categoryQuery.isEmpty
            ? true
            : productCategory.contains(categoryQuery);

        if (searchQuery.isEmpty && categoryQuery.isEmpty) {
          return inPriceRange;
        } else if (searchQuery.isNotEmpty && categoryQuery.isEmpty) {
          return matchesTitle && inPriceRange;
        } else if (searchQuery.isEmpty && categoryQuery.isNotEmpty) {
          return matchesCategory && inPriceRange;
        } else {
          return matchesTitle && matchesCategory && inPriceRange;
        }
      }).toList();

      if (_filteredProducts.isEmpty) {
        _filteredProducts = List<Product>.from(_allProducts);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
     
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.blueAccent),
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Search Product",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) {
                            
                          },
                          decoration: InputDecoration(
                            hintText: "Search by title...",
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search, color: Colors.blueAccent),
                              onPressed: _filterProducts,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.filter_list, color: Colors.white, size: 20),
                          onPressed: _filterProducts,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

        
            Expanded(
              child: _filteredProducts.isEmpty
                  ? const Center(child: Text("No products found"))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(_filteredProducts[index]);
                      },
                    ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category input
                  const Text("Category", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                      hintText: "Enter category...",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

  
                  const Text("Price", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                  const SizedBox(height: 8),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 100,
                    activeColor: Colors.blueAccent,
                    inactiveColor: Colors.grey.shade300,
                    labels: RangeLabels(
                      _priceRange.start.round().toString(),
                      _priceRange.end.round().toString(),
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _filterProducts,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "APPLY",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    final bool isLocalFile = product.imageUrl.startsWith('/');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: isLocalFile
                ? Image.file(
                    File(product.imageUrl),
                    height: 360,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    product.imageUrl,
                    height: 360,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(product.description,
                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        SizedBox(width: 4),
                        Text("(4.0)", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
