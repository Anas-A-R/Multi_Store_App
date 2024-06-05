import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/customers_screens/add_address.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({super.key});

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  Future updateProfile(dynamic data) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'phone': data['phone_number'],
        'address': '${data['city']} ${data['state']} ${data['country']}',
      });
    });
  }

  Future defaultAddressTrue(dynamic data) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('address')
          .doc(data['address_id']);
      transaction.update(documentReference, {
        'default': true,
      });
    });
  }

  Future defaultAddressFalse(dynamic item) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('address')
          .doc(item['address_id']);
      transaction.update(documentReference, {
        'default': false,
      });
    });
  }

  void showProcessing() async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Please Wait...');
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
        .collection('customers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('address')
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const AppbarTitle(title: 'Address Book'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: productStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text(
                    "You have not set address yet!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                        letterSpacing: 1.5,
                        fontFamily: 'Acme'),
                  ));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        height: 120,
                        child: Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) async => FirebaseFirestore
                              .instance
                              .runTransaction((transaction) async {
                            DocumentReference docReference = FirebaseFirestore
                                .instance
                                .collection('customers')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('address')
                                .doc(snapshot.data!.docs[index]['address_id']);
                            transaction.delete(docReference);
                          }),
                          child: GestureDetector(
                            onTap: () async {
                              showProcessing();
                              for (var item in snapshot.data!.docs) {
                                await defaultAddressFalse(item);
                              }
                              defaultAddressTrue(snapshot.data!.docs[index])
                                  .whenComplete(() => updateProfile(
                                      snapshot.data!.docs[index]));
                              Future.delayed(const Duration(microseconds: 100))
                                  .whenComplete(() => Navigator.pop(context));
                            },
                            child: Card(
                              color:
                                  snapshot.data!.docs[index]['default'] == true
                                      ? Colors.white
                                      : Colors.yellow,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ("Name: ") +
                                              snapshot.data!.docs[index]
                                                  ['first_name'] +
                                              (' ') +
                                              snapshot.data!.docs[index]
                                                  ['last_name'],
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1),
                                        ),
                                        Text(
                                          ("Phone Number: ") +
                                              snapshot.data!.docs[index]
                                                  ['phone_number'],
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1),
                                        ),
                                        Text(
                                          ("State / City: ") +
                                              snapshot.data!.docs[index]
                                                  ['city'] +
                                              (' ') +
                                              snapshot.data!.docs[index]
                                                  ['state'],
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1),
                                        ),
                                        Text(
                                          ("Country: ") +
                                              snapshot.data!.docs[index]
                                                  ['country'],
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1),
                                        ),
                                      ],
                                    ),
                                    snapshot.data!.docs[index]['default'] ==
                                            true
                                        ? const Icon(Icons.home)
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: YellowButton(
                label: 'Add New Address',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddAddressScreen(),
                      ));
                },
                widthInPercent: 01),
          )
        ],
      ),
    );
  }
}
