import 'package:flutter/material.dart';
import 'package:multi_store_app/main_screens/cart.dart';
import 'package:multi_store_app/main_screens/catagory.dart';
import 'package:multi_store_app/main_screens/home.dart';
import 'package:multi_store_app/main_screens/profile.dart';
import 'package:multi_store_app/main_screens/stores.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
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
    const ProfileScreen(
        // documentId: FirebaseAuth.instance.currentUser!.uid,
        )
  ];
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
