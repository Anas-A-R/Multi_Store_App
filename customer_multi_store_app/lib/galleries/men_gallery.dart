import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:customer_multi_store_app/models/product_model.dart';
import 'package:customer_multi_store_app/widgets/appbar_widgets.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class MenGalleryScreen extends StatefulWidget {
  final bool fromOnboarding;
  const MenGalleryScreen({super.key, this.fromOnboarding = false});

  @override
  State<MenGalleryScreen> createState() => _MenGalleryScreenState();
}

class _MenGalleryScreenState extends State<MenGalleryScreen> {
  final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
      .collection('products')
      .where('product_mainCategory', isEqualTo: 'men')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.fromOnboarding
          ? AppBar(
              title: const AppbarTitle(
                title: 'Men suits',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
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
    );
  }
}
