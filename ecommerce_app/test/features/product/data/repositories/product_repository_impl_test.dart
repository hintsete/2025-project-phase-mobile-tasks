import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:ecommerce_app/features/product/data/models/Product_model.dart';
import 'package:ecommerce_app/features/product/data/repositories/product_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_repository_impl_test.mocks.dart';

@GenerateMocks([
  NetworkInfo,
  ProductLocalDataSource,
  ProductRemoteDataSource
])
void main() {
  late ProductRepositoryImpl repository;
  late MockNetworkInfo mockNetworkInfo;
  late MockProductRemoteDataSource mockRemoteDatasource;
  late MockProductLocalDataSource mockLocalDatasource;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockLocalDatasource = MockProductLocalDataSource();
    mockRemoteDatasource = MockProductRemoteDataSource();
    repository = ProductRepositoryImpl(
      mockRemoteDatasource,
      mockLocalDatasource,
      mockNetworkInfo,
    );
  });

  final tProductModel = ProductModel(
    id: 1,
    name: 'name',
    description: 'description',
    imageURL: 'imageURL',
    price: 12.9,
  );

  final tProduct = tProductModel.toEntity();
  final tProductListModel = [tProductModel];
  final tProductList = [tProduct];

  group('getAllProducts', () {
    test('should return remote data when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.getAllProducts())
          .thenAnswer((_) async => tProductListModel);

      final result = await repository.getAllProducts();

      final products = result.getOrElse(() => []);
      expect(products.length, tProductList.length);
      expect(products[0], tProductList[0]);
    });

    test('should return local data when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDatasource.getAllProducts())
          .thenAnswer((_) async => tProductListModel);

      final result = await repository.getAllProducts();

      final products = result.getOrElse(() => []);
      expect(products.length, tProductList.length);
      expect(products[0], tProductList[0]);
      verify(mockLocalDatasource.getAllProducts());
    });

    test('should return ServerFailure when remote fails', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.getAllProducts())
          .thenThrow(ServerException());

      final result = await repository.getAllProducts();

      expect(result, Left(ServerFailure("Server Exception")));
    });

    test('should return CacheFailure when local fails', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDatasource.getAllProducts())
          .thenThrow(CacheException());

      final result = await repository.getAllProducts();

      expect(result, Left(CacheFailure("Cache Exception")));
    });
  });

  group('getProductById', () {
    test('should return remote data when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.getProductById(1))
          .thenAnswer((_) async => tProductModel);

      final result = await repository.getProductById(1);

      expect(result, Right(tProduct));
    });

    test('should return local data when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDatasource.getProductById(1))
          .thenAnswer((_) async => tProductModel);

      final result = await repository.getProductById(1);

      expect(result, Right(tProduct));
      verify(mockLocalDatasource.getProductById(1));
    });

    test('should return ServerFailure when remote fails', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.getProductById(1))
          .thenThrow(ServerException());

      final result = await repository.getProductById(1);

      expect(result, Left(ServerFailure("Server Exception")));
    });

    test('should return CacheFailure when local fails', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDatasource.getProductById(1))
          .thenThrow(CacheException());

      final result = await repository.getProductById(1);

      expect(result, Left(CacheFailure("Cache Exception")));
    });
  });

  group('createProduct', () {
    test('should call remote when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.createProduct(any))
          .thenAnswer((_) async => null);

      final result = await repository.createProduct(tProduct);

      expect(result, Right(null));
      verify(mockRemoteDatasource.createProduct(any));
    });

    test('should return NetworkFailure when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.createProduct(tProduct);

      expect(result, Left(NetworkFailure("No internet connection")));
    });

    test('should return ServerFailure when remote fails', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.createProduct(any))
          .thenThrow(ServerException());

      final result = await repository.createProduct(tProduct);

      expect(result, Left(ServerFailure("Server Exception")));
    });
  });

  group('updateProduct', () {
    test('should call remote when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.updateProduct(any))
          .thenAnswer((_) async => null);

      final result = await repository.updateProduct(tProduct);

      expect(result, Right(null));
      verify(mockRemoteDatasource.updateProduct(any));
    });

    test('should return NetworkFailure when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.updateProduct(tProduct);

      expect(result, Left(NetworkFailure("No internet connection")));
    });

    test('should return ServerFailure when remote fails', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.updateProduct(any))
          .thenThrow(ServerException());

      final result = await repository.updateProduct(tProduct);

      expect(result, Left(ServerFailure("Server Exception")));
    });
  });

  group('deleteProduct', () {
    test('should call remote when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.deleteProduct(1))
          .thenAnswer((_) async => null);

      final result = await repository.deleteProduct(1);

      expect(result, Right(null));
      verify(mockRemoteDatasource.deleteProduct(1));
    });

    test('should return NetworkFailure when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.deleteProduct(1);

      expect(result, Left(NetworkFailure("No internet connection")));
    });

    test('should return ServerFailure when remote fails', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.deleteProduct(1))
          .thenThrow(ServerException());

      final result = await repository.deleteProduct(1);

      expect(result, Left(ServerFailure("Server Exception")));
    });
  });
}
