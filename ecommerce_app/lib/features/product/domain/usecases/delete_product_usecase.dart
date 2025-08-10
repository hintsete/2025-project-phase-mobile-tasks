import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/usecase.dart';

import '../../../../core/error/failure.dart';
import '../repositories/product_repository.dart';
// import 'usecase.dart';

class DeleteProductUseCase extends Usecase<void,String> {
  final ProductRepository repository;
  DeleteProductUseCase(this.repository);

  @override
  Future<Either<Failure,void>> call(String id){
    return repository.deleteProduct(id);
  }
}