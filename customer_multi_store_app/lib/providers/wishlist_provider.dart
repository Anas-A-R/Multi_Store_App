import 'package:customer_multi_store_app/providers/wishlist_sql_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:customer_multi_store_app/providers/product_class.dart';

class Wishlist extends ChangeNotifier {
  static List<Product> _list = [];
  List<Product> get getWishlistItems => _list;
  int get count => _list.length;
  Future<void> addIWishlistItem(
    Product product,
  ) async {
    WishlistSQLHelper.addWishItem(product)
        .whenComplete(() => _list.add(product));
    notifyListeners();
  }

  void removeWishlistItem(Product product) {
    WishlistSQLHelper.deleteWishItem(product.documentId)
        .whenComplete(() => _list.remove(product));
    notifyListeners();
  }

  void clearWishlist() {
    WishlistSQLHelper.deleteAllItems().whenComplete(() => _list.clear());
    notifyListeners();
  }

  void removeThis(String id) {
    _list.removeWhere((element) => element.documentId == id);
    notifyListeners();
  }

  void loadWishItems() async {
    List<Map> data = await WishlistSQLHelper.loadWishItems();
    _list = data.map((product) {
      return Product(
        documentId: product['documentId'],
        name: product['name'],
        price: product['price'],
        quantity: product['quantity'],
        inStock: product['inStock'],
        imagesUrl: product['imagesUrl'],
        supplierId: product['supplierId'],
      );
    }).toList();
  }
}
