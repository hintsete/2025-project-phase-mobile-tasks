import 'package:ecommerce_app/core/platform/network_info.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:ecommerce_app/features/product/data/repositories/product_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';


import 'product_repository_impl_test.mocks.dart';


@GenerateMocks([
  NetworkInfo,
  ProductLocalDataSource,
  ProductRemoteDataSource
])

void main(){
  late ProductRepositoryImpl repository;
  late MockNetworkInfo mockNetworkInfo;
  late MockProductRemoteDataSource mockRemoteDatasource;
  late MockProductLocalDataSource mockLocalDatasource;



  setUp((){
    mockNetworkInfo=MockNetworkInfo();
    mockLocalDatasource= MockProductLocalDataSource();
    mockRemoteDatasource=MockProductRemoteDataSource();
    repository = ProductRepositoryImpl(
      mockRemoteDatasource,
      mockLocalDatasource,
      mockNetworkInfo,
);


  });
  // test('', (){});


}