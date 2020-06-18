import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart';

class OrdersList extends StatelessWidget {
  final String orderType;

  OrdersList(this.orderType);

  @override
  Widget build(BuildContext context) {
    final ord = Provider.of<Orders>(context);
    List<OrderItem> reqOrders = [];
    switch (orderType) {
      case 'pending':
        {
          reqOrders = ord.pendingOrders;
        }
        break;

      case 'dispatched':
        {
          reqOrders = ord.dispatchedOrders;
        }
        break;

      case 'completed':
        {
          reqOrders = ord.completedOrders;
        }
        break;

      case 'cancelled':
        {
          reqOrders = ord.cancelledOrders;
        }
        break;
    }

    if (reqOrders.length == 0) {
      return Center(
        child: Text('No $orderType orders found'),
      );
    }
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: GridView.count(
              crossAxisCount: 1,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 2.7,
              children: reqOrders
                  .map((item) => Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: (MediaQuery.of(context).size.height -
                                  AppBar().preferredSize.height -
                                  50.0) *
                              0.35,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '#${item.id}',
                                    style: TextStyle(
                                        color: Colors.teal,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    child: Text('${item.amount}'),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: ((MediaQuery.of(context).size.height -
                                            AppBar().preferredSize.height -
                                            50.0) *
                                        0.35) *
                                    0.05,
                              ),
                              Text(
                                '${item.userName}',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '${item.title}',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy hh:mm')
                                    .format(item.dateTime),
                              ),
                              SizedBox(
                                height: ((MediaQuery.of(context).size.height -
                                            AppBar().preferredSize.height -
                                            50.0) *
                                        0.35) *
                                    0.05,
                              ),
                              Text(
                                '${item.address}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
