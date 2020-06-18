import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/home_tabs.dart';
import './screens/departments_overview_screen.dart';
import './screens/categories_overview_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/edit_product_screen.dart';
import './providers/orders.dart';
import './providers/departments.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Departments(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Admin',
        theme: ThemeData(
          primaryColor: Colors.teal,
          textTheme: ThemeData.light().textTheme.copyWith(
                body1: TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                body2: TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                title: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
        home: HomeTabs(),
        routes: {
          DepartmentOverviewScreen.routeName: (ctx) =>
              DepartmentOverviewScreen(),
          CategoryOverviewScreen.routeName: (ctx) => CategoryOverviewScreen(),
          ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
          EditProductsScreen.routeName: (ctx) => EditProductsScreen(),
        },
      ),
    );
  }
}
