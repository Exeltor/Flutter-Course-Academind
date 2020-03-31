import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // error handling
            } else {
              return Consumer<Orders>(
                builder: (context, orderData, _) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (context, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
