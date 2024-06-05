// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_store_app/auth/change_password.dart';
import 'package:multi_store_app/customers_screens/address_book.dart';
import 'package:multi_store_app/customers_screens/customer_orders.dart';
import 'package:multi_store_app/customers_screens/wishlist.dart';
import 'package:multi_store_app/main_screens/cart.dart';
import 'package:multi_store_app/widgets/alert_dialog.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:multi_store_app/widgets/profile_components.dart';

class ProfileScreen extends StatefulWidget {
  // final String documentId;
  const ProfileScreen({
    super.key,
    //  required this.documentId
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String documentId;
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          documentId = user.uid;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser!.isAnonymous
          ? FirebaseFirestore.instance
              .collection('anonymous_users')
              .doc(documentId)
              .get()
          : FirebaseFirestore.instance
              .collection('customers')
              .doc(documentId)
              .get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          );
        } else {
          final customerData = snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: Stack(
              children: [
                Container(
                  height: 180,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.yellow,
                    Colors.pink,
                  ])),
                ),
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: 140,
                      elevation: 0,
                      centerTitle: true,
                      backgroundColor: Colors.white,
                      flexibleSpace: LayoutBuilder(
                        builder: (context, constraints) {
                          return FlexibleSpaceBar(
                              title: AnimatedOpacity(
                                opacity:
                                    constraints.biggest.height <= 120 ? 1 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: const Text(
                                  'Account',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              background: Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                  Colors.yellow,
                                  Colors.pink,
                                ])),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    customerData['profile_image'] == ''
                                        ? const CircleAvatar(
                                            radius: 50,
                                            backgroundImage: AssetImage(
                                                'images/inapp/guest.jpg'),
                                          )
                                        : CircleAvatar(
                                            radius: 50,
                                            backgroundImage: NetworkImage(
                                                customerData['profile_image']),
                                          ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Text(
                                      customerData['name'] == ''
                                          ? "GUEST"
                                          : customerData['name'].toString(),
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ));
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              bottomLeft: Radius.circular(30)),
                                          color: Colors.black54),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const CartScreen(
                                                  back: AppbarBackButton(),
                                                ),
                                              ));
                                        },
                                        child: const Text(
                                          'Cart',
                                          style: TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 20),
                                        ),
                                      )),
                                  Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                          color: Colors.yellow),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const CustomerOrdersScreen(),
                                              ));
                                        },
                                        child: const Text(
                                          'Orders',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 20),
                                        ),
                                      )),
                                  Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30),
                                              bottomRight: Radius.circular(30)),
                                          color: Colors.black54),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const CustomerWishlistScreen(),
                                              ));
                                        },
                                        child: const Text(
                                          'Wishlist',
                                          style: TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 20),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade300,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 150,
                                  child: Image(
                                      image:
                                          AssetImage('images/inapp/logo.jpg')),
                                ),
                                const ProfileHeaderLabel(
                                  label: 'Account Info',
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: [
                                      RepeatedListTile(
                                        title: 'Email Address',
                                        icon: Icons.email,
                                        subTitle: customerData['email'] == ''
                                            ? 'example@gmail.com'
                                            : customerData['email'],
                                      ),
                                      const YellowDivider(),
                                      RepeatedListTile(
                                        title: 'Phone Number',
                                        icon: Icons.phone,
                                        subTitle: customerData['phone'] == ''
                                            ? 'example: +92 333 4455666'
                                            : customerData['phone'],
                                      ),
                                      const YellowDivider(),
                                      RepeatedListTile(
                                        onPressed: FirebaseAuth.instance
                                                .currentUser!.isAnonymous
                                            ? null
                                            : () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const AddressBookScreen(),
                                                    ));
                                              },
                                        title: 'Address',
                                        icon: Icons.location_pin,
                                        subTitle: userAddress(customerData),
                                        //  customerData['address'] == ''
                                        //     ? 'example: street # 1, shahdra lahore'
                                        //     : customerData['address'],
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print(userAddress(customerData));
                                  },
                                  child: const ProfileHeaderLabel(
                                    label: 'Account Settings',
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: [
                                      const RepeatedListTile(
                                        title: 'Edit Profile',
                                        icon: Icons.edit,
                                      ),
                                      const YellowDivider(),
                                      RepeatedListTile(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ChangePasswordScreen(),
                                            )),
                                        title: 'Change Password',
                                        icon: Icons.lock,
                                      ),
                                      const YellowDivider(),
                                      RepeatedListTile(
                                        title: 'Log Out',
                                        icon: Icons.logout,
                                        onPressed: () {
                                          MyAlertDialog().showAlertDialog(
                                              title: 'Log Out',
                                              content:
                                                  'Are you sure to log out ?',
                                              tabNo: () {
                                                Navigator.pop(context);
                                              },
                                              tabYes: () async {
                                                Navigator.of(context).pop();
                                                await FirebaseAuth.instance
                                                    .signOut();
                                                Navigator.pushReplacementNamed(
                                                    context, '/welcome_screen');
                                              },
                                              context: context);
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }

  String userAddress(dynamic data) {
    if (FirebaseAuth.instance.currentUser!.isAnonymous == true) {
      return 'example address street no 1 shahdra lahore.';
    } else if (FirebaseAuth.instance.currentUser!.isAnonymous == false &&
        data['address'] == '') {
      return 'Please add your address';
    }
    return data['address'].toString();
  }
}
