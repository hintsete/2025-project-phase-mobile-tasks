
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_6/models/product.dart';

class AddUpdatePage extends StatefulWidget {
  const AddUpdatePage({super.key});

  @override
  State<AddUpdatePage> createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  File? _imageFile;
  String? _existingImageUrl;

  bool _isEdit = false;
  late Product _editingProduct;
  late Function(Product) _onSave;
  Function(Product)? _onDelete;

  final ImagePicker _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      final product = args['product'] as Product?;
      _onSave = args['onSave'] as Function(Product);
      _onDelete = args['onDelete'] as Function(Product)?;

      if (product != null) {
        _isEdit = true;
        _editingProduct = product;
        _titleController.text = product.title;
        _descriptionController.text = product.description;
        _priceController.text = product.price.toString();
        _existingImageUrl = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
        _existingImageUrl = null;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        id: _isEdit ? _editingProduct.id : DateTime.now().toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        imageUrl: _imageFile?.path ?? _existingImageUrl ?? 'images/Saint-Laurent.jpg',
      );

      _onSave(newProduct);
      Navigator.pop(context);
    }
  }

  void _deleteProduct() {
    if (_onDelete != null) {
      if (_isEdit) {
        _onDelete!(_editingProduct);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No product to delete')),
        );
      }
    }
  }

  Widget _imagePreview() {
    if (_imageFile != null) {
      return Image.file(_imageFile!, height: 180, width: double.infinity, fit: BoxFit.cover);
    } else if (_existingImageUrl != null) {
      return Image.asset(_existingImageUrl!, height: 180, width: double.infinity, fit: BoxFit.cover);
    } else {
      return Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.image_outlined, size: 52, color: Colors.black54),
            SizedBox(height: 8),
            Text("Upload Image", style: TextStyle(color: Colors.black54, fontFamily: "Poppins")),
          ],
        ),
      );
    }
  }

  Widget _customTextField({
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    Widget? suffix,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        suffix: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEdit ? 'Update Product' : 'Add Product',
          style: const TextStyle(fontFamily: "Poppins"),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blueAccent),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: _imagePreview(),
                  ),
                ),
                const SizedBox(height: 18),

                const Text("Name", style: TextStyle(fontFamily: "Poppins")),
                const SizedBox(height: 8),
                _customTextField(
                  controller: _titleController,
                  hint: 'Product Title',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Title is required' : null,
                ),

                const SizedBox(height: 18),

                const Text("Price", style: TextStyle(fontFamily: "Poppins")),
                const SizedBox(height: 8),
                _customTextField(
                  controller: _priceController,
                  hint: 'Price',
                  suffix: const Text("\$", style: TextStyle(color: Colors.grey)),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final parsed = double.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) return 'Enter a valid price';
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                const Text("Description", style: TextStyle(fontFamily: "Poppins")),
                const SizedBox(height: 8),
                _customTextField(
                  controller: _descriptionController,
                  hint: 'Description',
                  maxLines: 3,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Description is required' : null,
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      _isEdit ? 'UPDATE' : 'ADD',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Poppins"),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _deleteProduct,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'DELETE',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.redAccent, fontFamily: "Poppins"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
