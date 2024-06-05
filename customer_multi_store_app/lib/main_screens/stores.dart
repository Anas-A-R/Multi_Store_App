import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:customer_multi_store_app/minor_screens/visit_store.dart';
import 'package:customer_multi_store_app/widgets/appbar_widgets.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppbarTitle(title: 'Stores'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('suppliers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 25,
                    crossAxisSpacing: 25,
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VisitStoreScreen(
                                  supplierID: snapshot.data!.docs[index]
                                      ['sid'])));
                    },
                    child: Column(
                      children: [
                        Stack(children: [
                          SizedBox(
                              height: 120,
                              width: 120,
                              child: Image.asset('images/inapp/store.jpg')),
                          Positioned(
                            top: 45,
                            child: SizedBox(
                                height: 48,
                                width: 120,
                                child: Image.network(
                                  snapshot.data!.docs[index]['store_logo'],
                                  fit: BoxFit.cover,
                                )),
                          )
                        ]),
                        Text(
                          snapshot.data!.docs[index]['store_name'],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const Text('no data available');
        },
      ),
    );
  }
}
