import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderProd {
  final String prodName;
  final int price;
  final int quantity;
  final String admin;
  String status;

  OrderProd({
    @required this.status,
    @required this.admin,
    @required this.prodName,
    @required this.price,
    @required this.quantity,
  });
}

class OrderItem {
  final String email;
  final String title;
  final String userName;
  final String address;
  final String phone;
  final String id;
  final int amount;
  final List<OrderProd> products;
  final DateTime dateTime;

  OrderItem({
    @required this.email,
    @required this.title,
    @required this.userName,
    @required this.address,
    @required this.phone,
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> _pendingOrders = [];
  List<OrderItem> _placedOrders = [];
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

  List<OrderItem> get placedOrders {
    return [..._placedOrders];
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

  Future<void> fetchAndSetOrders(String adminName) async {
    List<OrderItem> allOrders = [];
    List<OrderItem> pendOrders = [];
    List<OrderItem> placedOrders = [];
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
                status: item['status'],
                admin: item['admin'],
                prodName: item['prodName'],
                price: item['price'],
                quantity: item['quantity'],
              ),
            )
            .toList();
        prods.removeWhere((element) => element.admin != adminName);
        if (prods.length == 0) {
          continue;
        }

        for (int k = 0; k < prods.length; k++) {
          OrderItem ord = OrderItem(
            email: _userList[i]['email'],
            title: prods[k].prodName,
            userName: _userList[i]['username'],
            address: _orderList[j]['address'],
            phone: _orderList[j]['phone'],
            id: _orderList[j]['id'],
            amount: prods[k].price * prods[k].quantity,
            products: [prods[k]],
            dateTime: DateTime.parse(_orderList[j]['dateTime']),
          );

          userOrders.add(ord);
          switch (ord.products[0].status) {
            case 'pending':
              {
                pendOrders.add(ord);
              }
              break;

            case 'placed':
              {
                placedOrders.add(ord);
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
      }
      allOrders.addAll(userOrders);
    }
    allOrders.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    _orders = allOrders;
    _pendingOrders = pendOrders;
    _placedOrders = placedOrders;
    _dispatchedOrders = dispOrders;
    _cancelledOrders = cancOrders;
    _completedOrders = compOrders;
    _pendingOrders.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    _placedOrders.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    _dispatchedOrders.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    _cancelledOrders.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    _completedOrders.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    int totSale = 0, saleTod = 0;
    for (int i = 0; i < _orders.length; i++) {
      if (_orders[i].products[0].status != 'pending' &&
          _orders[i].products[0].status != 'cancelled') {
        totSale += _orders[i].amount;
        if (_orders[i].dateTime.difference(DateTime.now()).inDays == 0) {
          saleTod += _orders[i].amount;
        }
      }
    }
    _totalSale = totSale;
    _saleToday = saleTod;
    notifyListeners();
  }

  Future<void> updateStatus(
      String adminName, OrderItem ord, String status) async {
    switch (ord.products[0].status) {
      case 'pending':
        {
          switch (status) {
            case 'placed':
              {
                _pendingOrders.remove(ord);
                _orders[_orders.indexOf(ord)].products[0].status = status;
                ord.products[0].status = status;
                _placedOrders.add(ord);
                _totalSale += ord.products[0].quantity * ord.products[0].price;
                if (ord.dateTime.difference(DateTime.now()).inDays == 0) {
                  _saleToday += ord.amount;
                }
                break;
              }
            case 'dispatched':
              {
                _pendingOrders.remove(ord);
                _orders[_orders.indexOf(ord)].products[0].status = status;
                ord.products[0].status = status;
                _dispatchedOrders.add(ord);
                _totalSale += ord.products[0].quantity * ord.products[0].price;
                if (ord.dateTime.difference(DateTime.now()).inDays == 0) {
                  _saleToday += ord.amount;
                }
              }
              break;

            case 'completed':
              {
                _pendingOrders.remove(ord);
                _orders[_orders.indexOf(ord)].products[0].status = status;
                ord.products[0].status = status;
                _completedOrders.add(ord);
                _totalSale += ord.products[0].quantity * ord.products[0].price;
                if (ord.dateTime.difference(DateTime.now()).inDays == 0) {
                  _saleToday += ord.amount;
                }
              }
              break;
          }
        }
        break;

      case 'placed':
        {
          switch (status) {
            case 'dispatched':
              {
                _placedOrders.remove(ord);
                _orders[_orders.indexOf(ord)].products[0].status = status;
                ord.products[0].status = status;
                _dispatchedOrders.add(ord);
              }
              break;

            case 'completed':
              {
                _placedOrders.remove(ord);
                _orders[_orders.indexOf(ord)].products[0].status = status;
                ord.products[0].status = status;
                _completedOrders.add(ord);
              }
              break;
          }
        }
        break;

      case 'dispatched':
        {
          switch (status) {
            case 'completed':
              {
                _dispatchedOrders.remove(ord);
                _orders[_orders.indexOf(ord)].products[0].status = status;
                ord.products[0].status = status;
                _completedOrders.add(ord);
              }
              break;
          }
        }
        break;
    }
    notifyListeners();

    List userList = await Firestore.instance
        .collection('Users')
        .getDocuments()
        .then((value) => value.documents);
    var neededUser =
        userList.firstWhere((element) => element['email'] == ord.email);
    DocumentSnapshot document = await Firestore.instance
        .collection('Users')
        .document(neededUser['email'])
        .collection('Orders')
        .getDocuments()
        .then((snap) => snap.documents.firstWhere((element) {
              return element['id'] == ord.id;
            }));

    List<OrderProd> prods = (document['products'] as List<dynamic>)
        .map(
          (item) => OrderProd(
            status: item['status'],
            admin: item['admin'],
            prodName: item['prodName'],
            price: item['price'],
            quantity: item['quantity'],
          ),
        )
        .toList();
    await Firestore.instance
        .collection('Users')
        .document(neededUser['email'])
        .collection('Orders')
        .document(document.documentID.toString())
        .updateData({
      'products': prods
          .map((cp) => {
                'status': cp.prodName == ord.products[0].prodName
                    ? status
                    : cp.status,
                'admin': cp.admin,
                'price': cp.price,
                'prodName': cp.prodName,
                'quantity': cp.quantity,
              })
          .toList(),
    });
    notifyListeners();
  }

  Future<void> cancelOrder(String adminName, OrderItem ord) async {
    switch (ord.products[0].status) {
      case 'pending':
        {
          _pendingOrders.remove(ord);
          _orders[_orders.indexOf(ord)].products[0].status = 'cancelled';
          ord.products[0].status = 'cancelled';
          _cancelledOrders.add(ord);
          _totalSale -= ord.products[0].quantity * ord.products[0].price;
          if (ord.dateTime.difference(DateTime.now()).inDays == 0) {
            _saleToday -= ord.amount;
          }
        }
        break;

      case 'placed':
        {
          _placedOrders.remove(ord);
          _orders[_orders.indexOf(ord)].products[0].status = 'cancelled';
          ord.products[0].status = 'cancelled';
          _cancelledOrders.add(ord);
          _totalSale -= ord.products[0].quantity * ord.products[0].price;
          if (ord.dateTime.difference(DateTime.now()).inDays == 0) {
            _saleToday -= ord.amount;
          }
        }
        break;
    }
    notifyListeners();
    List _departList = await Firestore.instance
        .collection('Departments')
        .getDocuments()
        .then((snap) => snap.documents);
    for (int l = 0; l < ord.products.length; l++) {
      for (int i = 0; i < _departList.length; i++) {
        List _catList = await Firestore.instance
            .collection('Departments')
            .document(_departList[i].documentID.toString())
            .collection("Categories")
            .getDocuments()
            .then((snap) => snap.documents);
        for (int j = 0; j < _catList.length; j++) {
          List _prodList = await Firestore.instance
              .collection('Departments')
              .document(_departList[i].documentID.toString())
              .collection("Categories")
              .document(_catList[j].documentID.toString())
              .collection('Products')
              .getDocuments()
              .then((snap) => snap.documents);
          for (int k = 0; k < _prodList.length; k++) {
            if (_prodList[k]['name'] == ord.products[l].prodName) {
              Firestore.instance
                  .collection('Departments')
                  .document(_departList[i].documentID.toString())
                  .collection("Categories")
                  .document(_catList[j].documentID.toString())
                  .collection('Products')
                  .document(_prodList[k].documentID.toString())
                  .updateData({
                'quantity': _prodList[k]['quantity'] + ord.products[l].quantity,
                'isAvailable':
                    _prodList[k]['quantity'] + ord.products[l].quantity != 0
              });
            }
          }
        }
      }
    }

    List userList = await Firestore.instance
        .collection('Users')
        .getDocuments()
        .then((value) => value.documents);
    var neededUser =
        userList.firstWhere((element) => element['username'] == ord.userName);
    DocumentSnapshot document = await Firestore.instance
        .collection('Users')
        .document(neededUser['email'])
        .collection('Orders')
        .getDocuments()
        .then((snap) =>
            snap.documents.firstWhere((element) => element['id'] == ord.id));

    List<OrderProd> prods = (document['products'] as List<dynamic>)
        .map(
          (item) => OrderProd(
            status: item['status'],
            admin: item['admin'],
            prodName: item['prodName'],
            price: item['price'],
            quantity: item['quantity'],
          ),
        )
        .toList();

    await Firestore.instance
        .collection('Users')
        .document(neededUser['email'])
        .collection('Orders')
        .document(document.documentID.toString())
        .updateData({
      'products': prods
          .map((cp) => {
                'status': cp.admin == adminName ? 'cancelled' : cp.status,
                'admin': cp.admin,
                'price': cp.price,
                'prodName': cp.prodName,
                'quantity': cp.quantity,
              })
          .toList(),
    });

    notifyListeners();
  }
}
