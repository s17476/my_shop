import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_shop/models/cart_item.dart';
import 'package:my_shop/models/http_exception.dart';
import 'package:my_shop/models/order_item.dart';
import 'package:my_shop/providers/product.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  String? authToken;
  String? userId;

  Orders();

  Orders.auth(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final _ordersUrl = Uri.parse(
        'https://flutter-myshop-49e90-default-rtdb.europe-west1.firebasedatabase.app/users/$userId/orders.json?auth=$authToken');
    final response = await http.get(_ordersUrl);
    if (response.body == 'null') {
      return;
    }
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    extractedData.forEach((orderId, orderData) {
      loadedOrders.insert(
        0,
        OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                      id: item['id'],
                      quantity: item['quantity'],
                      product: Product.ordersScreenBuilder(
                        title: item['title'],
                        price: item['price'],
                      ),
                    ))
                .toList()),
      );
    });
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartItems, double totalAmount) async {
    final timeStamp = DateTime.now();
    final _ordersUrl = Uri.parse(
        'https://flutter-myshop-49e90-default-rtdb.europe-west1.firebasedatabase.app/users/$userId/orders.json?auth=$authToken');
    try {
      final response = await http.post(
        _ordersUrl,
        body: json.encode(
          {
            'amount': totalAmount,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartItems
                .map(
                  (item) => {
                    'id': item.product.id,
                    'title': item.product.title,
                    'quantity': item.quantity,
                    'price': item.product.price,
                  },
                )
                .toList(),
          },
        ),
      );
      if (response.statusCode >= 400) {
        throw HttpException(statusCode: response.statusCode);
      }
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: totalAmount,
          products: cartItems,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
