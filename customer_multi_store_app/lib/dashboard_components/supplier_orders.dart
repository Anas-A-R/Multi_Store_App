import 'package:flutter/material.dart';
import 'package:customer_multi_store_app/dashboard_components/delivered_order.dart';
import 'package:customer_multi_store_app/dashboard_components/preparing_order.dart';
import 'package:customer_multi_store_app/dashboard_components/shipping_order.dart';
import 'package:customer_multi_store_app/main_screens/home.dart';
import 'package:customer_multi_store_app/widgets/appbar_widgets.dart';

class SupplierOrders extends StatelessWidget {
  const SupplierOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const AppbarTitle(title: 'Orders'),
            centerTitle: true,
            bottom: const TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 8,
                indicatorColor: Colors.yellow,
                tabs: [
                  RepeatedTab(label: 'Preparing'),
                  RepeatedTab(label: 'Shipping'),
                  RepeatedTab(label: 'Delivered')
                ]),
          ),
          body: const TabBarView(
              children: [Preparing(), Shipping(), Delivered()]),
        ));
  }
}
