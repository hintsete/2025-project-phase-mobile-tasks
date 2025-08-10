part of 'product_bloc_bloc.dart';

@immutable
sealed class ProductBlocEvent {}

class LoadAllProductsEvent extends ProductBlocEvent {}

class GetSingleProductEvent extends ProductBlocEvent {
  final String id;
  GetSingleProductEvent(this.id);
}

class UpdateProductEvent extends ProductBlocEvent {
  final Product product;
  UpdateProductEvent(this.product);
}

class DeleteProductEvent extends ProductBlocEvent {
  final String id;
  DeleteProductEvent(this.id);
}

class CreateProductEvent extends ProductBlocEvent {
  final Product product;
  CreateProductEvent(this.product);
}

/// NEW: File upload event
class CreateProductWithImageEvent extends ProductBlocEvent {
  final String name;
  final String description;
  final double price;
  final File? imageFile;

  CreateProductWithImageEvent({
    required this.name,
    required this.description,
    required this.price,
    this.imageFile,
  });
}

// class UpdateProductWithImageEvent extends ProductBlocEvent {
//   final Product product;
//   final File imageFile;

//   UpdateProductWithImageEvent({
//     required this.product,
//     required this.imageFile,
//   });
// }