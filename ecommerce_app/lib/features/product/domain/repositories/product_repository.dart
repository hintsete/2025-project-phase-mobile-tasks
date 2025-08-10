import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/product.dart';

abstract class ProductRepository{
  Future<Either<Failure,List<Product>>> getAllProducts();
  Future<Either<Failure,Product>> getProductById(String id);
  Future<Either<Failure,void>> createProduct(Product product);
  Future<Either<Failure,void>> updateProduct(Product product);
  Future<Either<Failure,void>> deleteProduct(String id);
}