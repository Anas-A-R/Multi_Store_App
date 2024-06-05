import 'package:customer_multi_store_app/providers/id_provider.dart';
import 'package:flutter/material.dart';
import 'package:customer_multi_store_app/minor_screens/place_order.dart';
import 'package:customer_multi_store_app/models/cart_model.dart';
import 'package:customer_multi_store_app/providers/cart_provider.dart';
import 'package:customer_multi_store_app/widgets/alert_dialog.dart';
import 'package:customer_multi_store_app/widgets/appbar_widgets.dart';
import 'package:customer_multi_store_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  final Widget? back;
  const CartScreen({super.key, this.back});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // final Future<SharedPreferences> _perf = SharedPreferences.getInstance();
  // late Future<String> documentId;
  late String docId;
  @override
  void initState() {
    docId = context.read<IdProvider>().getData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double total = context.watch<Cart>().totalPrice;
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            leading: widget.back,
            title: const AppbarTitle(title: 'Cart'),
            centerTitle: true,
            actions: [
              context.watch<Cart>().getItems.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        MyAlertDialog().showAlertDialog(
                            title: 'Clear Cart',
                            content: 'Are you sure to clear cart?',
                            tabNo: () => Navigator.pop(context),
                            tabYes: () {
                              Navigator.pop(context);
                              context.read<Cart>().clearCart();
                            },
                            context: context);
                      },
                      icon: const Icon(Icons.delete_forever))
                  : const SizedBox()
            ],
          ),
          body: context.watch<Cart>().getItems.isNotEmpty
              ? const CartItems()
              : const EmptyCart(),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Total Price \$ ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      total.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                YellowButton(
                  label: 'CHECK OUT',
                  onPressed: total == 0.0
                      ? () {}
                      : docId == ''
                          ? () {
                              MyAlertDialog().showAlertDialog(
                                  btn1Text: 'Cancel',
                                  btn2Text: 'Login',
                                  title: 'Please log in',
                                  content:
                                      'You should be logged in to take an action',
                                  tabNo: () {
                                    Navigator.pop(context);
                                  },
                                  tabYes: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/customer_login');
                                  },
                                  context: context);
                            }
                          : () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PlaceOrderScreen(),
                                  ));
                            },
                  widthInPercent: 0.45,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Your cart is empty!',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 50,
            ),
            Material(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(20),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * 0.6,
                height: 50,
                onPressed: () {
                  Navigator.canPop(context)
                      ? Navigator.pop(context)
                      : Navigator.pushReplacementNamed(
                          context, '/customer_home');
                },
                child: const Text(
                  'Continue Shoping',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ]),
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return ListView.builder(
          itemCount: cart.count,
          itemBuilder: (context, index) {
            final product = cart.getItems[index];
            return CartModel(
              product: product,
              cart: context.read<Cart>(),
            );
          },
        );
      },
    );
  }
}
