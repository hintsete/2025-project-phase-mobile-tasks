

import 'dart:convert';

import 'package:ecommerce_app/core/constants/api_constants.dart';
import 'package:ecommerce_app/core/error/exception.dart';
import 'package:ecommerce_app/core/network/http.dart';
import 'package:ecommerce_app/features/product/data/models/Product_model.dart';
// import 'package:ecommerce_app/features/product/domain/entities/product.dart';
// import 'package:http/http.dart' as http;


abstract class ProductRemoteDataSource {
 
  Future< void> createProduct(ProductModel product) ;
   
   
  
  
  Future< void> updateProduct(ProductModel product) ; 
  
    // return const Right(null);
  

  Future< void> deleteProduct(String id);
  
  Future< List<ProductModel>> getAllProducts() ;
   
    // return const Right([]);
  
  
  Future< ProductModel> getProductById(String id) ;
  
    // return Right(Product(id: id, name: 'name', description: 'description', imageURL: 'imageURL', price: 10));
  

}
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final HttpClient client;

  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<void> createProduct(ProductModel product) async {
    try {
      print('Creating product: ${product.name}');
      
      final response = await client.uploadFile(
        productUrl,
        HttpMethod.post,
        {
          'name': product.name,
          'description': product.description,
          'price': product.price.toString(),
        },
        product.imageURL.isNotEmpty
            ? [UploadFile(key: 'image', path: product.imageURL)]
            : [],
      );

      print('Create Product Response: ${response.statusCode} - ${response.body}');

      // if (response.statusCode != 201 && response.statusCode != 200) {
      //   final errorBody = jsonDecode(response.body);
      //   throw ServerException();
      // }
    } catch (e) {
      print('Error in createProduct: $e');
      throw ServerException();
    }
  }

  @override
Future<void> updateProduct(ProductModel product) async {
  try {
    print('Updating product: ${product.id}');
    
    // For products with local image path (new image selected)
    if (product.imageURL.isNotEmpty && product.imageURL.startsWith('/')) {
      final response = await client.uploadFile(
        '$productUrl/${product.id}',
        HttpMethod.put,
        {
          'name': product.name,
          'description': product.description,
          'price': product.price.toString(),
        },
        [UploadFile(key: 'image', path: product.imageURL)],
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException();
      }
    } 
    // For products with network image URL (no new image selected)
    else {
      final response = await client.put(
        '$productUrl/${product.id}',
        product.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException();
      }
    }
  } catch (e) {
    print('Error in updateProduct: $e');
    throw ServerException();
  }
}

 @override
Future<void> deleteProduct(String id) async {
  try {
    print('Deleting product: $id');
    final response = await client.delete('$productUrl/$id');
    
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ServerException();
    }
  } catch (e) {
    print('Error in deleteProduct: $e');
    throw ServerException();
  }
}


  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      print('Fetching all products from: $productUrl');
      final response = await client.get(productUrl);
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> jsonList = jsonResponse['data'];
        return jsonList.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      print('Error in getAllProducts: $e');
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      print('Fetching product by id: $id');
      final response = await client.get('$productUrl/$id');
      
      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        return ProductModel.fromJson(jsonMap['data']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      print('Error in getProductById: $e');
      throw ServerException();
    }
  }
}