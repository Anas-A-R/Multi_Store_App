// ignore_for_file: public_member_api_docs, sort_constructors_first

class Product {
  String name;
  double price;
  int quantity = 1;
  int inStock;
  String imagesUrl;
  String documentId;
  String supplierId;
  Product({
    required this.name,
    required this.price,
    required this.quantity,
    required this.inStock,
    required this.imagesUrl,
    required this.documentId,
    required this.supplierId,
  });
  void increase() {
    quantity++;
  }

  void decrease() {
    quantity--;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'price': price,
      'quantity': quantity,
      'inStock': inStock,
      'imagesUrl': imagesUrl,
      'documentId': documentId,
      'supplierId': supplierId,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
      inStock: map['inStock'] as int,
      imagesUrl: map['imagesUrl'] as String,
      documentId: map['documentId'] as String,
      supplierId: map['supplierId'] as String,
    );
  }
}
