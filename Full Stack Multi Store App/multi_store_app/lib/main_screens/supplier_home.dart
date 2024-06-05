import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/main_screens/catagory.dart';
import 'package:multi_store_app/main_screens/dashboard.dart';
import 'package:multi_store_app/main_screens/home.dart';
import 'package:multi_store_app/main_screens/stores.dart';
import 'package:multi_store_app/main_screens/upload_product.dart';
import 'package:badges/badges.dart' as badge;

class SupplierHomeScreen extends StatefulWidget {
  const SupplierHomeScreen({super.key});

  @override
  State<SupplierHomeScreen> createState() => SupplierHomeScreenState();
}

class SupplierHomeScreenState extends State<SupplierHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = const [
    HomeScreen(),
    CatagoryScreen(),
    StoresScreen(),
    DashboardScreen(),
    UploadProductScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('delivery_status', isEqualTo: 'preparing')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          body: _tabs[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.black,
            currentIndex: _selectedIndex,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'Home'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Catagory'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.shop), label: 'Stores'),
              BottomNavigationBarItem(
                  icon: badge.Badge(
                      showBadge: snapshot.data!.docs.isEmpty ? false : true,
                      badgeStyle:
                          const badge.BadgeStyle(badgeColor: Colors.yellow),
                      badgeContent: Text(snapshot.data!.docs.length.toString()),
                      child: const Icon(Icons.dashboard)),
                  label: 'Dashboard'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.upload), label: 'Upload'),
            ],
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}
