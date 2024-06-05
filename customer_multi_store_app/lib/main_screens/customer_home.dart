// ignore_for_file: avoid_print

import 'package:customer_multi_store_app/minor_screens/visit_store.dart';
import 'package:customer_multi_store_app/providers/wishlist_provider.dart';
import 'package:customer_multi_store_app/services/notification_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:customer_multi_store_app/main_screens/cart.dart';
import 'package:customer_multi_store_app/main_screens/catagory.dart';
import 'package:customer_multi_store_app/main_screens/home.dart';
import 'package:customer_multi_store_app/main_screens/profile.dart';
import 'package:customer_multi_store_app/main_screens/stores.dart';
import 'package:customer_multi_store_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badge;

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    const HomeScreen(),
    const CatagoryScreen(),
    const StoresScreen(),
    const CartScreen(),
    const ProfileScreen()
  ];
  displayForegroudNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.data);
      if (message.notification != null) {
        print(
            'customer app//////////message also contained a notificaton as ${message.notification!.body}');
        NotificationServices().displayNotification(message);
      }
    });
  }

  Future<void> setupInteractedMessages() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage? message) {
    if (message!.data['type'] == 'store') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VisitStoreScreen(
                supplierID: 'u8ouFfs1g2YKynWKGpnmCRl6yHv1'),
          ));
    }
  }

  @override
  void initState() {
    context.read<Cart>().loadCartItemsProvider();
    context.read<Wishlist>().loadWishItems();
    displayForegroudNotifications();
    FirebaseMessaging.instance.getToken().then((value) {
      print(value);
    });
    setupInteractedMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Catagory'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.shop), label: 'Stores'),
          BottomNavigationBarItem(
              icon: badge.Badge(
                  showBadge:
                      context.watch<Cart>().getItems.isEmpty ? false : true,
                  badgeStyle: const badge.BadgeStyle(badgeColor: Colors.yellow),
                  badgeContent:
                      Text(context.watch<Cart>().getItems.length.toString()),
                  child: const Icon(Icons.shopping_cart)),
              label: 'Cart'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
