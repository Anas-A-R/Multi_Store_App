import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/models/product_model.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class BeautyGalleryScreen extends StatefulWidget {
  const BeautyGalleryScreen({super.key});

  @override
  State<BeautyGalleryScreen> createState() => BeautyGalleryScreenState();
}

class BeautyGalleryScreenState extends State<BeautyGalleryScreen> {
  final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
      .collection('products')
      .where('product_mainCategory', isEqualTo: 'beauty')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _productStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
    );
  }
}
