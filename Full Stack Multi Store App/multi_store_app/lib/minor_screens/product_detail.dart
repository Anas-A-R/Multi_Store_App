// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:multi_store_app/main_screens/cart.dart';
import 'package:multi_store_app/minor_screens/visit_store.dart';
import 'package:multi_store_app/minor_screens/full_screen_view.dart';
import 'package:multi_store_app/models/product_model.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/wishlist_provider.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:multi_store_app/widgets/snack_bar.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:collection/collection.dart';
import 'package:badges/badges.dart' as badge;
import 'package:expandable/expandable.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic productList;
  const ProductDetailScreen({super.key, required this.productList});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    final existingCartItem = context.read<Cart>().getItems.firstWhereOrNull(
        (product) => product.documentId == widget.productList['product_id']);
    late List<dynamic> imagesList = widget.productList['product_images'];
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldMessengerKey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenView(
                                imageList: imagesList,
                              ),
                            ));
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.45,
                            child: Swiper(
                                pagination: const SwiperPagination(
                                    builder: SwiperPagination.fraction),
                                itemBuilder: (context, index) {
                                  return Image(
                                      image: NetworkImage(imagesList[index]));
                                },
                                itemCount: imagesList.length),
                          ),
                          Positioned(
                              left: 15,
                              top: 20,
                              child: CircleAvatar(
                                backgroundColor: Colors.yellow,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.black,
                                    )),
                              )),
                          Positioned(
                              right: 15,
                              top: 20,
                              child: CircleAvatar(
                                backgroundColor: Colors.yellow,
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.share,
                                      color: Colors.black,
                                    )),
                              )),
                        ],
                      ),
                    ),
                    Text(
                      widget.productList['product_name'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 18,
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
                              widget.productList['product_price']
                                  .toStringAsFixed(2),
                              style: widget.productList['product_discount'] != 0
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
                            widget.productList['product_discount'] != 0
                                ? Text(
                                    ((1 -
                                                (widget.productList[
                                                        'product_discount'] /
                                                    100)) *
                                            widget.productList['product_price'])
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
                                  .firstWhereOrNull((product) =>
                                      product.documentId ==
                                      widget.productList['product_id']);
                              existingWishlistItem != null
                                  ? context.read<Wishlist>().removeThis(
                                      widget.productList['product_id'])
                                  : context.read<Wishlist>().addIWishlistItem(
                                        widget.productList['product_name'],
                                        widget.productList[
                                                    'product_discount'] !=
                                                0
                                            ? ((1 -
                                                    (widget.productList[
                                                            'product_discount'] /
                                                        100)) *
                                                widget.productList[
                                                    'product_price'])
                                            : widget
                                                .productList['product_price'],
                                        1,
                                        widget.productList['product_instoke'],
                                        widget.productList['product_images'],
                                        widget.productList['product_id'],
                                        widget.productList['supplier_id'],
                                      );
                            },
                            icon: context
                                        .watch<Wishlist>()
                                        .getWishlistItems
                                        .firstWhereOrNull((product) =>
                                            product.documentId ==
                                            widget.productList['product_id']) !=
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
                    ),
                    widget.productList['product_instoke'] == 0
                        ? const Text(
                            'This item is out of stock',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : Text(
                            '${widget.productList['product_instoke']} pieces available in stoke',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    Stack(
                      children: [
                        const Positioned(
                            right: 50, top: 12, child: Text('Total')),
                        ExpandableTheme(
                            data: const ExpandableThemeData(
                                iconColor: Colors.blue, iconSize: 30),
                            child: reviews(widget.productList['product_id'])),
                      ],
                    ),
                    const ProductDetailHeader(
                      label: 'Item Description',
                    ),
                    Text(
                      widget.productList['product_description'],
                      // maxLines: 2,
                      textScaleFactor: 1.1,
                      // overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.blueGrey.shade600,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const ProductDetailHeader(
                      label: 'Similar Items',
                    ),
                    SizedBox(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('products')
                            .where('product_mainCategory',
                                isEqualTo:
                                    widget.productList['product_mainCategory'])
                            .where('product_subCategory',
                                isEqualTo:
                                    widget.productList['product_subCategory'])
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('Something went wrong'));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (snapshot.data!.docs.isEmpty) {
                            return const Center(
                                child: Text(
                              "This Category\n\nHas No Data Yet ! ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                  letterSpacing: 1.5,
                                  fontFamily: 'Acme'),
                            ));
                          }
                          return SingleChildScrollView(
                            child: StaggeredGridView.countBuilder(
                              itemCount: snapshot.data!.docs.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              itemBuilder: (context, index) {
                                return ProductModel(
                                  product: snapshot.data!.docs[index],
                                );
                              },
                              staggeredTileBuilder: (index) =>
                                  const StaggeredTile.fit(1),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return VisitStoreScreen(
                                supplierID: widget.productList['supplier_id']);
                          },
                        ));
                      },
                      icon: const Icon(Icons.store)),
                  IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const CartScreen(
                              back: AppbarBackButton(),
                            );
                          },
                        ));
                      },
                      icon: badge.Badge(
                          showBadge: context.watch<Cart>().getItems.isEmpty
                              ? false
                              : true,
                          badgeStyle:
                              const badge.BadgeStyle(badgeColor: Colors.yellow),
                          badgeContent: Text(
                              context.watch<Cart>().getItems.length.toString()),
                          child: const Icon(Icons.shopping_cart))),
                  YellowButton(
                      label: existingCartItem != null
                          ? 'Added to cart'
                          : 'Add To Cart',
                      onPressed: () {
                        if (widget.productList['product_instoke'] == 0) {
                          MyMessageHandler.showSnackBar(_scaffoldMessengerKey,
                              'This items is out of stock');
                        } else if (existingCartItem != null) {
                          MyMessageHandler.showSnackBar(_scaffoldMessengerKey,
                              'This items already exist in the cart');
                        } else {
                          context.read<Cart>().addItem(
                                widget.productList['product_name'],
                                widget.productList['product_discount'] != 0
                                    ? ((1 -
                                            (widget.productList[
                                                    'product_discount'] /
                                                100)) *
                                        widget.productList['product_price'])
                                    : widget.productList['product_price'],
                                1,
                                widget.productList['product_instoke'],
                                widget.productList['product_images'],
                                widget.productList['product_id'],
                                widget.productList['supplier_id'],
                              );
                        }
                      },
                      widthInPercent: 0.5)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailHeader extends StatelessWidget {
  final String label;
  const ProductDetailHeader({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              thickness: 1,
              color: Colors.yellow.shade900,
            ),
          ),
          Text(
            '   $label   ',
            style: TextStyle(
                color: Colors.yellow.shade900,
                fontSize: 24,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              thickness: 1,
              color: Colors.yellow.shade900,
            ),
          ),
        ],
      ),
    );
  }
}

Widget reviews(String productId) {
  return ExpandablePanel(
//      expandable: ^5.0.1
    header: const Text(
      'Reviews',
      style: TextStyle(
          fontSize: 24, fontWeight: FontWeight.w600, color: Colors.blue),
    ),
    collapsed: SizedBox(height: 100, child: reviewAll(productId)),
    expanded: reviewAll(productId),
  );
}

Widget reviewAll(String productId) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
      if (snapshot2.hasError) {
        return const Center(child: Text('Something went wrong'));
      }

      if (snapshot2.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot2.data!.docs.isEmpty) {
        return const Center(
            child: Text(
          "This Category\n\nHas No Review Yet ! ",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
              letterSpacing: 1.5,
              fontFamily: 'Acme'),
        ));
      }
      return SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot2.data!.docs.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      snapshot2.data!.docs[index]['profile_image'])),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(snapshot2.data!.docs[index]['name']),
                  Row(
                    children: [
                      Text(snapshot2.data!.docs[index]['rating'].toString()),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      )
                    ],
                  ),
                ],
              ),
              subtitle: Text(snapshot2.data!.docs[index]['review']),
            );
          },
        ),
      );
    },
  );
}
