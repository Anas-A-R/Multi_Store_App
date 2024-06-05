import 'package:customer_multi_store_app/providers/wishlist_sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:customer_multi_store_app/models/wishlist_model.dart';
import 'package:customer_multi_store_app/providers/wishlist_provider.dart';
import 'package:customer_multi_store_app/widgets/alert_dialog.dart';
import 'package:customer_multi_store_app/widgets/appbar_widgets.dart';
import 'package:provider/provider.dart';

class CustomerWishlistScreen extends StatelessWidget {
  const CustomerWishlistScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: const AppbarTitle(title: 'Wishlist'),
            centerTitle: true,
            actions: [
              context.watch<Wishlist>().getWishlistItems.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        MyAlertDialog().showAlertDialog(
                            title: 'Clear Wishlist',
                            content: 'Are you sure to clear wishlist?',
                            tabNo: () => Navigator.pop(context),
                            tabYes: () {
                              WishlistSQLHelper.deleteAllItems()
                                  .whenComplete(() {
                                Navigator.pop(context);
                                context.read<Wishlist>().clearWishlist();
                              });
                            },
                            context: context);
                      },
                      icon: const Icon(Icons.delete_forever))
                  : const SizedBox()
            ],
          ),
          body: context.watch<Wishlist>().getWishlistItems.isNotEmpty
              ? const WishlistItems()
              : const EmptyWishlist(),
        ),
      ),
    );
  }
}

class EmptyWishlist extends StatelessWidget {
  const EmptyWishlist({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Your Wishlist is empty!',
        style: TextStyle(
            fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class WishlistItems extends StatelessWidget {
  const WishlistItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Wishlist>(
      builder: (context, wishlist, child) {
        return ListView.builder(
          itemCount: wishlist.count,
          itemBuilder: (context, index) {
            final product = wishlist.getWishlistItems[index];
            return WishlistModel(product: product);
          },
        );
      },
    );
  }
}
