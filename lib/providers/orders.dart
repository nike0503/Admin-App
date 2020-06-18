import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderProd {
  final String prodName;
  final int price;
  final int quantity;

  OrderProd({
    @required this.prodName,
    @required this.price,
    @required this.quantity,
  });
}

class OrderItem {
  final String title;
  final String userName;
  final String address;
  final String phone;
  final String id;
  final int amount;
  final List<OrderProd> products;
  final DateTime dateTime;
  final String status;

  OrderItem({
    @required this.title,
    @required this.userName,
    @required this.address,
    @required this.phone,
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
    @required this.status,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> _pendingOrders = [];
  List<OrderItem> _dispatchedOrders = [];
  List<OrderItem> _completedOrders = [];
  List<OrderItem> _cancelledOrders = [];
  int _totalSale = 0;
  int _saleToday = 0;

  List<OrderItem> get orders {
    return [..._orders];
  }

  List<OrderItem> get pendingOrders {
    return [..._pendingOrders];
  }

  List<OrderItem> get dispatchedOrders {
    return [..._dispatchedOrders];
  }

  List<OrderItem> get completedOrders {
    return [..._completedOrders];
  }

  List<OrderItem> get cancelledOrders {
    return [..._cancelledOrders];
  }

  int get totalSale {
    return _totalSale;
  }

  int get saleToday {
    return _saleToday;
  }

  Future<void> fetchAndSetOrders() async {
    List<OrderItem> allOrders = [];
    List<OrderItem> pendOrders = [];
    List<OrderItem> dispOrders = [];
    List<OrderItem> compOrders = [];
    List<OrderItem> cancOrders = [];
    List _userList = await Firestore.instance
        .collection('Users')
        .getDocuments()
        .then((snap) => snap.documents);
    if (_userList == null) {
      return null;
    }
    for (int i = 0; i < _userList.length; i++) {
      List<OrderItem> userOrders = [];
      List _orderList = await Firestore.instance
          .collection('Users')
          .document(_userList[i].documentID)
          .collection('Orders')
          .getDocuments()
          .then((snap) => snap.documents);
      for (int j = 0; j < _orderList.length; j++) {
        List<OrderProd> prods = (_orderList[j]['products'] as List<dynamic>)
            .map(
              (item) => OrderProd(
                prodName: item['prodName'],
                price: item['price'],
                quantity: item['quantity'],
              ),
            )
            .toList();
        String title = '';
        for(int i = 0; i < prods.length - 1; i++) {
          title += '${prods[i].prodName}, ';
        }
        title += '${prods[prods.length - 1].prodName}';
        OrderItem ord = OrderItem(
          title: title,
          userName: _userList[i]['username'],
          status: _orderList[j]['status'],
          id: _orderList[j].documentID,
          amount: _orderList[j]['amount'],
          address: _orderList[j]['address'],
          phone: _orderList[j]['phone'],
          products: (_orderList[j]['products'] as List<dynamic>)
              .map(
                (item) => OrderProd(
                  prodName: item['prodName'],
                  price: item['price'],
                  quantity: item['quantity'],
                ),
              )
              .toList(),
          dateTime: DateTime.parse(_orderList[j]['dateTime']),
        );
        userOrders.add(ord);
        switch (ord.status) {
          case 'pending':
            {
              pendOrders.add(ord);
            }
            break;

          case 'dispatched':
            {
              dispOrders.add(ord);
            }
            break;

          case 'completed':
            {
              compOrders.add(ord);
            }
            break;

          case 'cancelled':
            {
              cancOrders.add(ord);
            }
            break;
        }
      }
      allOrders.addAll(userOrders);
    }
    allOrders.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    _orders = allOrders;
    _pendingOrders = pendOrders;
    _dispatchedOrders = dispOrders;
    _cancelledOrders = cancOrders;
    _completedOrders = compOrders;
    int totSale = 0, saleTod = 0;
    for (int i = 0; i < _orders.length; i++) {
      totSale += _orders[i].amount;
      if (_orders[i].dateTime.difference(DateTime.now()).inDays == 0) {
        saleTod += _orders[i].amount;
      }
    }
    _totalSale = totSale;
    _saleToday = saleTod;
    notifyListeners();
  }
}
