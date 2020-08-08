import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import './home_screen.dart';
import './orders_screen.dart';
import './profile_screen.dart';
import '../providers/orders.dart';
import '../providers/login.dart';

class HomeTabs extends StatefulWidget {
  @override
  _HomeTabsState createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String admin;
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
      admin = Provider.of<SignIn>(context).username;
      Provider.of<Orders>(context).fetchAndSetOrders(admin).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();

    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });

    setState(() {
      _isLoading = true;
    });

    Provider.of<Orders>(context).fetchAndSetOrders(admin).then((_) {
      setState(() {
        _isLoading = false;
      });
    });

    return completer.future.then<void>((_) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
              label: 'RETRY',
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              })));
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<SignIn>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedPageIndex != 2
              ? pages[_selectedPageIndex]['title']
              : auth.username,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return FlatButton(
              onPressed: () {
                auth.signOut();
              },
              child: Text('Sign Out'),
            );
          })
        ],
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : LiquidPullToRefresh(
              color: Colors.teal,
              onRefresh: _handleRefresh,
              showChildOpacityTransition: false,
              child: pages[_selectedPageIndex]['page'],
            ),
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
