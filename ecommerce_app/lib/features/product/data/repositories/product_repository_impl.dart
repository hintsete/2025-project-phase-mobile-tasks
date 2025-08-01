import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/core/platform/network_info.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl extends ProductRepository{
  final ProductRemoteDataSource remoteDatasource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  ProductRepositoryImpl(this.remoteDatasource,this.localDataSource,this.networkInfo);


  @override
  Future<Either<Failure, void>> createProduct(Product product) async{
   
    return const Right(null);
  }
  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
  
    return const Right(null);
  }
  @override
  Future<Either<Failure, void>> deleteProduct(int id) async{
   
    return const Right(null);
  }
  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async{
   
    return const Right([]);
  }
  @override
  Future<Either<Failure, Product>> getProductById(int id) async{
  
    return Right(Product(id: id, name: 'name', description: 'description', imageURL: 'imageURL', price: 10));
  }
}