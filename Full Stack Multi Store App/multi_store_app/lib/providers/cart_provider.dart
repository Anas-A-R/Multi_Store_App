import 'package:flutter/foundation.dart';
import 'package:multi_store_app/providers/product_class.dart';

class Cart extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getItems => _list;
  int get count => _list.length;
  void addItem(
    String name,
    double price,
    int quantity,
    int inStock,
    List imagesUrl,
    String documentId,
    String supplierId,
  ) {
    final product = Product(
        name: name,
        price: price,
        quantity: quantity,
        inStock: inStock,
        imagesUrl: imagesUrl,
        documentId: documentId,
        supplierId: supplierId);
    _list.add(product);
    notifyListeners();
  }

  void increment(Product product) {
    product.increase();
    notifyListeners();
  }

  void decrement(Product product) {
    product.deccrease();
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _list.clear();
    notifyListeners();
  }

  double get totalPrice {
    double total = 0;
    for (var element in _list) {
      total += element.price * element.quantity;
    }
    notifyListeners();
    return total;
  }
}
