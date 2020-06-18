import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/departments.dart';
import '../widgets/category_item.dart';

class CategoryOverviewScreen extends StatefulWidget {
  static const routeName = '/category-names';
  @override
  _CategoryOverviewScreenState createState() => _CategoryOverviewScreenState();
}

class _CategoryOverviewScreenState extends State<CategoryOverviewScreen> {
  var _isLoading = false;
  var _isInit = true;
  String deptName;

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
      deptName = ModalRoute.of(context).settings.arguments as String;
      Provider.of<Departments>(context).getCats(deptName).then((_) {
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
        title: Text(
            dept.departments.firstWhere((dept) => dept.name == deptName).name),
        centerTitle: true,
      ),
      backgroundColor: Colors.white60,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              itemCount: dept.categories.length,
              padding: const EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 5 / 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                value: dept.categories[i],
                child: CategoryItem(deptName),
              ),
            ),
    );
  }
}
