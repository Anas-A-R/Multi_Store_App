import 'package:flutter/foundation.dart';
import 'package:multi_store_app/providers/product_class.dart';

class Wishlist extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getWishlistItems => _list;
  int get count => _list.length;
  Future<void> addIWishlistItem(
    String name,
    double price,
    int quantity,
    int inStock,
    List imagesUrl,
    String documentId,
    String supplierId,
  ) async {
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

  void removeWishlistItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearWishlist() {
    _list.clear();
    notifyListeners();
  }

  void removeThis(String id) {
    _list.removeWhere((element) => element.documentId == id);
    notifyListeners();
  }
}
