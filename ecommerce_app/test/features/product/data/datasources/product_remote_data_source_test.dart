import 'dart:convert';

import 'package:ecommerce_app/core/constants/api_constants.dart';
import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/core/network/http.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/product/data/models/Product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_remote_data_source_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late MockHttpClient mockHttpClient;
  late ProductRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = ProductRemoteDataSourceImpl(mockHttpClient);
  });

  const tProductModel = ProductModel(
    id: '1',
    name: 'Test',
    description: 'desc',
    imageURL: 'img.png',
    price: 99.99,
  );
  final tProductJson = tProductModel.toJson();

  // Create a product with image path for upload tests
  final tProductModelWithImage = ProductModel(
    id: '1',
    name: 'Test',
    description: 'desc',
    imageURL: '/path/to/image.jpg', // Local path for upload
    price: 99.99,
  );

  group('getAllProducts', () {
    test('should return List<Product> when response code is 200', () async {
      when(mockHttpClient.get(productUrl))
          .thenAnswer((_) async => HttpResponse(
                statusCode: 200,
                body: json.encode({'data': [tProductJson]}),
              ));

      final result = await dataSource.getAllProducts();

      expect(result, isA<List<ProductModel>>());
      expect(result.first, equals(tProductModel));
      verify(mockHttpClient.get(productUrl));
    });

    test('should throw ServerException on non-200 response', () async {
      when(mockHttpClient.get(productUrl))
          .thenAnswer((_) async => HttpResponse(
                statusCode: 404,
                body: 'Not found',
              ));

      expect(() => dataSource.getAllProducts(), throwsA(isA<ServerException>()));
    });
  });

  group('getProductById', () {
    test('should return ProductModel when response code is 200', () async {
      when(mockHttpClient.get('$productUrl/1'))
          .thenAnswer((_) async => HttpResponse(
                statusCode: 200,
                body: json.encode({'data': tProductJson}),
              ));

      final result = await dataSource.getProductById('1');

      expect(result, equals(tProductModel));
      verify(mockHttpClient.get('$productUrl/1'));
    });

    test('should throw ServerException on non-200 response', () async {
      when(mockHttpClient.get('$productUrl/1'))
          .thenAnswer((_) async => HttpResponse(
                statusCode: 404,
                body: 'Not found',
              ));

      expect(() => dataSource.getProductById('1'), throwsA(isA<ServerException>()));
    });
  });

  group('createProduct', () {
    test('should complete successfully on 201 response (without image)', () async {
      when(mockHttpClient.post(
        productUrl,
        any,
      )).thenAnswer((_) async => HttpResponse(
            statusCode: 201,
            body: '',
          ));

      await dataSource.createProduct(tProductModel);

      verify(mockHttpClient.post(
        productUrl,
        tProductModel.toJson(),
      ));
    });

    test('should complete successfully on 200 response (with image)', () async {
      when(mockHttpClient.uploadFile(
        productUrl,
        HttpMethod.post,
        any,
        any,
      )).thenAnswer((_) async => HttpResponse(statusCode: 200, body: ''));

      await dataSource.createProduct(tProductModelWithImage);

      verify(mockHttpClient.uploadFile(
        productUrl,
        HttpMethod.post,
        {
          'name': tProductModelWithImage.name,
          'description': tProductModelWithImage.description,
          'price': tProductModelWithImage.price.toString(),
        },
        [UploadFile(key: 'image', path: tProductModelWithImage.imageURL)],
      ));
    });

    test('should throw ServerException on failure', () async {
      when(mockHttpClient.post(
        productUrl,
        any,
      )).thenAnswer((_) async => HttpResponse(
            statusCode: 400,
            body: 'Bad request',
          ));

      expect(() => dataSource.createProduct(tProductModel), throwsA(isA<ServerException>()));
    });
  });

  group('updateProduct', () {
    test('should complete successfully on 200 response (without new image)', () async {
      when(mockHttpClient.put(
        '$productUrl/1',
        any,
      )).thenAnswer((_) async => HttpResponse(
            statusCode: 200,
            body: '',
          ));

      await dataSource.updateProduct(tProductModel);

      verify(mockHttpClient.put(
        '$productUrl/1',
        tProductModel.toJson(),
      ));
    });

    test('should complete successfully on 204 response (with new image)', () async {
      when(mockHttpClient.uploadFile(
        '$productUrl/1',
        HttpMethod.put,
        any,
        any,
      )).thenAnswer((_) async => HttpResponse(statusCode: 204, body: ''));

      await dataSource.updateProduct(tProductModelWithImage);

      verify(mockHttpClient.uploadFile(
        '$productUrl/1',
        HttpMethod.put,
        {
          'name': tProductModelWithImage.name,
          'description': tProductModelWithImage.description,
          'price': tProductModelWithImage.price.toString(),
        },
        [UploadFile(key: 'image', path: tProductModelWithImage.imageURL)],
      ));
    });

    test('should throw ServerException on failure', () async {
      when(mockHttpClient.put(
        '$productUrl/1',
        any,
      )).thenAnswer((_) async => HttpResponse(
            statusCode: 500,
            body: 'Server error',
          ));

      expect(() => dataSource.updateProduct(tProductModel), throwsA(isA<ServerException>()));
    });
  });

  group('deleteProduct', () {
    test('should complete successfully on 204 response', () async {
      when(mockHttpClient.delete('$productUrl/1'))
          .thenAnswer((_) async => HttpResponse(
                statusCode: 204,
                body: '',
              ));

      await dataSource.deleteProduct('1');

      verify(mockHttpClient.delete('$productUrl/1'));
    });

    test('should throw ServerException on failure', () async {
      when(mockHttpClient.delete('$productUrl/1'))
          .thenAnswer((_) async => HttpResponse(
                statusCode: 403,
                body: 'Forbidden',
              ));

      expect(() => dataSource.deleteProduct('1'), throwsA(isA<ServerException>()));
    });
  });
}