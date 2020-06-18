import 'package:flutter/material.dart';

import '../widgets/orders_list.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Pending'),
    Tab(text: 'Dispatched'),
    Tab(text: 'Completed'),
    Tab(text: 'Cancelled'),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(50.0 + MediaQuery.of(context).padding.top),
          child: SafeArea(
            child: AppBar(
              bottom: TabBar(tabs: myTabs),
            ),
          ),
        ),
        body: TabBarView(
          children: myTabs.map((Tab tab) {
            final String label = tab.text.toLowerCase();
            return OrdersList(label);
          }).toList(),
        ),
      ),
    );
  }
}
