import 'package:collection/collection.dart';
import 'package:customer_multi_store_app/providers/product_class.dart';
import 'package:flutter/material.dart';
import 'package:customer_multi_store_app/minor_screens/product_detail.dart';
import 'package:customer_multi_store_app/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class ProductModel extends StatefulWidget {
  final dynamic product;
  const ProductModel({
    super.key,
    this.product,
  });

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(
                productList: widget.product,
              ),
            ));
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: Container(
                    constraints:
                        const BoxConstraints(minHeight: 100, maxHeight: 250),
                    child: Image(
                      image: NetworkImage(
                        widget.product['product_images'][0],
                      ),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product['product_name'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                (' \$ '),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                widget.product['product_price']
                                    .toStringAsFixed(2),
                                style: widget.product['product_discount'] != 0
                                    ? const TextStyle(
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      )
                                    : const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              widget.product['product_discount'] != 0
                                  ? Text(
                                      ((1 -
                                                  (widget.product[
                                                          'product_discount'] /
                                                      100)) *
                                              widget.product['product_price'])
                                          .toStringAsFixed(2),
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : const Text(''),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                final existingWishlistItem = context
                                    .read<Wishlist>()
                                    .getWishlistItems
                                    .firstWhereOrNull((element) =>
                                        element.documentId ==
                                        widget.product['product_id']);
                                existingWishlistItem != null
                                    ? context.read<Wishlist>().removeThis(
                                        widget.product['product_id'])
                                    : context.read<Wishlist>().addIWishlistItem(
                                          Product(
                                            name:
                                                widget.product['product_name'],
                                            price: widget.product[
                                                        'product_discount'] !=
                                                    0
                                                ? ((1 -
                                                        (widget.product[
                                                                'product_discount'] /
                                                            100)) *
                                                    widget.product[
                                                        'product_price'])
                                                : widget
                                                    .product['product_price'],
                                            quantity: 1,
                                            inStock: widget
                                                .product['product_instoke'],
                                            imagesUrl: widget
                                                .product['product_images'][0],
                                            documentId:
                                                widget.product['product_id'],
                                            supplierId:
                                                widget.product['supplier_id'],
                                          ),
                                        );
                              },
                              icon: context
                                          .watch<Wishlist>()
                                          .getWishlistItems
                                          .firstWhereOrNull((element) =>
                                              element.documentId ==
                                              widget.product['product_id']) !=
                                      null
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : const Icon(
                                      Icons.favorite_border_outlined,
                                      color: Colors.red,
                                    ))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          widget.product['product_discount'] == 0
              ? Container()
              : Container(
                  width: 80,
                  height: 25,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 10, top: 30),
                  decoration: const BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5))),
                  child: Text('Save ${widget.product['product_discount']} %'),
                )
        ],
      ),
    );
  }
}
