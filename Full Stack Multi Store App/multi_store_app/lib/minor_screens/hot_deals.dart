import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/models/product_model.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class HotDealsScreen extends StatefulWidget {
  final bool fromOnboarding;
  final String maxDiscount;
  const HotDealsScreen(
      {super.key, this.fromOnboarding = false, required this.maxDiscount});

  @override
  State<HotDealsScreen> createState() => _HotDealsScreenState();
}

class _HotDealsScreenState extends State<HotDealsScreen> {
  final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
      .collection('products')
      .where('product_discount', isNotEqualTo: 0)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.fromOnboarding
          ? AppBar(
              title: const AppbarTitle(
                title: 'Hot Deals',
              ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/customer_home');
                  },
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.black)),
            )
          : null,
      body: Column(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.black,
            alignment: Alignment.center,
            child: Text(
              'Get up to ${widget.maxDiscount} % off',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _productStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text(
                  "This Category\n\nHas No Data Yet ! ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                      letterSpacing: 1.5,
                      fontFamily: 'Acme'),
                ));
              }
              return SingleChildScrollView(
                child: StaggeredGridView.countBuilder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  itemBuilder: (context, index) {
                    return ProductModel(
                      product: snapshot.data!.docs[index],
                    );
                  },
                  staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
