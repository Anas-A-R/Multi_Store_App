import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';

class StaticsScreen extends StatelessWidget {
  const StaticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
              child: Center(child: CircularProgressIndicator()));
        }
        num itemCount = 0;
        for (var item in snapshot.data!.docs) {
          itemCount += item['order_quantity'];
        }

        double totalPrice = 0.0;
        for (var item in snapshot.data!.docs) {
          totalPrice += item['order_price'] * item['order_quantity'];
        }

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: const AppbarTitle(title: 'Statics Screen'),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StaticsModel(
                  label: 'Sold Out',
                  value: snapshot.data!.docs.length.toString(),
                  decimalPoints: 0,
                ),
                StaticsModel(
                  label: 'Item Count',
                  value: itemCount.toString(),
                  decimalPoints: 0,
                ),
                StaticsModel(
                  label: 'Balance',
                  value: totalPrice.toStringAsFixed(2),
                  decimalPoints: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StaticsModel extends StatelessWidget {
  final String label;
  final dynamic value;
  final int decimalPoints;
  const StaticsModel({
    super.key,
    required this.label,
    required this.value,
    required this.decimalPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          height: 80,
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: const BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
            alignment: Alignment.center,
            height: 100,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            child: AnimatedCounter(
              count: double.parse(value),
              decimal: decimalPoints,
            )),
      ],
    );
  }
}

class AnimatedCounter extends StatefulWidget {
  final int decimal;
  final dynamic count;
  const AnimatedCounter(
      {super.key, required this.count, required this.decimal});

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = _controller;
    setState(() {
      _animation = Tween<double>(begin: _animation.value, end: widget.count)
          .animate(_controller);
    });
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          _animation.value.toStringAsFixed(widget.decimal),
          style: const TextStyle(
              letterSpacing: 2,
              fontSize: 30,
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontFamily: 'Acme'),
        );
      },
    );
  }
}
