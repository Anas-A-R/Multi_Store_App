// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/stripe_id.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  final String name;
  final String address;
  final String phoneNumber;
  const PaymentScreen(
      {super.key,
      required this.name,
      required this.address,
      required this.phoneNumber});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedGroupValue = 1;
  void showProcessing() async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Please Wait...');
  }

  @override
  Widget build(BuildContext context) {
    var totalPaid = context.watch<Cart>().totalPrice + 10.0;
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('customers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              ),
            );
          } else {
            final customerData = snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              backgroundColor: Colors.grey.shade200,
              appBar: AppBar(
                backgroundColor: Colors.grey.shade200,
                leading: const AppbarBackButton(),
                title: const AppbarTitle(title: 'Payment'),
                centerTitle: true,
              ),
              body: Material(
                color: Colors.grey.shade200,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                    child: Column(
                      children: [
                        Container(
                            height: 90,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blueGrey.shade600),
                                      ),
                                      Text(
                                        totalPaid.toStringAsFixed(2) + (' USD'),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blueGrey.shade600),
                                      )
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 2,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Order Total',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        (totalPaid.toStringAsFixed(2)) +
                                            (' USD'),
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Shipping Cost',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        '10.00 USD',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  )
                                ])),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          child: Column(
                            children: [
                              RadioListTile(
                                value: 1,
                                groupValue: selectedGroupValue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGroupValue = value!;
                                  });
                                },
                                title: const Text('Cash on delivery'),
                                subtitle: const Text('Pay cash at home'),
                              ),
                              RadioListTile(
                                value: 2,
                                groupValue: selectedGroupValue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGroupValue = value!;
                                  });
                                },
                                title: const Text(
                                    'Payment via visa / Master Card'),
                                subtitle: const Row(
                                  children: [
                                    Icon(
                                      Icons.payment,
                                      color: Colors.blue,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Icon(FontAwesomeIcons.ccMastercard,
                                          color: Colors.blue),
                                    ),
                                    Icon(FontAwesomeIcons.ccVisa,
                                        color: Colors.blue),
                                  ],
                                ),
                              ),
                              RadioListTile(
                                  value: 3,
                                  groupValue: selectedGroupValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGroupValue = value!;
                                    });
                                  },
                                  title: const Text('Pay via PayPal'),
                                  subtitle: const Row(
                                    children: [
                                      Icon(FontAwesomeIcons.paypal,
                                          color: Colors.blue),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(FontAwesomeIcons.ccPaypal,
                                          color: Colors.blue),
                                    ],
                                  )),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              ),
              bottomSheet: Container(
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: YellowButton(
                      label:
                          'Confirm ${context.watch<Cart>().totalPrice.toStringAsFixed(2)} USD',
                      onPressed: () async {
                        if (selectedGroupValue == 1) {
                          showModalBottomSheet(
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (context) => Container(
                              padding: const EdgeInsets.all(50),
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Pay at home ${totalPaid.toStringAsFixed(2)} \$',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blueGrey.shade600),
                                  ),
                                  YellowButton(
                                      label:
                                          'Confirm ${totalPaid.toStringAsFixed(2)} \$',
                                      onPressed: () async {
                                        showProcessing();
                                        for (var item
                                            in context.read<Cart>().getItems) {
                                          var uuid = const Uuid();
                                          var orderId = uuid.v4();
                                          await FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(orderId)
                                              .set({
                                            //customer data
                                            'customer_id': customerData[
                                                'cid'], //customer data coming from future builder from firestore
                                            'customer_name': widget.name,
                                            'customer_email':
                                                customerData['email'],
                                            'customer_address': widget.address,
                                            'customer_phone':
                                                widget.phoneNumber,
                                            'customer_profile':
                                                customerData['profile_image'],

                                            //supplier data
                                            'supplier_id': item
                                                .supplierId, //coming from cart items

                                            //order data
                                            'order_image': item.imagesUrl
                                                .first, //coming from cart items
                                            'order_quantity': item
                                                .quantity, //coming from cart items
                                            'order_price': item.price *
                                                item.quantity, //coming from cart items
                                            'product_id': item
                                                .documentId, //coming from cart items
                                            'order_id':
                                                orderId, //uniquely creating at this time
                                            'order_name': item.name,
                                            'delivery_status': 'preparing',
                                            'order_date': DateTime.now(),
                                            'delivery_date': '',
                                            'payment_status':
                                                'Cash on delivery',
                                            'order_review': false,
                                            //
                                          }).whenComplete(() async {
                                            //run a transaction to update a field(product_instoke) in the products collection
                                            await FirebaseFirestore.instance
                                                .runTransaction(
                                                    (transaction) async {
                                              DocumentReference
                                                  documentReference =
                                                  FirebaseFirestore.instance
                                                      .collection('products')
                                                      .doc(item.documentId);
                                              DocumentSnapshot snapshot2 =
                                                  await transaction
                                                      .get(documentReference);
                                              transaction.update(
                                                  documentReference, {
                                                'product_instoke': snapshot2[
                                                        'product_instoke'] -
                                                    item.quantity
                                              });
                                            });
                                          });
                                        }
                                        context.read<Cart>().clearCart();
                                        Navigator.popUntil(
                                            context,
                                            ModalRoute.withName(
                                                '/customer_home')); //tab tak pop kro jb tak customer home nhi a jata
                                      },
                                      widthInPercent: 1)
                                ],
                              ),
                            ),
                          );
                        } else if (selectedGroupValue == 2) {
                          print('visa');
                          int payment = totalPaid.round();
                          int pay = payment * 100;

                          await makePayment(customerData, pay.toString());
                        } else if (selectedGroupValue == 3) {
                          print('paypal');
                        }
                      },
                      widthInPercent: 1),
                ),
              ),
            );
          }
        });
  }

  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(dynamic customerData, String total) async {
    //create payment intent
    paymentIntentData = await createPaymentIntent(total, 'USD');
    //init payment sheet
    try {
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentData!['client_secret'],
        applePay: true,
        googlePay: true,
        merchantDisplayName: 'ANAS',
        merchantCountryCode: 'us',
      ));
    } catch (e) {
      print('error2 is: $e');
    }
    //display payment sheet
    displayPaymentSheet(customerData);
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': "application/x-www-form-urlencoded",
        },
        body: {
          'amount': amount,
          'currency': currency,
          'payment_method_types[]': 'card',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to create Payment Intent: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating Payment Intent: $e');
      return null;
    }
  }

  displayPaymentSheet(var customerData) async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
        parameters: PresentPaymentSheetParameters(
          clientSecret: paymentIntentData!['client_secret'],
          confirmPayment: true,
        ),
      )
          .then((value) async {
        paymentIntentData = null;
        print('paid');

        showProcessing();
        for (var item in context.read<Cart>().getItems) {
          var uuid = const Uuid();
          var orderId = uuid.v4();
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(orderId)
              .set({
            //customer data
            'customer_id': customerData[
                'cid'], //customer data coming from future builder from firestore
            'customer_name': customerData['name'],
            'customer_email': customerData['email'],
            'customer_address': customerData['address'],
            'customer_phone': customerData['phone'],
            'customer_profile': customerData['profile_image'],

            //supplier data
            'supplier_id': item.supplierId, //coming from cart items

            //order data
            'order_image': item.imagesUrl.first, //coming from cart items
            'order_quantity': item.quantity, //coming from cart items
            'order_price': item.price * item.quantity, //coming from cart items
            'product_id': item.documentId, //coming from cart items
            'order_id': orderId, //uniquely creating at this time
            'order_name': item.name,
            'delivery_status': 'preparing',
            'order_date': DateTime.now(),
            'delivery_date': '',
            'payment_status': 'Payment online',
            'order_review': false,
            //
          }).whenComplete(() async {
            //run a transaction to update a field(product_instoke) in the products collection
            await FirebaseFirestore.instance
                .runTransaction((transaction) async {
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('products')
                  .doc(item.documentId);
              DocumentSnapshot snapshot2 =
                  await transaction.get(documentReference);
              transaction.update(documentReference, {
                'product_instoke': snapshot2['product_instoke'] - item.quantity
              });
            });
          });
        }
        context.read<Cart>().clearCart();
        Navigator.popUntil(
            context,
            ModalRoute.withName(
                '/customer_home')); //tab tak pop kro jb tak customer home nhi a jata
      });
    } catch (e) {
      print('Error: $e');
    }
  }
}
