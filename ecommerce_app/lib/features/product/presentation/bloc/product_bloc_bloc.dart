import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/core/constants/api_constants.dart';
import 'package:ecommerce_app/core/network/http.dart';
import 'package:ecommerce_app/core/usecase.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/create_product_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/update_product_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/view_all_products_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/view_specific_product_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'dart:io';

part 'product_bloc_event.dart';
part 'product_bloc_state.dart';

class ProductBlocBloc extends Bloc<ProductBlocEvent, ProductBlocState> {
  final CreateProductUseCase createProduct;
  final DeleteProductUseCase deleteProduct;
  final UpdateProductUseCase updateProduct;
  final ViewAllProductsUseCase fetchAllProduct;
  final ViewSpecificProductUseCase fetchSingleProduct;
  final HttpClient httpClient;

  ProductBlocBloc(
    this.createProduct,
    this.deleteProduct,
    this.updateProduct,
    this.fetchAllProduct,
    this.fetchSingleProduct,
    this.httpClient,
  ) : super(const ProductBlocInitial()) {
    on<LoadAllProductsEvent>(_onLoadAllProducts);
    on<GetSingleProductEvent>(_onGetSingleProduct);
    on<CreateProductEvent>(_onCreateProduct);
    on<CreateProductWithImageEvent>(_onCreateProductWithImage);
    on<DeleteProductEvent>(_onDeleteProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    // on<UpdateProductWithImageEvent>(_onUpdateProductWithImage);
  }

  Future<void> _onLoadAllProducts(
    LoadAllProductsEvent event,
    Emitter<ProductBlocState> emit,
  ) async {
    emit(const LoadingState());
    final result = await fetchAllProduct(NoParams());
    result.fold(
      (failure) => emit(ErrorState(message: failure.message)),
      (products) => emit(LoadedAllProductsState(products)),
    );
  }

  Future<void> _onGetSingleProduct(
    GetSingleProductEvent event,
    Emitter<ProductBlocState> emit,
  ) async {
    emit(const LoadingState());
    final result = await fetchSingleProduct(event.id);
    result.fold(
      (failure) => emit(ErrorState(message: failure.message)),
      (product) => emit(LoadedSingleProductState(product)),
    );
  }

  Future<void> _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductBlocState> emit,
  ) async {
    emit(const LoadingState());
    final result = await createProduct(event.product);
    result.fold(
      (failure) => emit(ErrorState(message: failure.message)),
      (_) {
        emit(const SuccessState(message: 'Product created successfully'));
        add(LoadAllProductsEvent());
      },
    );
  }

  Future<void> _onCreateProductWithImage(
    CreateProductWithImageEvent event,
    Emitter<ProductBlocState> emit,
  ) async {
    emit(const LoadingState());

    try {
      final response = await httpClient.uploadFile(
        productUrl,
        HttpMethod.post,
        {
          'name': event.name,
          'description': event.description,
          'price': event.price.toString(),
        },
        [UploadFile(key: 'image', path: event.imageFile!.path)],
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        emit(const SuccessState(message: 'Product created successfully'));
        add(LoadAllProductsEvent());
      } else {
        final error = jsonDecode(response.body);
        emit(ErrorState(message: error['message'] ?? 'Failed to create product'));
      }
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
  DeleteProductEvent event,
  Emitter<ProductBlocState> emit,
) async {
  emit(const LoadingState());
  final result = await deleteProduct(event.id); // event.id should be String now
  result.fold(
    (failure) => emit(ErrorState(message: failure.message)),
    (_) {
      emit(const SuccessState(message: 'Product deleted successfully'));
      add(LoadAllProductsEvent());
    },
  );
}

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductBlocState> emit,
  ) async {
    emit(const LoadingState());
    final result = await updateProduct(event.product);
    result.fold(
      (failure) => emit(ErrorState(message: failure.message)),
      (_) {
        emit(const SuccessState(message: 'Product updated successfully'));
        add(LoadAllProductsEvent());
      },
    );
  }
//   Future<void> _onUpdateProductWithImage(
//   UpdateProductWithImageEvent event,
//   Emitter<ProductBlocState> emit,
// ) async {
//   emit(const LoadingState());

//   try {
//     final response = await httpClient.uploadFile(
//       '$productUrl/${event.product.id}',
//       HttpMethod.put,
//       {
//         'name': event.product.name,
//         'description': event.product.description,
//         'price': event.product.price.toString(),
//       },
//       [UploadFile(key: 'image', path: event.imageFile.path)],
//     );

//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       emit(const SuccessState(message: 'Product updated successfully'));
//       add(LoadAllProductsEvent());
//     } else {
//       final error = jsonDecode(response.body);
//       emit(ErrorState(message: error['message'] ?? 'Failed to update product'));
//     }
//   } catch (e) {
//     emit(ErrorState(message: e.toString()));
//   }
// }
}
