import 'package:ecommerce_app/features/product/domain/entities/product.dart';

class ProductModel extends Product{
    ProductModel({
        
    required super.id, 
    required super.name, 
    required super.description, 
    required super.imageURL, 
    required super.price});

    factory ProductModel.fromJson(Map<String,dynamic> json){
        return ProductModel(
            id: json['id'], 
            name: json['name'], 
            description: json['description'], 
            imageURL: json['imageURL'], 
            price: (json['price']as num).toDouble()
        );
    }
    Map<String, dynamic> toJson(){
        return{
            'id':id,
            'name':name,
            'description':description,
            'imageURL':imageURL,
            'price':price
        };
    }
    
  
}
