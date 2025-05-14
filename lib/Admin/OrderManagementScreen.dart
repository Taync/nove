import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderManagementScreen extends StatelessWidget {
  final ordersRef = FirebaseFirestore.instance.collection('orders');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Management")),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersRef.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;

              return ListTile(
                title: Text("Order ID: ${order.id}"),
                subtitle: Text(
                  "Status: ${data['status'] ?? 'Pending'}\nUser: ${data['userEmail'] ?? 'Unknown'}",
                ),
                isThreeLine: true,
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    ordersRef.doc(order.id).update({'status': value});
                  },
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(value: 'Pending', child: Text('Pending')),
                        PopupMenuItem(value: 'Shipped', child: Text('Shipped')),
                        PopupMenuItem(
                          value: 'Delivered',
                          child: Text('Delivered'),
                        ),
                        PopupMenuItem(
                          value: 'Cancelled',
                          child: Text('Cancelled'),
                        ),
                      ],
                  child: Icon(Icons.more_vert),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
