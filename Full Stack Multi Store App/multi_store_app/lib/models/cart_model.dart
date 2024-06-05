import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/product_class.dart';
import 'package:multi_store_app/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class CartModel extends StatelessWidget {
  const CartModel({
    super.key,
    required this.product,
    required this.cart,
  });

  final Product product;
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: SizedBox(
          height: 100,
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
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                product.quantity == 1
                                    ? IconButton(
                                        onPressed: () {
                                          showCupertinoModalPopup(
                                            context: context,
                                            builder: (context) {
                                              return CupertinoActionSheet(
                                                title:
                                                    const Text('Remove Item'),
                                                message: const Text(
                                                    'Are you sure you want to remove item from cart?'),
                                                actions: [
                                                  CupertinoActionSheetAction(
                                                    onPressed: () async {
                                                      final result = context
                                                          .read<Wishlist>()
                                                          .getWishlistItems
                                                          .firstWhereOrNull(
                                                              (element) =>
                                                                  element
                                                                      .documentId ==
                                                                  product
                                                                      .documentId);
                                                      result != null
                                                          ? context
                                                              .read<Cart>()
                                                              .removeItem(
                                                                  product)
                                                          : await context
                                                              .read<Wishlist>()
                                                              .addIWishlistItem(
                                                                product.name,
                                                                product.price,
                                                                1,
                                                                product.inStock,
                                                                product
                                                                    .imagesUrl,
                                                                product
                                                                    .documentId,
                                                                product
                                                                    .supplierId,
                                                              );
                                                      Navigator.pop(context);
                                                      context
                                                          .read<Cart>()
                                                          .removeItem(product);
                                                    },
                                                    child: const Text(
                                                        'Move to wishlist'),
                                                  ),
                                                  CupertinoActionSheetAction(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      cart.removeItem(product);
                                                    },
                                                    child: const Text(
                                                        'Delete Item'),
                                                  ),
                                                ],
                                                cancelButton: TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete_forever,
                                          size: 18,
                                        ))
                                    : IconButton(
                                        onPressed: () {
                                          cart.decrement(product);
                                        },
                                        icon: const Icon(
                                          FontAwesomeIcons.minus,
                                          size: 18,
                                        )),
                                Text(product.quantity.toString(),
                                    style: product.quantity == product.inStock
                                        ? const TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Acme',
                                            color: Colors.red)
                                        : const TextStyle(
                                            fontSize: 20, fontFamily: 'Acme')),
                                IconButton(
                                    onPressed:
                                        product.quantity == product.inStock
                                            ? null
                                            : () {
                                                cart.increment(product);
                                              },
                                    icon: const Icon(
                                      FontAwesomeIcons.plus,
                                      size: 18,
                                    )),
                              ],
                            ),
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
