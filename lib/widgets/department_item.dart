import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/department.dart';
import '../providers/departments.dart';
import '../providers/login.dart';
import '../screens/categories_overview_screen.dart';
import '../screens/edit_department_screen.dart';

class DepartmentItem extends StatelessWidget {
  void selectDepartment(BuildContext ctx, String name) {
    Navigator.of(ctx).pushNamed(
      CategoryOverviewScreen.routeName,
      arguments: name,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<SignIn>(context);
    final department = Provider.of<Department>(context);
    return InkWell(
      onTap: () {
        selectDepartment(context, department.name);
      },
      splashColor: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              department.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Container(
              width: 100,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          EditDepartmentScreen.routeName,
                          arguments: [department.name]);
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      try {
                        Provider.of<Departments>(context)
                            .getCats(auth.username, department.name);
                        if (Provider.of<Departments>(context)
                                .categories
                                .length !=
                            0) {
                          Scaffold.of(context).hideCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Delete all categories before deleting department',
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 2),
                          ));
                          return;
                        }
                        await Provider.of<Departments>(context, listen: false)
                            .deleteDepartment(department.name);
                      } catch (error) {
                        // scaffold.showSnackBar(
                        //   SnackBar(
                        //     content: Text(
                        //       'Deleting failed!',
                        //       textAlign: TextAlign.center,
                        //     ),
                        //   ),
                        // );
                      }
                    },
                    color: Theme.of(context).errorColor,
                  ),
                ],
              ),
            ),
          ],
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
