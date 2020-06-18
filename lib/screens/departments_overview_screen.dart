import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/departments.dart';
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
      Provider.of<Departments>(context).getDepts().then((_) {
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
      ),
      backgroundColor: Colors.white60,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
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
