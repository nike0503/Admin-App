import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/department.dart';
import '../screens/categories_overview_screen.dart';

class DepartmentItem extends StatelessWidget {
 
  void selectDepartment(BuildContext ctx, String name) {
    Navigator.of(ctx).pushNamed(
      CategoryOverviewScreen.routeName,
      arguments: name,
    );
  }

  @override
  Widget build(BuildContext context) {
    final department = Provider.of<Department>(context);
    return InkWell(
      onTap: () {
        selectDepartment(context, department.name);
      },
      splashColor: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(
          department.name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.8),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}
