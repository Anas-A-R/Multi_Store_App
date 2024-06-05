import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/minor_screens/edit_store.dart';
import 'package:multi_store_app/models/product_model.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class VisitStoreScreen extends StatefulWidget {
  final String supplierID;
  const VisitStoreScreen({super.key, required this.supplierID});

  @override
  State<VisitStoreScreen> createState() => _VisitStoreScreenState();
}

class _VisitStoreScreenState extends State<VisitStoreScreen> {
  bool follow = false;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
        .collection('products')
        .where('supplier_id', isEqualTo: widget.supplierID)
        .snapshots();
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('suppliers')
            .doc(widget.supplierID)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
                child: Center(child: CircularProgressIndicator()));
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Center(child: Text("Document does not exist"));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: Colors.blueGrey.shade100,
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.yellow,
                    )),
                toolbarHeight: 150,
                flexibleSpace: snapshot.data!['cover_image'] == ''
                    ? Image.asset(
                        'images/inapp/coverimage.jpg',
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        snapshot.data!['cover_image'],
                        fit: BoxFit.cover,
                      ),
                title: Row(
                  children: [
                    Container(
                      height: 80,
                      width: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.yellow, width: 5),
                          borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          snapshot.data!['store_logo'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!['store_name'],
                            style: const TextStyle(
                                fontSize: 20, color: Colors.yellow),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              snapshot.data!['sid'] ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? SizedBox(
                                      height: 30,
                                      child: YellowButton(
                                          label: 'Edit',
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditStoreScreen(
                                                    data: snapshot.data!,
                                                  ),
                                                ));
                                          },
                                          widthInPercent: 0.3),
                                    )
                                  : SizedBox(
                                      height: 30,
                                      child: YellowButton(
                                          label:
                                              follow ? "Following" : 'Follow',
                                          onPressed: () {
                                            setState(() {
                                              follow = !follow;
                                            });
                                          },
                                          widthInPercent: 0.3),
                                    ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              body: StreamBuilder<QuerySnapshot>(
                stream: productStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Material(
                        child: Center(child: CircularProgressIndicator()));
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text(
                      "This Store\n\nHas No Data Yet ! ",
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
                      staggeredTileBuilder: (index) =>
                          const StaggeredTile.fit(1),
                    ),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                backgroundColor: Colors.green,
                onPressed: () {},
                child: const Icon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            );
          }

          return const Material(
              child: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
