import 'package:ecommerce_app/core/network/http.dart'; // your custom HttpClient
import 'package:ecommerce_app/core/network/network_info.dart';

import 'package:ecommerce_app/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:ecommerce_app/features/auth/data/datasources/local/auth_local_data_source_impl.dart';
import 'package:ecommerce_app/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:ecommerce_app/features/auth/data/datasources/remote/auth_remote_data_source_impl.dart';
import 'package:ecommerce_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';

import 'package:ecommerce_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/product/data/repositories/product_repository_impl.dart';
import 'package:ecommerce_app/features/product/domain/repositories/product_repository.dart';
import 'package:ecommerce_app/features/product/domain/usecases/create_product_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/update_product_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/view_all_products_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/view_specific_product_usecase.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc_bloc.dart';

import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //! External - register once
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton(() => http.Client());

  //! Custom HttpClient depends on http.Client and multipartRequestFactory
  sl.registerLazySingleton(() => HttpClient(
        multipartRequestFactory: multipartRequestFactory,
        client: sl<http.Client>(),
      ));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // ---------------------------
  // Product Feature Registration
  // ---------------------------

  // Bloc
  sl.registerFactory(() => ProductBlocBloc(
        sl(), // createProductUseCase
        sl(), // deleteProductUseCase
        sl(), // updateProductUseCase
        sl(), // viewAllProductsUseCase
        sl(), // viewSpecificProductUseCase
      ));

  // Use Cases
  sl.registerLazySingleton(() => CreateProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => ViewAllProductsUseCase(sl()));
  sl.registerLazySingleton(() => ViewSpecificProductUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      sl(), // remote
      sl(), // local
      sl(), // networkInfo
    ),
  );

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(sl()),
  );

  // ------------------------
  // Auth Feature Registration
  // ------------------------

  // Bloc
  sl.registerFactory(() => AuthBloc(
        login: sl(),
        logout: sl(),
        signup: sl(),
        getCurrentUser: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => SignupUsecase(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remote: sl(),
      local: sl(),
      networkInfo: sl(),
      client: sl(), // your custom HttpClient here
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
}
