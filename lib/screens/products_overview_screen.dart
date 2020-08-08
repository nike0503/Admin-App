import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './edit_product_screen.dart';
import '../providers/departments.dart';
import '../providers/login.dart';
import '../widgets/product_item.dart';

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/products';
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isLoading = false;
  var _isInit = true;
  var ids;
  String catName;
  String deptName;
  String admin;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      admin = Provider.of<SignIn>(context).username;
      ids = ModalRoute.of(context).settings.arguments as List;
      catName = ids[0];
      deptName = ids[1];
      Provider.of<Departments>(context).getProds(admin, deptName, catName).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final dept = Provider.of<Departments>(context);
    return Scaffold(
      appBar: AppBar(
        title:
            Text(dept.categories.firstWhere((cat) => cat.name == catName).name),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductsScreen.routeName,
                  arguments: [catName, deptName]);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white60,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : dept.products.length == 0
              ? Center(
                  child: Text('No Products in this category'),
                )
              : Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(8),
                        itemCount: dept.products.length,
                        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                          value: dept.products[i],
                          child: ProductItem(
                            catName: catName,
                            deptName: deptName,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
