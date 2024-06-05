import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/galleries/men_gallery.dart';
import 'package:multi_store_app/minor_screens/hot_deals.dart';
import 'package:multi_store_app/minor_screens/subcategory_products.dart';

enum Offers {
  jeans,
  discount,
  suit,
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  Timer? countdownTimer;
  int seconds = 5;
  int? maxDiscount;
  List<int> discountList = [];
  late int selectedIndex;
  late String offerName;
  late String assetName;
  late Offers offers;
  late Animation<Color?> colorTweenAnimation;
  late AnimationController _animationController;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    colorTweenAnimation = ColorTween(begin: Colors.black, end: Colors.amber)
        .animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.repeat();
    selectRandonOffer();
    // startTimer();
    getDiscount();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds--;
      });
      if (seconds < 0) {
        stopTimer();
        Navigator.pushReplacementNamed(context, '/customer_home');
      }
    });
  }

  stopTimer() {
    countdownTimer!.cancel();
  }

  navigate() {
    switch (offers) {
      case Offers.jeans:
        Navigator.pushAndRemoveUntil(
            context,
            (MaterialPageRoute(
              builder: (context) {
                return const SubCategoryProducts(
                    fromOnboarding: true,
                    mainCategoryName: 'men',
                    subCategoryName: 'jeans');
              },
            )),
            (route) => false);
        break;
      case Offers.discount:
        Navigator.pushAndRemoveUntil(
            context,
            (MaterialPageRoute(
              builder: (context) {
                return HotDealsScreen(
                  maxDiscount: maxDiscount.toString(),
                  fromOnboarding: true,
                );
              },
            )),
            (route) => false);
        break;
      case Offers.suit:
        Navigator.pushAndRemoveUntil(
            context,
            (MaterialPageRoute(
              builder: (context) {
                return const MenGalleryScreen(fromOnboarding: true);
              },
            )),
            (route) => false);
        break;
    }
  }

  getDiscount() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var item in querySnapshot.docs) {
        discountList.add(item['product_discount']);
      }
    }).whenComplete(() => setState(() {
              maxDiscount = discountList.reduce(max);
            }));
  }

  void selectRandonOffer() {
    for (var i = 0; i < Offers.values.length; i++) {
      var random = Random();
      setState(() {
        selectedIndex = random.nextInt(3);
        offerName = Offers.values[selectedIndex].toString();
        assetName = offerName.replaceAll('Offers.', '');
        offers = Offers.values[selectedIndex];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        GestureDetector(
          onTap: () {
            navigate();
            stopTimer();
          },
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'images/onboard/$assetName.jpg',
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          child: AnimatedBuilder(
            animation: _animationController.view,
            child: const Text(
              'SHOP NOW',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            builder: (context, child) {
              return Container(
                  alignment: Alignment.center,
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: colorTweenAnimation.value),
                  child: child);
            },
          ),
        ),
      ]),
    ));
  }
}
