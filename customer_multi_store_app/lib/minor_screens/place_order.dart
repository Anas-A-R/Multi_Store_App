import 'package:customer_multi_store_app/providers/id_provider.dart';
import 'package:flutter/material.dart';
import 'package:customer_multi_store_app/customers_screens/add_address.dart';
import 'package:customer_multi_store_app/customers_screens/address_book.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_multi_store_app/widgets/yellow_button.dart';
import 'package:customer_multi_store_app/widgets/appbar_widgets.dart';
import 'package:customer_multi_store_app/providers/cart_provider.dart';
import 'package:customer_multi_store_app/minor_screens/payment_screen.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  late String name;
  late String phoneNumber;
  late String address;
  late String docId;
  @override
  void initState() {
    docId = context.read<IdProvider>().getData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('customers')
            .doc(/*FirebaseAuth.instance.currentUser!.uid*/ docId)
            .collection('address')
            .where('default', isEqualTo: true)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.grey.shade200,
              appBar: AppBar(
                backgroundColor: Colors.grey.shade200,
                leading: const AppbarBackButton(),
                title: const AppbarTitle(title: 'Place Order'),
                centerTitle: true,
              ),
              body: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Material(
                  color: Colors.grey.shade200,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                      child: Column(
                        children: [
                          snapshot.data!.docs.isEmpty == true
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AddAddressScreen(),
                                        ));
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: 90,
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white),
                                      child: const Text(
                                        'Set your address',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Acme'),
                                      )),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    final customerData =
                                        snapshot.data!.docs[index];
                                    name = customerData['first_name'] +
                                        (' ') +
                                        customerData['last_name'];
                                    phoneNumber = customerData['phone_number'];
                                    address = customerData['city'] +
                                        (' ') +
                                        customerData['state'] +
                                        (' ') +
                                        customerData['country'];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddressBookScreen(),
                                            ));
                                      },
                                      child: Container(
                                          height: 90,
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.white),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Name: ${customerData['first_name']}'),
                                                Text(
                                                    'Phone: ${customerData['phone_number']}'),
                                                Text(
                                                    'Address: ${customerData['city']} ${customerData['state']} ${customerData['country']}')
                                              ])),
                                    );
                                  },
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 500,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white),
                            child: Consumer<Cart>(
                              builder: (context, cart, child) {
                                return ListView.builder(
                                  itemCount: cart.count,
                                  itemBuilder: (context, index) {
                                    var order = cart.getItems[index];
                                    return Container(
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 5),
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(width: 0.5)),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 100,
                                            width: 80,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.network(
                                                order.imagesUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  order.name,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors
                                                          .blueGrey.shade600),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      order.price
                                                          .toStringAsFixed(2),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.blueGrey
                                                              .shade600),
                                                    ),
                                                    Text(
                                                      ' x ${order.quantity}',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.blueGrey
                                                              .shade600),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        ],
                      ),
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
                      onPressed: snapshot.data!.docs.isEmpty == true
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AddAddressScreen(),
                                  ));
                            }
                          : () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentScreen(
                                      name: name,
                                      address: address,
                                      phoneNumber: phoneNumber,
                                    ),
                                  ));
                            },
                      widthInPercent: 1),
                ),
              ),
            );
          }
        });
  }
}
