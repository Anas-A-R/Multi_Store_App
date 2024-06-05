// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_multi_store_app/providers/id_provider.dart';
import 'package:customer_multi_store_app/widgets/yellow_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:customer_multi_store_app/auth/change_password.dart';
import 'package:customer_multi_store_app/customers_screens/address_book.dart';
import 'package:customer_multi_store_app/customers_screens/customer_orders.dart';
import 'package:customer_multi_store_app/customers_screens/wishlist.dart';
import 'package:customer_multi_store_app/main_screens/cart.dart';
import 'package:customer_multi_store_app/widgets/alert_dialog.dart';
import 'package:customer_multi_store_app/widgets/appbar_widgets.dart';
import 'package:customer_multi_store_app/widgets/profile_components.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  clearUserId() {
    context.read<IdProvider>().clearCustomerId();
  }

  late Future<String> documentId;
  late String docId;
  @override
  void initState() {
    documentId = context.read<IdProvider>().getDocumentId();
    docId = context.read<IdProvider>().getData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: documentId,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.purple,
              ),
            );
          case ConnectionState.done:
            return docId != '' ? userScaffold() : noUserScaffold();
          default:
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.purple,
              ),
            );
        }
      },
    );
  }

  String userAddress(dynamic data) {
    if (/*FirebaseAuth.instance.currentUser!.isAnonymous == true*/ docId ==
        '') {
      return 'example address street no 1 shahdra lahore.';
    } else if (FirebaseAuth.instance.currentUser!.isAnonymous == false &&
        data['address'] == '') {
      return 'Please add your address';
    }
    return data['address'].toString();
  }

  Widget userScaffold() {
    return FutureBuilder(
      future: /* FirebaseAuth.instance.currentUser!.isAnonymous
          ? FirebaseFirestore.instance
              .collection('anonymous_users')
              .doc(docId)
              .get()
          : */
          FirebaseFirestore.instance.collection('customers').doc(docId).get(),
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
                                        onPressed: () {
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
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
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
                                                clearUserId();
                                                // final SharedPreferences perf =
                                                //     await _perf;
                                                // perf.setString(
                                                //     'customerid', '');
                                                await FirebaseAuth.instance
                                                    .signOut();
                                                Navigator.pushReplacementNamed(
                                                    context, '/onboarding');
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

  Widget noUserScaffold() {
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
                          opacity: constraints.biggest.height <= 120 ? 1 : 0,
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
                              const CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage('images/inapp/guest.jpg'),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              const Text(
                                "GUEST",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              YellowButton(
                                  label: 'Login',
                                  onPressed: () =>
                                      Navigator.pushReplacementNamed(
                                          context, '/customer_login'),
                                  widthInPercent: 0.2)
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.25,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        bottomLeft: Radius.circular(30)),
                                    color: Colors.black54),
                                child: TextButton(
                                  onPressed: () {
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
                                  },
                                  child: const Text(
                                    'Cart',
                                    style: TextStyle(
                                        color: Colors.yellow, fontSize: 20),
                                  ),
                                )),
                            Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.25,
                                alignment: Alignment.center,
                                decoration:
                                    const BoxDecoration(color: Colors.yellow),
                                child: TextButton(
                                  onPressed: () {
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
                                  },
                                  child: const Text(
                                    'Orders',
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 20),
                                  ),
                                )),
                            Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.25,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30),
                                        bottomRight: Radius.circular(30)),
                                    color: Colors.black54),
                                child: TextButton(
                                  onPressed: () {
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
                                  },
                                  child: const Text(
                                    'Wishlist',
                                    style: TextStyle(
                                        color: Colors.yellow, fontSize: 20),
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
                                image: AssetImage('images/inapp/logo.jpg')),
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
                                const RepeatedListTile(
                                  title: 'Email Address',
                                  icon: Icons.email,
                                  subTitle: 'example@gmail.com',
                                ),
                                const YellowDivider(),
                                const RepeatedListTile(
                                  title: 'Phone Number',
                                  icon: Icons.phone,
                                  subTitle: 'example: +92 333 4455666',
                                ),
                                const YellowDivider(),
                                RepeatedListTile(
                                    onPressed: () {},
                                    title: 'Address',
                                    icon: Icons.location_pin,
                                    subTitle:
                                        'example: street # 1, shahdra lahore'),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
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
                                        content: 'Are you sure to log out ?',
                                        tabNo: () {
                                          Navigator.pop(context);
                                        },
                                        tabYes: () async {
                                          Navigator.of(context).pop();
                                          await FirebaseAuth.instance.signOut();
                                          Navigator.pushReplacementNamed(
                                              context, '/onboarding');
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
}
