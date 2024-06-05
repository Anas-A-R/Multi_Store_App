import 'package:customer_multi_store_app/providers/sql_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:customer_multi_store_app/providers/product_class.dart';

class Cart extends ChangeNotifier {
  static List<Product> _list = [];
  List<Product> get getItems => _list;
  int get count => _list.length;
  void addItem(Product product) async {
    await SQLHelper.insertItem(product).whenComplete(() => _list.add(product));
    notifyListeners();
  }

  loadCartItemsProvider() async {
    List<Map> data = await SQLHelper.loadItems();
    _list = data
        .map(
          (product) => Product(
            documentId: product['documentId'],
            name: product['name'],
            price: product['price'],
            quantity: product['quantity'],
            inStock: product['inStock'],
            imagesUrl: product['imagesUrl'],
            supplierId: product['supplierId'],
          ),
        )
        .toList();
    notifyListeners();
  }

  void increment(Product product) async {
    await SQLHelper.updateItem(product, 'increment')
        .whenComplete(() => product.increase());
    notifyListeners();
  }

  void decrement(Product product) async {
    await SQLHelper.updateItem(product, 'decrement')
        .whenComplete(() => product.decrease());
    notifyListeners();
  }

  void removeItem(Product product) async {
    await SQLHelper.deleteItem(product.documentId)
        .whenComplete(() => _list.remove(product));
    _list.remove(product);
    notifyListeners();
  }

  void clearCart() async {
    await SQLHelper.deleteAllItems().whenComplete(() => _list.clear());
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
