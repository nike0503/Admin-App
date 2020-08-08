import 'package:flutter/material.dart';

import '../widgets/orders_list.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final List<String> orderTypes = [
    'pending',
    'placed',
    'dispatched',
    'completed',
    'cancelled',
  ];
  @override
  Widget build(BuildContext context) {
    final List<Tab> myTabs = <Tab>[
      Tab(
        child: Text(
          'Pending',
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.02),
        ),
      ),
      Tab(
        child: Text(
          'Placed',
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.02),
        ),
      ),
      Tab(
        child: Text(
          'Dispatched',
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.02),
        ),
      ),
      Tab(
        child: Text(
          'Completed',
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.02),
        ),
      ),
      Tab(
        child: Text(
          'Cancelled',
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.02),
        ),
      ),
    ];
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(50.0 + MediaQuery.of(context).padding.top),
          child: SafeArea(
            child: AppBar(
              bottom: TabBar(tabs: myTabs),
              textTheme: Theme.of(context).textTheme,
            ),
          ),
        ),
        body: TabBarView(
          children: myTabs.map((Tab tab) {
            final String label =
                orderTypes[myTabs.indexWhere((element) => element == tab)];
            return OrdersList(label);
          }).toList(),
        ),
      ),
    );
  }
}
