import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './edit_department_screen.dart';
import '../providers/departments.dart';
import '../providers/login.dart';
import '../widgets/department_item.dart';

class DepartmentOverviewScreen extends StatefulWidget {
  static const routeName = '/department-names';
  @override
  _DepartmentOverviewScreenState createState() =>
      _DepartmentOverviewScreenState();
}

class _DepartmentOverviewScreenState extends State<DepartmentOverviewScreen> {
  var _isLoading = false;
  var _isInit = true;
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
      Provider.of<Departments>(context).getDepts(admin).then((_) {
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
        centerTitle: true,
        title: Text('Departments'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditDepartmentScreen.routeName,
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white60,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : dept.departments.length == 0
              ? Center(
                  child: Text('No Departments added till now'),
                )
              : GridView.builder(
                  itemCount: dept.departments.length,
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 5 / 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                      value: dept.departments[i], child: DepartmentItem()),
                ),
    );
  }
}
