import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import './screens/splash_screen.dart';
import './screens/departments_overview_screen.dart';
import './screens/categories_overview_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/edit_category_screen.dart';
import './screens/edit_department_screen.dart';
import './providers/orders.dart';
import './providers/departments.dart';
import './providers/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        ChangeNotifierProvider.value(
          value: SignIn(),
        )
      ],
      child: Consumer<SignIn>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Admin',
          theme: ThemeData(
            primaryColor: Colors.teal,
            textTheme: ThemeData.light().textTheme.copyWith(
                  bodyText1: TextStyle(
                    fontSize: 10,
                  ),
                  subtitle1: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          home: SplashScreen(),
          routes: {
            DepartmentOverviewScreen.routeName: (ctx) =>
                DepartmentOverviewScreen(),
            CategoryOverviewScreen.routeName: (ctx) => CategoryOverviewScreen(),
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            EditProductsScreen.routeName: (ctx) => EditProductsScreen(),
            EditCategoryScreen.routeName: (ctx) => EditCategoryScreen(),
            EditDepartmentScreen.routeName: (ctx) => EditDepartmentScreen(),
          },
        ),
      ),
    );
  }
}
