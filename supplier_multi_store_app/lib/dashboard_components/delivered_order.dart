import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supplier_multi_store_app/models/supplier_order_model.dart';

class Delivered extends StatelessWidget {
  const Delivered({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('supplier_id',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('delivery_status', isEqualTo: 'delivered')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text(
            "You May Not Have\n\nActive Order Yet ! ",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
                letterSpacing: 1.5,
                fontFamily: 'Acme'),
          ));
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return SupplierOrderModel(order: snapshot.data!.docs[index]);
          },
        );
      },
    );
  }
}
