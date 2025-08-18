import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failure.dart';
import 'package:ecommerce_app/core/network/http.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/create_product_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/update_product_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/view_all_products_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecases/view_specific_product_usecase.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_bloc_test.mocks.dart';

@GenerateMocks([
  CreateProductUseCase,
  DeleteProductUseCase,
  UpdateProductUseCase,
  ViewAllProductsUseCase,
  ViewSpecificProductUseCase,
  HttpClient,
])
void main() {
  late ProductBlocBloc bloc;
  late MockCreateProductUseCase mockCreate;
  late MockDeleteProductUseCase mockDelete;
  late MockUpdateProductUseCase mockUpdate;
  late MockViewAllProductsUseCase mockFetchAll;
  late MockViewSpecificProductUseCase mockFetchSingle;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockCreate = MockCreateProductUseCase();
    mockDelete = MockDeleteProductUseCase();
    mockUpdate = MockUpdateProductUseCase();
    mockFetchAll = MockViewAllProductsUseCase();
    mockFetchSingle = MockViewSpecificProductUseCase();
    mockHttpClient = MockHttpClient();

    bloc = ProductBlocBloc(
      mockCreate,
      mockDelete,
      mockUpdate,
      mockFetchAll,
      mockFetchSingle,
      mockHttpClient,
    );
  });

  final tProduct = Product(
    id: '1',
    name: "Test Product",
    description: "Test Description",
    imageURL: "http://image.url",
    price: 9.99,
  );

  final tFailure = ServerFailure('Something went wrong');

  group('LoadAllProductsEvent', () {
    blocTest<ProductBlocBloc, ProductBlocState>(
      'emits [LoadingState, LoadedAllProductsState] when fetching succeeds',
      build: () {
        when(mockFetchAll.call(any)).thenAnswer((_) async => Right([tProduct]));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAllProductsEvent()),
      expect: () => [
        const LoadingState(),
        LoadedAllProductsState([tProduct]),
      ],
    );

    blocTest<ProductBlocBloc, ProductBlocState>(
      'emits [LoadingState, ErrorState] when fetching fails',
      build: () {
        when(mockFetchAll.call(any)).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAllProductsEvent()),
      expect: () => [
        const LoadingState(),
        ErrorState(message: tFailure.message),
      ],
    );
  });

  group('GetSingleProductEvent', () {
    blocTest<ProductBlocBloc, ProductBlocState>(
      'emits [LoadingState, LoadedSingleProductState] on success',
      build: () {
        when(mockFetchSingle.call(any)).thenAnswer((_) async => Right(tProduct));
        return bloc;
      },
      act: (bloc) => bloc.add(GetSingleProductEvent('1')),
      expect: () => [
        const LoadingState(),
        LoadedSingleProductState(tProduct),
      ],
    );

    blocTest<ProductBlocBloc, ProductBlocState>(
      'emits [LoadingState, ErrorState] on failure',
      build: () {
        when(mockFetchSingle.call(any)).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(GetSingleProductEvent('1')),
      expect: () => [
        const LoadingState(),
        ErrorState(message: tFailure.message),
      ],
    );
  });

  group('CreateProductEvent', () {
    blocTest<ProductBlocBloc, ProductBlocState>(
      'emits success flow when CreateProductEvent succeeds',
      build: () {
        when(mockCreate.call(any)).thenAnswer((_) async => const Right(null));
        when(mockFetchAll.call(any)).thenAnswer((_) async => Right([tProduct]));
        return ProductBlocBloc(
          mockCreate,
          mockDelete,
          mockUpdate,
          mockFetchAll,
          mockFetchSingle,
          mockHttpClient,
        );
      },
      act: (bloc) => bloc.add(CreateProductEvent(tProduct)),
      wait: const Duration(milliseconds: 50),
      expect: () => [
        const LoadingState(),
        const SuccessState(message: 'Product created successfully'),
        const LoadingState(),
        LoadedAllProductsState([tProduct]),
      ],
    );

    blocTest<ProductBlocBloc, ProductBlocState>(
      'emits [LoadingState, ErrorState] on failure',
      build: () {
        when(mockCreate.call(any)).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(CreateProductEvent(tProduct)),
      expect: () => [
        const LoadingState(),
        ErrorState(message: tFailure.message),
      ],
    );
  });

  group('UpdateProductEvent', () {
    blocTest<ProductBlocBloc, ProductBlocState>(
      'emits success flow when UpdateProductEvent succeeds',
      build: () {
        when(mockUpdate.call(any)).thenAnswer((_) async => const Right(null));
        when(mockFetchAll.call(any)).thenAnswer((_) async => Right([tProduct]));
        return ProductBlocBloc(
          mockCreate,
          mockDelete,
          mockUpdate,
          mockFetchAll,
          mockFetchSingle,
          mockHttpClient,
        );
      },
      act: (bloc) => bloc.add(UpdateProductEvent(tProduct)),
      wait: const Duration(milliseconds: 50),
      expect: () => [
        const LoadingState(),
        const SuccessState(message: 'Product updated successfully'),
        const LoadingState(),
        LoadedAllProductsState([tProduct]),
      ],
    );

    blocTest<ProductBlocBloc, ProductBlocState>(
      'emits [LoadingState, ErrorState] on failure',
      build: () {
        when(mockUpdate.call(any)).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateProductEvent(tProduct)),
      expect: () => [
        const LoadingState(),
        ErrorState(message: tFailure.message),
      ],
    );
  });

  group('DeleteProductEvent', () {
    blocTest<ProductBlocBloc, ProductBlocState>(
      'emits success flow when DeleteProductEvent succeeds',
      build: () {
        when(mockDelete.call(any)).thenAnswer((_) async => const Right(null));
        when(mockFetchAll.call(any)).thenAnswer((_) async => Right([tProduct]));
        return ProductBlocBloc(
          mockCreate,
          mockDelete,
          mockUpdate,
          mockFetchAll,
          mockFetchSingle,
          mockHttpClient,
        );
      },
      act: (bloc) => bloc.add(DeleteProductEvent('1')),
      wait: const Duration(milliseconds: 50),
      expect: () => [
        const LoadingState(),
        const SuccessState(message: 'Product deleted successfully'),
        const LoadingState(),
        LoadedAllProductsState([tProduct]),
      ],
    );

    blocTest<ProductBlocBloc, ProductBlocState>(
      'emits [LoadingState, ErrorState] on failure',
      build: () {
        when(mockDelete.call(any)).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(DeleteProductEvent('1')),
      expect: () => [
        const LoadingState(),
        ErrorState(message: tFailure.message),
      ],
    );
  });
}
