import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ords = Provider.of<Orders>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Container(
            height: (MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height) *
                0.2,
            child: Card(
              elevation: 5,
              child: Column(
                children: [
                  Container(
                    height: ((MediaQuery.of(context).size.height -
                                AppBar().preferredSize.height) *
                            0.2) *
                        0.2,
                    color: Theme.of(context).primaryColor,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Sales(in ₹)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Today',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '₹${ords.saleToday}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.grey,
                          indent: 3,
                          endIndent: 3,
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Total',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '₹${ords.totalSale}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: (MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height) *
                0.2,
            child: Card(
              elevation: 5,
              child: Column(
                children: [
                  Container(
                    height: ((MediaQuery.of(context).size.height -
                                AppBar().preferredSize.height) *
                            0.2) *
                        0.2,
                    color: Theme.of(context).primaryColor,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Orders',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Cancelled',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '${ords.cancelledOrders.length}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.grey,
                          indent: 3,
                          endIndent: 3,
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Pending',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '${ords.pendingOrders.length}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.grey,
                          indent: 3,
                          endIndent: 3,
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Ongoing',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '${ords.dispatchedOrders.length}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
