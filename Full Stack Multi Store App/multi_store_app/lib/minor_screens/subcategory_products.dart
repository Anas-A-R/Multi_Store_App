import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/models/product_model.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class SubCategoryProducts extends StatelessWidget {
  final String mainCategoryName;
  final String subCategoryName;
  final bool fromOnboarding;
  const SubCategoryProducts({
    super.key,
    required this.mainCategoryName,
    required this.subCategoryName,
    this.fromOnboarding = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: AppbarTitle(title: subCategoryName),
          centerTitle: true,
          leading: fromOnboarding
              ? IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/customer_home');
                  },
                  icon:
                      const Icon(Icons.arrow_back_ios_new, color: Colors.black))
              : const AppbarBackButton(),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('product_mainCategory', isEqualTo: mainCategoryName)
              .where('product_subCategory', isEqualTo: subCategoryName)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            print('main is : $mainCategoryName  sub is : $subCategoryName');
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
        ));
  }
}
