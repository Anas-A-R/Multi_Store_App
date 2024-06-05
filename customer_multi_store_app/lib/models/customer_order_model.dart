import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:customer_multi_store_app/widgets/yellow_button.dart';

class CustomerOrderModel extends StatefulWidget {
  final dynamic order;
  const CustomerOrderModel({super.key, required this.order});

  @override
  State<CustomerOrderModel> createState() => _CustomerOrderModelState();
}

class _CustomerOrderModelState extends State<CustomerOrderModel> {
  late double rating;
  late String comment;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.yellow,
          )),
      margin: const EdgeInsets.all(10),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              margin: const EdgeInsets.only(right: 20),
              child: Image.network(
                widget.order['order_image'],
                fit: BoxFit.cover,
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.order['order_name'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey.shade600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ('\$ ') + widget.order['order_price'].toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey.shade600),
                      ),
                      Text(
                        (' x ') + widget.order['order_quantity'].toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey.shade600),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('See More'),
            Text(widget.order['delivery_status']),
          ],
        ),
        children: [
          Container(
            // height: 200,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: widget.order['delivery_status'] == 'delivered'
                    ? Colors.brown.withOpacity(0.2)
                    : Colors.yellow.withOpacity(0.2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Name: ${widget.order['customer_name']}'),
                Text('Phone Number: ${widget.order['customer_phone']}'),
                Text('Email Address: ${widget.order['customer_email']}'),
                Text('Address: ${widget.order['customer_address']}'),
                Row(
                  children: [
                    const Text('Payment Status: '),
                    Text(
                      widget.order['payment_status'],
                      style: const TextStyle(color: Colors.purple),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Delivery Status: '),
                    Text(
                      widget.order['delivery_status'],
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                widget.order['delivery_status'] == 'shipping'
                    ? Text(
                        'Estimated Delivery Date: ${DateFormat('yyyy-MM-dd').format(widget.order['order_date'].toDate()).toString()}')
                    : const Text(''),
                widget.order['delivery_status'] == 'delivered' &&
                        widget.order['order_review'] == false
                    ? TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Material(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    RatingBar.builder(
                                      initialRating: 2,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      updateOnDrag: true,
                                      onRatingUpdate: (value) {
                                        setState(() {
                                          rating = value;
                                        });
                                      },
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                          hintText: 'Enter your review',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.grey, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.yellow,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                      onChanged: (value) {
                                        comment = value.toString();
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        YellowButton(
                                            label: 'Cancel',
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            widthInPercent: 0.4),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        YellowButton(
                                            label: 'Ok',
                                            onPressed: () async {
                                              CollectionReference
                                                  reviewsCollection =
                                                  FirebaseFirestore.instance
                                                      .collection('products')
                                                      .doc(widget
                                                          .order['product_id'])
                                                      .collection('reviews');
                                              await reviewsCollection
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .set({
                                                'name': widget
                                                    .order['customer_name'],
                                                'email': widget
                                                    .order['customer_email'],
                                                'profile_image': widget
                                                    .order['customer_profile'],
                                                'rating': rating,
                                                'review': comment,
                                              }).whenComplete(() async {
                                                await FirebaseFirestore.instance
                                                    .runTransaction(
                                                        (transaction) async {
                                                  DocumentReference
                                                      documentReference =
                                                      FirebaseFirestore.instance
                                                          .collection('orders')
                                                          .doc(widget.order[
                                                              'order_id']);
                                                  transaction.update(
                                                      documentReference, {
                                                    'order_review': true,
                                                  });
                                                });
                                              });
                                              Future.delayed(const Duration(
                                                      microseconds: 100))
                                                  .whenComplete(() =>
                                                      Navigator.pop(context));
                                            },
                                            widthInPercent: 0.4),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: const Text('Write Review'))
                    : const Text(''),
                widget.order['delivery_status'] == 'delivered' &&
                        widget.order['order_review'] == true
                    ? const Row(
                        children: [
                          Icon(Icons.check, color: Colors.blue),
                          Text(
                            'Review added',
                            style: TextStyle(fontSize: 15, color: Colors.blue),
                          )
                        ],
                      )
                    : const Text(''),
              ],
            ),
          )
        ],
      ),
    );
  }
}
