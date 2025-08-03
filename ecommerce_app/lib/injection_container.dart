import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Import your usecases, repositories, datasources, network info, bloc
import 'features/product/domain/usecases/create_product_usecase.dart';
import 'features/product/domain/usecases/delete_product_usecase.dart';
import 'features/product/domain/usecases/update_product_usecase.dart';
import 'features/product/domain/usecases/view_all_products_usecase.dart';
import 'features/product/domain/usecases/view_specific_product_usecase.dart';

import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';

import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/datasources/product_local_data_source.dart';

import 'core/network/network_info.dart';

import 'features/product/presentation/bloc/product_bloc_bloc.dart';


final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Product

  // Bloc
  sl.registerFactory(() => ProductBlocBloc(
        sl(), // createProductUseCase
        sl(), // deleteProductUseCase
        sl(), // updateProductUseCase
        sl(), // viewAllProductsUseCase
        sl(), // viewSpecificProductUseCase
      ));

  // Use cases
  sl.registerLazySingleton(() => CreateProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => ViewAllProductsUseCase(sl()));
  sl.registerLazySingleton(() => ViewSpecificProductUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
  () => ProductRepositoryImpl(
    sl(), // remoteDataSource
    sl(), // localDataSource
    sl(), // networkInfo
  ),
);


  // Data sources
 sl.registerLazySingleton<ProductRemoteDataSource>(
  () => ProductRemoteDataSourceImpl(sl()),
);

sl.registerLazySingleton<ProductLocalDataSource>(
  () => ProductLocalDataSourceImpl(sl()),
);


  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
}
