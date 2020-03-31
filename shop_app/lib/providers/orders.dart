import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.products, this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken; 
  final String userId;

  Orders(this.authToken,this.userId, this._orders);

  List<OrderItem> get orders => [..._orders];

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://flutter-course-academind.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList()
        }));
    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timestamp,
          products: cartProducts),
    );

    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://flutter-course-academind.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData == null) return;
    extractedData.forEach((id, data) {
      loadedOrders.add(
        OrderItem(
          id: id,
          amount: data['amount'],
          dateTime: DateTime.parse(data['dateTime']),
          products: (data['products'] as List<dynamic>).map(
            (item) => CartItem(
                id: item['id'],
                price: item['price'],
                quantity: item['quantity'],
                title: item['title']),
          ).toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
