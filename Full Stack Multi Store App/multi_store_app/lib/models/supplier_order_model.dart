import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SupplierOrderModel extends StatelessWidget {
  final dynamic order;
  const SupplierOrderModel({super.key, required this.order});

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
                order['order_image'],
                fit: BoxFit.cover,
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    order['order_name'],
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
                        ('\$ ') + order['order_price'].toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey.shade600),
                      ),
                      Text(
                        (' x ') + order['order_quantity'].toString(),
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
            Text(order['delivery_status']),
          ],
        ),
        children: [
          Container(
            // height: 200,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.yellow.withOpacity(0.2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Name: ${order['customer_name']}'),
                Text('Phone Number: ${order['customer_phone']}'),
                Text('Email Address: ${order['customer_email']}'),
                Text('Address: ${order['customer_address']}'),
                Row(
                  children: [
                    const Text('Payment Status: '),
                    Text(
                      order['payment_status'],
                      style: const TextStyle(color: Colors.purple),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Delivery Status: '),
                    Text(
                      order['delivery_status'],
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Order Date: '),
                    Text(
                      DateFormat('yyyy-MM-dd')
                          .format(order['order_date'].toDate())
                          .toString(),
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                order['delivery_status'] == 'delivered'
                    ? const Text('This order has been delivered')
                    : Row(
                        children: [
                          const Text('Change delivery status to: '),
                          order['delivery_status'] == 'preparing'
                              ? TextButton(
                                  onPressed: () async {
                                    final DateTime? pickedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2101),
                                    );
                                    final formatedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate!);
                                    await FirebaseFirestore.instance
                                        .collection('orders')
                                        .doc(order['order_id'])
                                        .update({
                                      'delivery_status': 'shipping',
                                      'delivery_date': formatedDate,
                                    });
                                  },
                                  child: const Text('shipping ? '))
                              : TextButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('orders')
                                        .doc(order['order_id'])
                                        .update({
                                      'delivery_status': 'delivered',
                                    });
                                  },
                                  child: const Text('Delivered ? '))
                        ],
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
