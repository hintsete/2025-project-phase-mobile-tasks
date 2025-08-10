import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc_bloc.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';

class AddUpdateProductPage extends StatefulWidget {
  final Product? product;

  const AddUpdateProductPage({super.key, this.product});

  @override
  State<AddUpdateProductPage> createState() => _AddUpdateProductPageState();
}

class _AddUpdateProductPageState extends State<AddUpdateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

 void _submitForm() {
  if (_formKey.currentState!.validate()) {
    // Validate that an image is selected for new products
    if (widget.product == null && _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image for the product')),
      );
      return;
    }

    // For existing products being updated, use existing image if no new one selected
    final imageToUse = _imageFile?.path ?? widget.product?.imageURL ?? '';

    final product = Product(
      id: widget.product?.id ?? '',
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      imageURL: imageToUse,
    );

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Processing...'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (widget.product == null) {
      // Use the new event for image upload
      if (_imageFile != null) {
        context.read<ProductBlocBloc>().add(
          CreateProductWithImageEvent(
            name: _nameController.text,
            description: _descriptionController.text,
            price: double.parse(_priceController.text),
            imageFile: _imageFile!,
          ),
        );
      } else {
        context.read<ProductBlocBloc>().add(CreateProductEvent(product));
      }
    } else {
      context.read<ProductBlocBloc>().add(UpdateProductEvent(product));
    }
  }
}

  Widget _buildImagePreview() {
    if (_imageFile != null) {
      return Image.file(_imageFile!, height: 200, width: double.infinity, fit: BoxFit.cover);
    } else if (widget.product?.imageURL != null) {
      return Image.network(
        widget.product!.imageURL,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image, size: 50, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            'Tap to add image',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
    ),
    body: BlocListener<ProductBlocBloc, ProductBlocState>(
      listener: (context, state) {
        if (state is ErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is SuccessState) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.of(context).pop(); // Navigate back to home page
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildImagePreview(),
                ),
              ),
              const SizedBox(height: 24),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price Field
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _submitForm,
                  child: Text(
                    widget.product == null ? 'Add Product' : 'Update Product',
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