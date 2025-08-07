import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/usecase.dart';

import '../../../../core/error/failure.dart';
import '../repositories/product_repository.dart';
// import 'usecase.dart';

class DeleteProductUseCase extends Usecase<void,int> {
  final ProductRepository repository;
  DeleteProductUseCase(this.repository);

  @override
  Future<Either<Failure,void>> call(int id){
    return repository.deleteProduct(id);
  }
}