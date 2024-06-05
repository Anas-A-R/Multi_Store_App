import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/product_class.dart';
import 'package:multi_store_app/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class WishlistModel extends StatelessWidget {
  const WishlistModel({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: SizedBox(
          height: 120,
          child: Row(
            children: [
              Image.network(
                product.imagesUrl.first,
                height: 100,
                width: 120,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey.shade700)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(product.price.toStringAsFixed(2),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    context
                                        .read<Wishlist>()
                                        .removeWishlistItem(product);
                                  },
                                  icon: const Icon(Icons.delete_forever)),
                              const SizedBox(
                                width: 20,
                              ),
                              context.watch<Cart>().getItems.firstWhereOrNull(
                                              (element) =>
                                                  element.documentId ==
                                                  product.documentId) !=
                                          null ||
                                      product.inStock == 0
                                  ? const SizedBox()
                                  : IconButton(
                                      onPressed: () {
                                        context.read<Cart>().addItem(
                                              product.name,
                                              product.price,
                                              1,
                                              product.inStock,
                                              product.imagesUrl,
                                              product.documentId,
                                              product.supplierId,
                                            );
                                      },
                                      icon:
                                          const Icon(Icons.add_shopping_cart)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
