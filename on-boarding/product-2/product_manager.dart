import "product.dart";

class ProductManager{

  final List<Product> _products=[];

  void addProduct(Product product)=>_products.add(product);
  List<Product> getAllProducts()=> List.unmodifiable(_products);
  Product? getProduct(int idx){
    return (idx>=0 && idx<_products.length)? _products[idx]:null;
  }
  bool editProduct(int idx, Product newProduct){
    if (idx<0 || idx>=_products.length) return false;
    _products[idx]=newProduct;
    return true;
  }
  bool deleteProduct(int idx){
    if (idx<0 || idx>=_products.length) return false;
    _products.removeAt(idx);
    return true;
  }

}