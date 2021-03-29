class Product {
  String productName;
  int quantity;
  double price;

  Product({this.productName, this.quantity, this.price});
  factory Product.fromJson(dynamic jsonObject) {
    return Product(
      productName: jsonObject['productName'],
      quantity: jsonObject['quantity'],
      price: jsonObject['price']
    );
  }

  @override
  String toString() {
    return 'Product{productName: $productName, quantity: $quantity, price: $price}';
  }
}