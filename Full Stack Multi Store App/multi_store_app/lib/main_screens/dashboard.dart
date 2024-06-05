// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/dashboard_components/edit_business.dart';
import 'package:multi_store_app/dashboard_components/manage_products.dart';
import 'package:multi_store_app/dashboard_components/supplier_balance.dart';
import 'package:multi_store_app/dashboard_components/supplier_orders.dart';
import 'package:multi_store_app/dashboard_components/supplier_statics.dart';
import 'package:multi_store_app/minor_screens/visit_store.dart';
import 'package:multi_store_app/providers/auth_repo.dart';
import 'package:multi_store_app/widgets/alert_dialog.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';

List<String> label = [
  'MY STORES',
  'ORDERS',
  'EDIT PROFILE',
  'MANAGE PRODUCTS',
  'BALANCE',
  'STATICS'
];

List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.edit,
  Icons.settings,
  Icons.attach_money,
  Icons.show_chart
];

List<Widget> pages = [
  VisitStoreScreen(supplierID: FirebaseAuth.instance.currentUser!.uid),
  const SupplierOrders(),
  const EditBusiness(),
  const ManageProducts(),
  const BalanceScreen(),
  const StaticsScreen(),
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppbarTitle(
          title: 'Dashboard',
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                MyAlertDialog().showAlertDialog(
                    title: 'Log Out',
                    content: 'Are you sure to log out ?',
                    tabNo: () {
                      Navigator.pop(context);
                    },
                    tabYes: () async {
                      Navigator.of(context).pop();
                      AuthRepo.logOut();
                      Navigator.pushReplacementNamed(
                          context, '/welcome_screen');
                    },
                    context: context);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GridView.count(
          mainAxisSpacing: 50,
          crossAxisSpacing: 50,
          crossAxisCount: 2,
          children: List.generate(
              6,
              (index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => pages[index],
                          ));
                    },
                    child: Card(
                      shadowColor: Colors.purpleAccent.shade200,
                      elevation: 20,
                      color: Colors.blueGrey.withOpacity(0.7),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            icons[index],
                            color: Colors.yellowAccent,
                            size: 50,
                          ),
                          Text(
                            label[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                                fontFamily: 'Acme'),
                          )
                        ],
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}
