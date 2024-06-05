import 'package:flutter/material.dart';
import 'package:customer_multi_store_app/galleries/accessories_gallery.dart';
import 'package:customer_multi_store_app/galleries/bags_gallery.dart';
import 'package:customer_multi_store_app/galleries/beauty_gallery.dart';
import 'package:customer_multi_store_app/galleries/electronics_gallery.dart';
import 'package:customer_multi_store_app/galleries/homeandgarden_gallery.dart';
import 'package:customer_multi_store_app/galleries/kids_gallery.dart';
import 'package:customer_multi_store_app/galleries/men_gallery.dart';
import 'package:customer_multi_store_app/galleries/shoes_gallery.dart';
import 'package:customer_multi_store_app/galleries/women_gallery.dart';
import 'package:customer_multi_store_app/widgets/fake_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100.withOpacity(0.5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title:
              // GestureDetector(
              //   onTap: () async {
              //     String result = await sendNotification('title', 'body');
              //     print(
              //         '$result ______________________________________________________________');
              //   },
              //   child: Container(
              //     width: double.infinity,
              //     height: 50,
              //     color: Colors.amber,
              //   ),
              // ),
              const FakeSearch(),
          bottom: const TabBar(
              padding: EdgeInsets.all(0),
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.yellow,
              indicatorWeight: 4,
              tabs: [
                RepeatedTab(label: 'Men'),
                RepeatedTab(label: 'Women'),
                RepeatedTab(label: 'Shoes'),
                RepeatedTab(label: 'Bags'),
                RepeatedTab(label: 'Electronics'),
                RepeatedTab(label: 'Accessories'),
                RepeatedTab(label: 'Home and Garden'),
                RepeatedTab(label: 'Kids'),
                RepeatedTab(label: 'Beauty'),
              ]),
        ),
        body: const TabBarView(children: [
          MenGalleryScreen(),
          WomenGalleryScreen(),
          ShoesGalleryScreen(),
          BagsGalleryScreen(),
          ElectronicsGalleryScreen(),
          AccessoriesGalleryScreen(),
          HomeandGardenGalleryScreen(),
          KidsGalleryScreen(),
          BeautyGalleryScreen(),
        ]),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;
  const RepeatedTab({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(label),
    );
  }
}
