import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './home_screen.dart';
import './orders_screen.dart';
import './profile_screen.dart';
import '../providers/orders.dart';

class HomeTabs extends StatefulWidget {
  @override
  _HomeTabsState createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
  List<Map<String, Object>> pages;
  int _selectedPageIndex = 0;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    pages = [
      {
        'page': HomeScreen(),
        'title': 'Home',
      },
      {
        'page': OrdersScreen(),
        'title': 'Orders',
      },
      {
        'page': ProfileScreen(),
        'title': 'Profile',
      }
    ];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Orders>(context).fetchAndSetOrders().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pages[_selectedPageIndex]['title'],
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        unselectedItemColor: Colors.black87,
        selectedItemColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            title: Text('Orders'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}
