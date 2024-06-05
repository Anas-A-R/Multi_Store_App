import 'package:flutter/material.dart';
import 'package:multi_store_app/category/accessories_category.dart';
import 'package:multi_store_app/category/bags_category.dart';
import 'package:multi_store_app/category/beauty_category.dart';
import 'package:multi_store_app/category/electronics_category.dart';
import 'package:multi_store_app/category/home_garden_category.dart';
import 'package:multi_store_app/category/kids_category.dart';
import 'package:multi_store_app/category/men_category.dart';
import 'package:multi_store_app/category/shoes_category.dart';
import 'package:multi_store_app/category/women_category.dart';
import 'package:multi_store_app/widgets/fake_search.dart';

List<Itemdata> items = [
  Itemdata(label: 'men'),
  Itemdata(label: 'women'),
  Itemdata(label: 'shoes'),
  Itemdata(label: 'bags'),
  Itemdata(label: 'electronics'),
  Itemdata(label: 'accessories'),
  Itemdata(label: 'home & garden'),
  Itemdata(label: 'kids'),
  Itemdata(label: 'beauty'),
];

class CatagoryScreen extends StatefulWidget {
  const CatagoryScreen({super.key});

  @override
  State<CatagoryScreen> createState() => _CatagoryScreenState();
}

class _CatagoryScreenState extends State<CatagoryScreen> {
  @override
  void initState() {
    super.initState();
    for (var element in items) {
      element.isSelected = false;
    }
    setState(() {
      items[0].isSelected = true;
    });
  }

  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const FakeSearch(),
      ),
      body: Stack(
        children: [
          Positioned(bottom: 0, left: 0, child: sideNavigator(deviceSize)),
          Positioned(bottom: 0, right: 0, child: catagoryView(deviceSize)),
        ],
      ),
    );
  }

  Widget sideNavigator(Size deviceSize) {
    return SizedBox(
      height: deviceSize.height * 0.8,
      width: deviceSize.width * 0.2,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(index,
                  curve: Curves.bounceInOut,
                  duration: const Duration(milliseconds: 100));
            },
            child: Container(
                color: items[index].isSelected == true
                    ? Colors.white
                    : Colors.grey.shade300,
                height: 100,
                child: Center(child: Text(items[index].label,textAlign: TextAlign.center,))),
          );
        },
      ),
    );
  }

  Widget catagoryView(Size deviceSize) {
    return Container(
      height: deviceSize.height * 0.8,
      width: deviceSize.width * 0.8,
      color: Colors.white,
      child: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: (value) {
          for (var element in items) {
            element.isSelected = false;
          }
          setState(() {
            items[value].isSelected = true;
          });
        },
        children: const [
          MenCategory(),
          WomenCategory(),
          ShoesCategory(),
          BagsCategory(),
          ElectronicsCategory(),
          AccessoriesCategory(),
          HomeGardenCategory(),
          KidsCategory(),
          BeautyCategory(),
        ],
      ),
    );
  }
}

class Itemdata {
  String label;
  bool isSelected;
  Itemdata({required this.label, this.isSelected = false});
}
