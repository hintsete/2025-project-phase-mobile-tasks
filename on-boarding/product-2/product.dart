class Product{
  String name;
  String description;
  double price;

  Product({required this.name, required this.description, required this.price});

  @override
  String toString() {
    // 
    return "Name: $name | Description: $description | Price: $price Birr" ;
  }

}