import "product.dart";
import "product_manager.dart";
import "dart:io";

void main(){
  final manager=ProductManager();

  while(true){
    print("eCommerce CLI");
    print("1. Add Product");
    print("2. View All Product");
    print("3. View Product Details");
    print("4. Edit Product");
    print("5. Delete Product");
    print("6. Exit");
    final input=stdin.readLineSync();
    switch(input){
      case "1":_addProduct(manager); break;
      case "2":_viewAllProducts(manager);break;
      case "3": _viewProductDetails(manager);break;
      case "4":_editProduct(manager);break;
      case "5":_deleteProduct(manager);break;
      case "6": exit(0);
      default:print("Invalid option! PLease select again");
      
    }
  }
 

}
void _addProduct(ProductManager manager){
  stdout.write("Enter product name: ");
  final name=stdin.readLineSync()?.trim() ?? "";
  stdout.write("Enter product description: ");
  final description=stdin.readLineSync()?.trim() ?? "";
  double price=0;
  while(price<=0){
    stdout.write("Enter product price must be greater than 0: ");
    final priceValue=stdin.readLineSync()?.trim() ??"";
    price=double.tryParse(priceValue)??0;

  }
  final product=Product(
    name: name.isEmpty ? "Unnamed Product" : name,
    description:description.isEmpty? "No description" : description,
    price: price
  );
  manager.addProduct(product);
  print("Product added successfully!");
}
void _viewAllProducts(ProductManager manager){
  final products = manager.getAllProducts();
  if (products.isEmpty) {
    print('\nNo products available.');
    return;
  }
  
  
  for (var i = 0; i < products.length; i++) {
    print('${i + 1}. ${products[i].name} (${products[i].price.toStringAsFixed(2)})');
  }
}

void _viewProductDetails(ProductManager manager){
  final products = manager.getAllProducts();
  if (products.isEmpty) {
    print('\nNo products available to view.');
    return;
  }
  
  _viewAllProducts(manager);
  
  stdout.write('\nEnter product number to view: ');
  final input = stdin.readLineSync()?.trim() ?? '';
  final index = int.tryParse(input) ?? 0;
  
  final product = manager.getProduct(index - 1);
  if (product == null) {
    print('Invalid product number!');
    return;
  }
  
  print(product);
}
void _editProduct(ProductManager manager){
  final products = manager.getAllProducts();
  if (products.isEmpty) {
    print('\nNo products available to edit.');
    return;
  }
  
  _viewAllProducts(manager);
  
  stdout.write('\nEnter product number to edit: ');
  final input = stdin.readLineSync()?.trim() ?? '';
  final index = int.tryParse(input) ?? 0;
  
  final existingProduct = manager.getProduct(index - 1);
  if (existingProduct == null) {
    print('Invalid product number!');
    return;
  }
  
  print('\nCurrent details:');
  print(existingProduct);
  
  print('\nEnter new details (leave blank to keep current value):');
  
  stdout.write('Name [${existingProduct.name}]: ');
  final name = stdin.readLineSync()?.trim();
  
  stdout.write('Description [${existingProduct.description}]: ');
  final description = stdin.readLineSync()?.trim();
  
  double? price;
  while (price == null) {
    stdout.write('Price [${existingProduct.price.toStringAsFixed(2)}]: ');
    final priceInput = stdin.readLineSync()?.trim();
    if (priceInput?.isEmpty ?? true) {
      price = existingProduct.price;
    } else {
      price = double.tryParse(priceInput!);
      if (price == null || price <= 0) {
        print('Please enter a valid positive number');
        price = null;
      }
    }
  }
  
  final updatedProduct = Product(
    name: name?.isEmpty ?? true ? existingProduct.name : name!,
    description: description?.isEmpty ?? true ? existingProduct.description : description!,
    price: price,
  );
  
  if (manager.editProduct(index - 1, updatedProduct)) {
    print('\nProduct updated successfully!');
  } else {
    print('\nFailed to update product.');
  }
}
void _deleteProduct(ProductManager manager){
  final products = manager.getAllProducts();
  if (products.isEmpty) {
    print('\nNo products available to delete.');
    return;
  }
  
  _viewAllProducts(manager);
  
  stdout.write('\nEnter product number to delete: ');
  final input = stdin.readLineSync()?.trim() ?? '';
  final index = int.tryParse(input) ?? 0;
  
  stdout.write('Are you sure you want to delete product $index? (y/n): ');
  final confirm = stdin.readLineSync()?.trim().toLowerCase();
  
  if (confirm == 'y') {
    if (manager.deleteProduct(index - 1)) {
      print('\nProduct deleted successfully!');
    } else {
      print('\nInvalid product number!');
    }
  } else {
    print('\nDeletion cancelled.');
  }
}
